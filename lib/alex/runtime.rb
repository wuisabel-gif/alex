require "json"

module Alex
  class Runtime
    attr_reader :session

    def initialize(agent:, session:, provider:, approval:, output: $stdout, style: nil)
      @agent, @session, @provider, @approval, @output, @style = agent, session, provider, approval, output, style
    end

    def run(prompt)
      @session.messages << { "role" => "user", "content" => prompt }
      turns = 0
      loop do
        turns += 1
        raise "maximum agent turns (#{@agent.max_turns}) exceeded" if turns > @agent.max_turns
        response = @provider.complete(messages: @session.messages, system: Instructions.system(agent: @agent, plugin: @agent.plugin_system, style: Divergence.instruction(@style)),
                                      tools: @agent.tools.values.map(&:provider_schema),
                                      temperature: 0.2, max_tokens: 2000)
        response.tool_calls.each do |call|
          execute_tool(call)
        end
        unless response.tool_calls.any?
          @session.messages << { "role" => "assistant", "content" => response.text }
          return response.text
        end
      end
    ensure
      yield @session if block_given?
    end

    private

    def execute_tool(call)
      name = call["name"] || call[:name]
      args = call["input"] || call[:input] || {}
      tool = @agent.tools[name]
      raise "Agent requested unknown tool: #{name}" unless tool
      unless !tool.requires_approval || @approval.allow?(name, args)
        @session.messages << { "role" => "user", "content" => "Tool #{name} was denied." }
        return
      end
      result = tool.call(args)
      @session.messages << { "role" => "user", "content" => Instructions.untrusted("tool_output", JSON.generate(tool_result: { name: name, result: result })) }
    rescue StandardError => e
      @session.messages << { "role" => "user", "content" => Instructions.untrusted("tool_error", JSON.generate(tool_error: { name: name, error: e.message })) }
    end
  end
end

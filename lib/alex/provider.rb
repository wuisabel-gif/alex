require "json"
require "net/http"
require "uri"

module Alex
  module Provider
    Response = Struct.new(:text, :tool_calls, :raw, keyword_init: true)

    class Echo
      def initialize(**); end
      def complete(messages:, **)
        last = messages.reverse.find { |m| m["role"] == "user" }
        Response.new(text: "Echo: #{last && last["content"]}", tool_calls: [], raw: {})
      end
    end

    class Anthropic
      API_URL = URI("https://api.anthropic.com/v1/messages")
      def initialize(api_key: ENV["ANTHROPIC_API_KEY"], model: "claude-sonnet-4-6")
        raise "Set ANTHROPIC_API_KEY to use the Anthropic provider." if api_key.to_s.empty?
        @api_key, @model = api_key, model
      end

      def complete(messages:, system: nil, tools: [], temperature: 0.2, max_tokens: 2000, **)
        request = Net::HTTP::Post.new(API_URL)
        request["content-type"] = "application/json"
        request["x-api-key"] = @api_key
        request["anthropic-version"] = "2023-06-01"
        request.body = JSON.generate(model: @model, max_tokens: max_tokens, temperature: temperature,
                                     system: system, messages: messages, tools: tools)
        response = Net::HTTP.start(API_URL.host, API_URL.port, use_ssl: true, read_timeout: 120) { |http| http.request(request) }
        body = JSON.parse(response.body)
        unless response.is_a?(Net::HTTPSuccess)
          raise "API error #{response.code}: #{body.dig("error", "message") || response.body}"
        end
        blocks = body.fetch("content", [])
        Response.new(text: blocks.select { |b| b["type"] == "text" }.map { |b| b["text"] }.join("\n"),
                     tool_calls: blocks.select { |b| b["type"] == "tool_use" }, raw: body)
      rescue JSON::ParserError
        raise "Provider returned invalid JSON (HTTP #{response&.code})"
      end
    end

    def self.build(name, model: nil)
      case name.to_s
      when "echo" then Echo.new
      when "anthropic" then Anthropic.new(model: model || "claude-sonnet-4-6")
      else raise "Unknown provider: #{name} (try echo or anthropic)"
      end
    end
  end
end

module Alex
  class Approval
    MODES = %w[always ask never].freeze

    def initialize(mode: "ask", input: $stdin, output: $stdout)
      raise ArgumentError, "approval must be always, ask, or never" unless MODES.include?(mode.to_s)
      @mode, @input, @output = mode.to_s, input, output
    end

    def allow?(tool_name, arguments)
      return true if @mode == "always"
      return false if @mode == "never"
      @output.print "Allow tool #{tool_name}(#{arguments.inspect})? [y/N] "
      @input.gets.to_s.strip.downcase == "y"
    end
  end
end

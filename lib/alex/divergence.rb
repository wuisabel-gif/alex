module Alex
  module Divergence
    STYLES = {
      "practical" => "Build the most concrete, actionable answer. Name steps, constraints, examples, and tests.",
      "contrarian" => "Challenge the obvious approach. State the hidden assumption you reject and defend a viable alternative.",
      "visual" => "Think spatially and concretely. Use an analogy, storyboard, map, or worked example to make the idea tangible.",
      "systems" => "Analyze relationships, feedback loops, second-order effects, stakeholders, and failure modes.",
      "playful" => "Explore surprising but coherent possibilities. Use imaginative combinations without sacrificing factual honesty.",
      "skeptical" => "Act as a rigorous critic. Separate facts from guesses, identify uncertainty, and propose ways to test the idea."
    }.freeze

    def self.styles(count = 5)
      STYLES.keys.first([count.to_i, STYLES.length].min)
    end

    def self.instruction(style)
      return nil if style.nil? || style.to_s == "adaptive"
      STYLES.fetch(style.to_s) { raise ArgumentError, "unknown style '#{style}' (try: #{STYLES.keys.join(', ')})" }
    end

    def self.assignments(count)
      styles(count).map { |style| [style, STYLES.fetch(style)] }
    end
  end
end

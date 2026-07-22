module Alex
  Agent = Struct.new(:name, :system, :tools, :provider, :model, :max_turns, :plugin_system, keyword_init: true)

  module Agents
    def self.default(config)
      Agent.new(name: "default", system: "You are Alex, a careful and capable software agent. Use tools only when necessary.",
                tools: Tools.registry, provider: config["provider"], model: config["model"], max_turns: config["max_turns"])
    end

    def self.clockwork(config)
      Agent.new(name: "clockwork-orange", system: "You are a forced-divergence agent. Offer genuinely different reasoning paths, not cosmetic rewrites.",
                tools: Tools.registry, provider: config["provider"], model: config["model"], max_turns: config["max_turns"],
                plugin_system: "Use the Clockwork Orange divergence strategy when the user requests a reroll.")
    end

    def self.build(name, config)
      case name.to_s
      when "default" then default(config)
      when "clockwork-orange", "clockwork" then clockwork(config)
      else raise "Unknown agent: #{name} (try default or clockwork-orange)"
      end
    end
  end
end

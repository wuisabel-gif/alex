module Alex
  module Plugins
    module ClockworkOrange
      def self.available?
        path = ENV["CLOCKWORK_ORANGE_PATH"]
        path && File.file?(File.join(path, "lib/clockwork_orange/reroll.rb"))
      end

      def self.reroll(bad_answer:, original_prompt:, dissatisfaction:, mode: :drastic, versions: 5)
        path = ENV.fetch("CLOCKWORK_ORANGE_PATH")
        require File.join(path, "lib/clockwork_orange/reroll")
        ::ClockworkOrange::Reroll.new(original_prompt: original_prompt, bad_answer: bad_answer,
                                      dissatisfaction: dissatisfaction, mode: mode, versions: versions).run
      end
    end
  end
end

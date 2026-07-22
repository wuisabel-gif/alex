require "json"
require "fileutils"

module Alex
  class Config
    DEFAULT_PATH = File.join(Dir.home, ".alex", "config.json")

    attr_reader :data

    def initialize(data = {})
      @data = {
        "provider" => "echo",
        "model" => "default",
        "approval" => "ask",
        "max_turns" => 8
      }.merge(data)
    end

    def self.load(path = DEFAULT_PATH)
      return new unless File.file?(path)
      new(JSON.parse(File.read(path)))
    rescue JSON::ParserError => e
      raise "Invalid Alex config #{path}: #{e.message}"
    end

    def [](key)
      @data[key.to_s]
    end

    def save(path = DEFAULT_PATH)
      FileUtils.mkdir_p(File.dirname(path), mode: 0o700)
      File.write(path, JSON.pretty_generate(@data) + "\n", mode: "w", perm: 0o600)
      path
    end
  end
end

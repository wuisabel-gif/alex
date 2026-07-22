require "json"
require "securerandom"
require "time"
require "fileutils"

module Alex
  Session = Struct.new(:id, :agent, :messages, :created_at, :updated_at, keyword_init: true)

  class SessionStore
    attr_reader :directory

    def initialize(directory = File.join(Dir.home, ".alex", "sessions"))
      @directory = directory
      FileUtils.mkdir_p(@directory, mode: 0o700)
    end

    def create(agent: "default")
      now = Time.now.utc.iso8601
      session = Session.new(id: SecureRandom.uuid, agent: agent, messages: [], created_at: now, updated_at: now)
      save(session)
    end

    def save(session)
      session.updated_at = Time.now.utc.iso8601
      path = File.join(@directory, "#{session.id}.json")
      File.write(path, JSON.pretty_generate(session.to_h) + "\n", mode: "w", perm: 0o600)
      session
    end

    def load(id)
      session_id = id.to_s
      raise "Invalid session id" unless session_id.match?(/\A[A-Za-z0-9_-]+\z/)
      path = File.join(@directory, "#{session_id}.json")
      raise "Session not found: #{id}" unless File.file?(path)
      data = JSON.parse(File.read(path))
      Session.new(id: data["id"], agent: data["agent"], messages: data["messages"],
                  created_at: data["created_at"], updated_at: data["updated_at"])
    rescue JSON::ParserError => e
      raise "Invalid session #{id}: #{e.message}"
    end

    def list
      Dir.glob(File.join(@directory, "*.json")).sort.map do |path|
        data = JSON.parse(File.read(path))
        Session.new(id: data["id"], agent: data["agent"], messages: data["messages"],
                    created_at: data["created_at"], updated_at: data["updated_at"])
      rescue JSON::ParserError
        nil
      end.compact.sort_by(&:updated_at).reverse
    end
  end
end

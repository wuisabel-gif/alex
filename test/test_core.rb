#!/usr/bin/env ruby
require "tmpdir"
require_relative "../lib/alex"

class CapturingEcho < Alex::Provider::Echo
  attr_reader :system

  def complete(messages:, system:, **kwargs)
    @system = system
    super(messages: messages, **kwargs)
  end
end

Dir.mktmpdir("alex-test") do |dir|
  store = Alex::SessionStore.new(File.join(dir, "sessions"))
  session = store.create(agent: "default")
  provider = CapturingEcho.new
  runtime = Alex::Runtime.new(
    agent: Alex::Agents.default(Alex::Config.new),
    session: session,
    provider: provider,
    approval: Alex::Approval.new(mode: "never")
  )
  answer = runtime.run("hello") { |updated| store.save(updated) }
  raise "echo provider" unless answer == "Echo: hello"
  raise "platform policy" unless provider.system.include?("Follow Alex platform policy")
  raise "agent policy" unless provider.system.include?("You are Alex")
  restored = store.load(session.id)
  raise "session persistence" unless restored.messages.last["content"] == answer
  raise "path escape" unless begin
    Alex::Tools.read_file(dir, "../secret")
    false
  rescue RuntimeError
    true
  end
end

raise "missing style" unless Alex::Divergence.instruction("contrarian").include?("obvious approach")
raise "too few perspectives" unless Alex::Divergence.assignments(6).length == 6
puts "ok: runtime, instruction hierarchy, sessions, tools, and divergence"

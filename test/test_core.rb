#!/usr/bin/env ruby
require "tmpdir"
require_relative "../lib/alex"

Dir.mktmpdir("alex-test") do |dir|
  store = Alex::SessionStore.new(File.join(dir, "sessions"))
  session = store.create(agent: "default")
  runtime = Alex::Runtime.new(
    agent: Alex::Agents.default(Alex::Config.new),
    session: session,
    provider: Alex::Provider::Echo.new,
    approval: Alex::Approval.new(mode: "never")
  )
  answer = runtime.run("hello") { |updated| store.save(updated) }
  raise "echo provider" unless answer == "Echo: hello"
  restored = store.load(session.id)
  raise "session persistence" unless restored.messages.last["content"] == answer
  raise "path escape" unless begin
    Alex::Tools.read_file(dir, "../secret")
    false
  rescue RuntimeError
    true
  end
end

puts "ok: runtime, sessions, and tool boundary"

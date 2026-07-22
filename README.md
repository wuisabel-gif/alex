# Alex

A general-purpose agent harness for models, tools, subagents, and approvals.

Alex is intended to provide the reusable orchestration layer for agentic
workflows, while specialized behaviors—such as Clockwork Orange's forced-
divergence rerolls—can live in plugins or integrations.

## Planned capabilities

- Provider and model adapters
- Persistent sessions with resume support
- Tool execution with explicit approval boundaries
- Delegation to specialized subagents
- Streaming events and structured logs
- Agent configuration and plugin loading
- Safe, testable execution policies

## Repository relationship

[`clockwork-orange`](https://github.com/wuisabel-gif/clockwork-orange) is a
specialized reroll engine and prospective first plugin for Alex. It remains an
independent project while Alex's core interfaces are developed.

## Status

Early scaffold. APIs are not stable yet.

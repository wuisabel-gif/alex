# Alex

A general-purpose agent harness for models, tools, subagents, and approvals.

Alex is intended to provide the reusable orchestration layer for agentic
workflows, while specialized behaviors—such as [Clockwork Orange](https://github.com/wuisabel-gif/clockwork-orange)'s forced-
divergence rerolls—can live in plugins or integrations.

## Quick start

Alex runs safely with the deterministic `echo` provider by default:

```bash
bin/alex run "inspect this repository" --provider echo
bin/alex session list
bin/alex run "summarize the project" --session SESSION_ID
bin/alex doctor
```

Use Anthropic when `ANTHROPIC_API_KEY` is configured:

```bash
bin/alex run "review the code" --provider anthropic --model claude-sonnet-4-6
```

Tools are bounded to the selected working directory. Shell tools require
approval by default; use `--approval never` to deny them or `--approval always`
only in a trusted environment.

## Current architecture

- `Alex::Provider` — provider-neutral model interface with Echo and Anthropic adapters
- `Alex::Runtime` — bounded agent loop and tool-call execution
- `Alex::SessionStore` — local JSON session persistence and resume
- `Alex::Approval` — explicit tool approval policy
- `Alex::Agents` — named agent definitions
- `Alex::Plugins::ClockworkOrange` — integration boundary for [Clockwork Orange](https://github.com/wuisabel-gif/clockwork-orange)

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

Early, runnable foundation. APIs are not stable yet. The next milestones are
streaming events, richer tool-call handling, subagent delegation, provider
configuration, and stronger sandboxing.

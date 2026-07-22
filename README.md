# Alex

A general-purpose agent harness for models, tools, subagents, and approvals.

Alex is intended to be style-adaptive. It can communicate as a practical
planner, contrarian critic, visual explainer, systems thinker, playful
ideator, or skeptical reviewer. This is especially useful for brainstorming:
different perspectives create more possibilities than repeatedly rewording one
answer.

Like people, an AI becomes more useful when it makes room for different
perspectives, voices, disciplines, and ways of solving problems. Alex should
adapt to the user rather than impose one personality: structured when
precision matters, exploratory when ideas are needed, and concise when clarity
matters. Diversity is not decoration; it is a way to produce better options
while keeping the user in control.

## Quick start

Alex runs safely with the deterministic `echo` provider by default:

```bash
bin/alex run "inspect this repository" --provider echo
bin/alex session list
bin/alex run "summarize the project" --session SESSION_ID
bin/alex doctor
bin/alex brainstorm "How could a neighborhood share energy?" --versions 6
bin/alex run "Review this idea" --style skeptical --provider echo
```

Use Anthropic when `ANTHROPIC_API_KEY` is configured:

```bash
bin/alex run "review the code" --provider anthropic --model claude-sonnet-4-6
```

Tools are bounded to the selected working directory. Shell tools require
approval by default; use `--approval never` to deny them or `--approval always`
only in a trusted environment.

## Instruction hierarchy

Alex uses an explicit instruction hierarchy when composing a model request:

```text
Alex platform policy (highest priority)
  → agent policy
  → plugin policy
  → user request
  → files and tool output (untrusted data)
```

The platform policy prevents lower-level content from redefining Alex's safety
rules, bypassing approvals, or exposing hidden instructions. Tool results are
wrapped as untrusted data before they are returned to the model. This lets the
[Clockwork Orange](https://github.com/wuisabel-gif/clockwork-orange) plugin add
its forced-divergence behavior without replacing Alex's platform safeguards.

## Current architecture

- `Alex::Instructions` — composes platform, agent, and plugin policy and marks tool output as untrusted
- `Alex::Divergence` — provides genuinely different communication and reasoning styles for brainstorming
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

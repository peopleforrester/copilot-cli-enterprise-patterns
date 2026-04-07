# Custom Agents (`.agent.md`)

Copilot CLI supports user-defined subagents via `.agent.md` files. They sit alongside the five built-ins (Explore, Plan, Task, Code Review, Critic) and can be invoked explicitly or auto-delegated.

## Locations (searched in this order)

1. `~/.copilot/agents/` — user-level, available in every project
2. `.github/agents/` — project-level, checked into the repo
3. `.github-private/agents/` — project-level, gitignored

Project-level agents with the same `name` as a user-level agent override the user-level one.

## File format

A `.agent.md` file is Markdown with YAML frontmatter, body up to 30,000 characters.

```markdown
---
name: security-reviewer
description: Reviews diffs for secrets, injection, and auth flaws. Invoke before any PR touching auth code.
tools:
  - read
  - shell(rg*)
  - shell(gitleaks*)
model: claude-opus-4-6
visible: true
handoffs:
  - code-review
mcp-servers:
  - github
---

You are a security reviewer. Your job is to find:

1. Hardcoded secrets, API keys, tokens
2. SQL/command injection sinks
3. Broken auth or authz checks
4. Unsafe deserialization

For each finding, cite the file and line. Do not suggest fixes unless asked.
```

## Frontmatter fields

| Field | Purpose |
|---|---|
| `name` | Unique identifier. Invoked as `/agents name` or `--agent name` |
| `description` | One-line summary. Used by auto-delegation to decide when to route work here |
| `tools` | Allowlist of tools this agent can use. Uses the same pattern syntax as `--allow-tool` |
| `model` | Override the session model for this agent only |
| `visible` | If false, hidden from `/agents` list but still invocable |
| `handoffs` | Other agents this one may delegate to |
| `mcp-servers` | Which configured MCP servers this agent can reach |

## Invocation

- `/agents` — list available agents
- `/agents <name>` — invoke explicitly
- `copilot --agent <name> -p "..."` — programmatic invocation
- **Auto-delegation** — the primary agent may route a task to a custom agent whose `description` matches the work

## Deduplication

Agents are deduplicated by `name`. Project-level entries override user-level. This lets a team ship a hardened `security-reviewer` in `.github/agents/` that overrides any looser personal version.

## When to write a custom agent

- You have a repeated review pattern that doesn't fit a Skill (Skills are procedures; agents are personas with tool scopes and models)
- You want a tool-restricted agent (read-only code reviewer, for example)
- You want to pin a specific model for a specific role (Opus 4.6 for architecture review, Haiku for doc polish)
- You want an agent the primary can hand off to via `handoffs`

## When NOT to write a custom agent

- The task is a procedure — write a Skill instead
- The task is a one-off — just prompt the primary agent
- You're trying to hide context — agents don't solve context hygiene, `/compact` and Plan mode do

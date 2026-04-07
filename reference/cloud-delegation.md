# Cloud Delegation

Copilot CLI can hand long-running work off to a GitHub-hosted runner and keep going locally. This is the `&` prefix and the `/delegate`, `/tasks`, `/resume` commands.

## Why delegate

- The task takes >10 minutes and you don't want to block your terminal
- The task needs to run against a clean environment (CI-like)
- You want a draft PR at the end instead of a dirty working tree
- You want CodeQL, dependency review, and secret scanning to run as part of the work

## The primitives

| Command | What it does |
|---|---|
| `& <prompt>` | Prefix: send this turn to a cloud runner instead of running locally |
| `/delegate <prompt>` | Explicit form of the same thing |
| `/tasks` | List your active and completed cloud tasks |
| `/resume <task-id>` | Pull the task's context back into your local session |
| `/share gist` | Publish the current session transcript as a gist |

## What runs on the cloud

- A GitHub Actions runner spun up with your repo checked out at the current branch
- The same Copilot CLI binary, the same skills, the same hooks
- Your repo's `AGENTS.md` and `.github/copilot-instructions.md` apply
- MCP servers configured at `~/.copilot/mcp-config.json` do **not** follow you to the runner — only repo-level config does

## Outputs

- A draft PR on the branch the task created (`copilot/task-<id>` by default)
- CodeQL results posted as PR checks
- Dependency review and secret scanning results as PR checks
- The full transcript is attached to the task and retrievable via `/resume`

## When to delegate

- "Upgrade all of our dependencies and fix the test failures" — perfect
- "Refactor this module across 40 files" — good, review the PR locally
- "Run a long test suite and summarize failures" — good
- "Quick edit to this one file" — no, just do it locally

## When not to delegate

- Anything requiring interactive judgment you can't pre-specify
- Anything touching local-only config or secrets
- Tasks that need access to private MCP servers on your laptop
- Work you want to feel every keystroke of (teaching, debugging, exploration)

## Governance

- Cloud tasks run under your identity and show up in the GitHub audit log
- Org admins can disable cloud delegation via the Copilot admin console
- The runner respects branch protection — it will open a PR, not force-push
- Secret scanning on the draft PR catches anything the agent accidentally wrote

## Mental model

Cloud delegation is *your CI runner with an agent driving it*. Not a background daemon, not a distributed agent mesh. If you'd be comfortable letting a junior engineer do the task on a clean VM with your repo and no secrets, delegate it.

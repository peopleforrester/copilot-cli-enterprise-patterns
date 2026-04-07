# Copilot CLI Command Reference

Every command, what it does, when to use it. Current as of April 2026.

## Session control

| Command | What it does | When to use |
|---|---|---|
| `/clear` | Wipe the conversation; keep working directory | Between unrelated tasks. The *one feature per session* rule. |
| `/usage` | Show current token consumption | Before starting a long task; when responses feel sluggish |
| `/diff` | Show every file change in the current session | Before any commit |
| `/help` | List available commands | When the command you remember doesn't work |
| `/quit` | Exit Copilot CLI | End of work |
| `/continue` | Resume the previous session in this repo | Returning to work after a break |

## Planning and execution

| Command | What it does | When to use |
|---|---|---|
| `Shift+Tab` | Toggle Plan Mode | Anything touching >1 file |
| `/plan` | Explicitly request a plan for the current task | When you forgot to enter Plan Mode first |
| `/approve` | Approve the current plan and execute | After reviewing a plan |
| `/cancel` | Discard the current plan | When the plan is wrong enough to start over |

## Model and config

| Command | What it does | When to use |
|---|---|---|
| `/model` | List or switch models (Sonnet 4.6 default; Opus 4.6, GPT-5.3-Codex, Gemini 3 Pro) | See `reference/model-selection-2026.md` |
| `/config` | Show current config | Debugging "why isn't my hook running?" |
| `/permissions` | Show or modify permission rules | Granting one-off approvals |

## Skills, memory, hooks

| Command | What it does | When to use |
|---|---|---|
| `/skills` | List available Skills | Discovering what's installed |
| `/memory` | View or edit repository memory | Reviewing what the agent has learned about this repo |
| `/hooks` | List active hooks | Verifying a hook is wired up |

## Subagents

| Command / Trigger | What it does | When to use |
|---|---|---|
| `/explore <query>` | Spawn the Explore subagent | Broad codebase searches that would pollute main context |
| `/review` | Spawn the Code Review subagent on current diff | Before committing a non-trivial change |
| `/task <description>` | Spawn a generic task subagent | One-shot research or computation |

## File operations

These are tool calls the agent makes; you don't run them directly. Listed for awareness because they show up in `/diff` and hook matchers.

| Tool | Description |
|---|---|
| `Read` | Read a file or page range |
| `Edit` | Apply a single edit to an existing file |
| `MultiEdit` | Apply multiple edits to one file in one call |
| `Write` | Create a new file or fully overwrite |
| `Bash` | Run a shell command |
| `Grep` | Ripgrep-backed content search |
| `Glob` | File pattern match |

## Git integration

Copilot CLI uses the GitHub MCP for issues, PRs, and branches. You can ask in natural language ("show open PRs", "create an issue") and it will use the MCP rather than shelling out to `gh`. You can still call `gh` manually when you want explicit control.

## What's *not* a command

Things people expect to be commands but aren't:
- **`/compact`** — Copilot CLI compacts automatically at ~95%; there is no manual compact command. Use `/clear` instead when you want a hard reset.
- **`/think`** — Extended thinking is automatic. Don't try to force it.
- **`/web`** — Web fetching is a tool, not a slash command. Ask the agent to fetch a URL.

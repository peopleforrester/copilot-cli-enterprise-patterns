# Copilot CLI Command Reference

Every command, what it does, when to use it. Current as of April 2026 (v1.0.18+).

## Session control

| Command | What it does | When to use |
|---|---|---|
| `/clear` | Wipe the conversation; keep working directory | Between unrelated tasks. The *one feature per session* rule. |
| `/compact` | Manually compact conversation history | When you want to compact before auto-compaction kicks in at 95% |
| `/context` | Show token-by-token context breakdown | When you want to see what's filling the window |
| `/usage` | Show session stats and consumption | Pre-flight long tasks |
| `/diff` | Show every file change in the current session, with syntax-highlighted inline diffs | Before any commit |
| `/undo` | Undo the most recent action | When the agent did the wrong thing |
| `Esc-Esc` | Open a timeline picker to rewind file changes to a previous snapshot | Larger rollback than `/undo` |
| `/help` | List available commands | When the command you remember doesn't work |
| `/quit`, `exit` | Exit Copilot CLI | End of work |

## Modes

| Action | Effect |
|---|---|
| `Shift+Tab` | Cycle modes: **Standard → Plan → Autopilot → Standard** |
| `!<cmd>` | **Shell mode** — run a command directly without invoking the model. Orthogonal to the mode cycle. |
| `--max-autopilot-continues N` | Cap the number of autonomous continuations in Autopilot |
| `Ctrl+C` | Interrupt Autopilot or any in-progress action |

| Mode | What it does | When to use |
|---|---|---|
| **Standard** | Default. Approves each tool call. | Daily work, sensitive areas |
| **Plan** | Read/search/propose only. No edits. | Any non-trivial change |
| **Autopilot** | Runs without per-tool approval until done | Only when your hooks are bulletproof. See `patterns/autopilot-mode.md`. |

## Planning

| Command | What it does |
|---|---|
| `/plan` | Explicitly request a plan for the current task |
| Plan Mode itself | Forces planning before any edit (entered via `Shift+Tab`) |

## Sessions and resume

| Command | What it does |
|---|---|
| `/resume` | Switch between local and remote sessions; tab-cycles available sessions, grouped by branch and repo |
| `--resume TASK_ID` | Jump directly into a specific background task |
| `/tasks` | View active background tasks. Per-task: Enter to view, `k` to kill, `r` to remove |
| `&<prompt>` | **Cloud delegate** — short for `/delegate`. Hands the task to the GitHub Actions cloud agent and frees your terminal. |
| `/delegate` | Explicit cloud delegation |
| `/share gist` | Share session as a gist (blocked for Enterprise Managed Users) |

## Subagents and /fleet

| Command | What it does |
|---|---|
| `/fleet` | Dispatch parallel subagents from a plan; uses a SQLite DB for dependency-aware tracking. Default: low-cost model to conserve premium requests. |
| `/review` | Code Review subagent on staged/unstaged changes |
| Auto-delegation | The agent dispatches Explore, Plan, Code Review, Critic, Task subagents when their expertise applies |

The five built-in subagents:

| Name | Purpose |
|---|---|
| **Explore** | Fast codebase analysis in an isolated context |
| **Plan** | Dependency analysis, structured implementation plans |
| **Task** | Run commands; brief on success, full output on failure |
| **Code Review** | High-signal change review (also via `/review`) |
| **Critic** *(v1.0.18, experimental)* | Reviews plans/implementations using a complementary model. Currently Claude-only. |

## Model and config

| Command | What it does |
|---|---|
| `/model` | Interactive model picker (Available / Blocked / Upgrade tabs) |
| `/model <id>` | Switch model for the current session |
| `--reasoning-effort`, `--effort` | Control reasoning depth on supported models |
| `--customize` (v1.0.7) | Customize mode |
| `/config` | Show current config |
| `/permissions` | Show or modify permission rules |
| `/allow-all`, `/yolo` | One-way enable: bypass all permission prompts for the rest of the session |
| `/reset-allowed-tools` | Revert session-grant approvals |

## Skills

| Command | What it does |
|---|---|
| `/skills` | Pop the skills picker / list |
| `/skills list` | List available skills |
| `/skills info <name>` | Show skill details |
| `/<skill-name>` | Invoke a `user-invocable: true` skill directly |

## Memory

| Command | What it does |
|---|---|
| `/memory` | View or edit repository memory (Pro/Pro+ public preview) |
| `memory_storage` tool | Cross-session memory tool the agent calls automatically |

## Hooks and MCPs

| Command | What it does |
|---|---|
| `/hooks` | List active hooks |
| `/mcp add` | Interactive MCP install form |
| `/mcp show` | List configured MCPs |
| `/mcp edit <server>` | Edit an MCP entry |
| `/mcp delete <server>` | Remove |
| `/mcp enable\|disable <server>` | Toggle |
| `--enable-all-github-mcp-tools` | Enable the full GitHub MCP toolset |
| `--disable-builtin-mcps` | Disable built-in MCPs |
| `--disable-mcp-server github` | Disable a specific built-in |
| `--allow-tool='MyMCP(tool)'`, `--deny-tool='MyMCP(tool)'` | Tool-level access control |
| `--additional-mcp-config /path/to/extra.json` | Per-session MCP override |

## Plugins

| Command | What it does |
|---|---|
| `copilot plugin install <name>@<marketplace>` | Install from marketplace |
| `copilot plugin install <git-url>` | Install from Git |
| `copilot plugin install ssh://...` | Install from SSH (v0.0.422+) |
| `copilot plugin update` | Update all installed plugins |
| `copilot plugin list` | List installed |
| `copilot plugin marketplace add <repo>` | Register a marketplace |
| `copilot plugin marketplace browse <name>` | Browse a marketplace |
| `--plugin-dir /path` | Use a local plugin directory |

## Programmatic / scripted

```bash
copilot -p "your prompt" --output-format json
```

Single-shot scriptable usage; emits JSONL output. Useful for CI and automation.

## File operation tools (the agent calls these)

These are tool calls the agent makes; you don't run them directly. Listed for awareness because they show up in `/diff` and hook matchers.

| Tool | Description |
|---|---|
| `read` | Read a file or page range |
| `edit` (Edit) | Apply a single edit to an existing file |
| `write` | Create a new file or fully overwrite |
| `shell` | Run a shell command |
| `search` / `grep` | Content search |

## What's *not* a command (myth-busting)

- **`/think`** — extended thinking is automatic on supported models. Use `--reasoning-effort` to influence it.
- **No "compact threshold" command** — auto-compaction triggers at 95% and the threshold is currently fixed (open feature request #1761).
- **No `/web` command** — web fetching is a tool, not a slash command. Ask the agent to fetch a URL.

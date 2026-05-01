# Command Reference (Quick Card)

A printable one-pager. For full detail, see `reference/copilot-cli-commands.md`.

## Session

| Key / Command | Action |
|---|---|
| `Shift+Tab` | Cycle modes (Standard → Plan → Autopilot) |
| `!<cmd>` | Shell mode — run command directly, no model |
| `/clear` | Reset conversation |
| `/compact` | Manually compact history |
| `/context` | Token breakdown |
| `/usage` | Session stats |
| `/diff` | All session changes (syntax-highlighted) |
| `/undo` | Undo last action |
| `Esc-Esc` | Rewind to a previous file snapshot |
| `/quit`, `exit` | Exit |

## Planning

| Command | Action |
|---|---|
| `Shift+Tab` (to Plan) | Enter Plan Mode |
| `/plan` | Request a plan |

## Sessions and delegation

| Command | Action |
|---|---|
| `&<prompt>` | Cloud delegate to GitHub Actions runner |
| `/resume` | Switch local ↔ remote session |
| `/tasks` | View background tasks |
| `/share gist` | Share session as gist |

## Subagents

| Command | Action |
|---|---|
| `/fleet` | Dispatch parallel subagents from a plan |
| `/review` | Code Review subagent on the diff |
| (auto) | Explore, Plan, Code Review, Critic, Task delegated by the agent |

## Model

| Command | Action |
|---|---|
| `/model` | Picker (Available / Blocked / Upgrade) |
| `/model claude-opus-4-6` | Switch to Opus for this session |
| `--reasoning-effort` | Adjust thinking depth |

## Inspection

| Command | Action |
|---|---|
| `/skills` | List or invoke a skill |
| `/hooks` | List active hooks |
| `/memory` | Repository memory |
| `/permissions` | Show permission rules |
| `/mcp show` | List configured MCPs |
| `/config` | Show current config |

## Permissions

| Command | Action |
|---|---|
| `/allow-all`, `/yolo` | Bypass all prompts (one-way) |
| `/reset-allowed-tools` | Revert session grants |

## Plugins

| Command | Action |
|---|---|
| `copilot plugin install X@awesome-copilot` | Install from default marketplace |
| `copilot plugin list` | List installed |
| `copilot plugin update` | Update all |

## The four reflexes

1. **`Shift+Tab` to Plan** for any change touching >1 file
2. **`/clear` between** unrelated tasks
3. **`/diff` before** every commit
4. **Hooks decide**, instructions advise

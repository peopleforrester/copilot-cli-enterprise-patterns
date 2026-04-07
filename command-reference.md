# Command Reference (Quick Card)

A printable one-pager. For full detail, see `reference/copilot-cli-commands.md`.

## Session
| Key / Command | Action |
|---|---|
| `Shift+Tab` | Toggle Plan Mode |
| `/clear` | Reset conversation |
| `/usage` | Show token consumption |
| `/diff` | Show all session changes |
| `/continue` | Resume previous session |
| `/quit` | Exit |

## Planning
| Command | Action |
|---|---|
| `/plan` | Request a plan |
| `/approve` | Execute the current plan |
| `/cancel` | Discard plan |

## Model
| Command | Action |
|---|---|
| `/model` | List or switch models |
| `/model claude-opus-4-6` | Switch to Opus for this session |

## Inspection
| Command | Action |
|---|---|
| `/skills` | List Skills |
| `/hooks` | List active hooks |
| `/memory` | View repository memory |
| `/permissions` | Show permission rules |
| `/config` | Show current config |

## Subagents
| Command | Action |
|---|---|
| `/explore <query>` | Spawn Explore subagent |
| `/review` | Spawn Code Review subagent |
| `/task <description>` | Spawn generic task subagent |

## The four reflexes
1. **`Shift+Tab` first** for any change touching >1 file
2. **`/clear` between** unrelated tasks
3. **`/diff` before** every commit
4. **Hooks decide**, instructions advise

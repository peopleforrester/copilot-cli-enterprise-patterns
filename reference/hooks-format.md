# Hooks Format Reference

Copilot CLI hooks are JSON files that match against tool calls and run shell commands. They are the only mechanism the agent cannot bypass — use them when a rule must hold.

## Locations

| Path | Scope |
|---|---|
| `~/.config/copilot/hooks/*.json` | User-level, every repo |
| `<repo>/.github/hooks/*.json` | Project-level, this repo |

Both are merged at session start. Project hooks run after user hooks.

## Schema

```json
{
  "version": 1,
  "hooks": {
    "preToolUse":  [ /* HookEntry, ... */ ],
    "postToolUse": [ /* HookEntry, ... */ ]
  }
}
```

### `HookEntry`

| Field | Type | Required | Description |
|---|---|---|---|
| `matcher.tool` | string \| string[] | yes | Tool name(s) to match: `Edit`, `Write`, `MultiEdit`, `Bash`, `Read`, etc. |
| `matcher.path` | glob | no | Path glob the affected file must match |
| `matcher.command` | regex | no | For `Bash` matchers: regex against the command string |
| `command` | string | yes | Shell command to run |
| `description` | string | no | Human-readable purpose; shown in `/hooks` |
| `blocking` | bool | no | If `true`, non-zero exit aborts the tool call (`preToolUse`) or fails the operation (`postToolUse`). Default `false`. |
| `timeoutMs` | number | no | Hard kill after this many ms. Default 30000. |

## Environment variables passed to hook commands

| Var | Set when | Contents |
|---|---|---|
| `COPILOT_HOOK_PHASE` | always | `preToolUse` or `postToolUse` |
| `COPILOT_HOOK_TOOL` | always | Tool name |
| `COPILOT_HOOK_FILE_PATH` | file tools | Affected file path |
| `COPILOT_HOOK_BASH_CMD` | `Bash` tool | The command string |
| `COPILOT_HOOK_SESSION_ID` | always | Stable per Copilot CLI session |
| `COPILOT_HOOK_CWD` | always | Project root |

## Example: lint changed files before edit

```json
{
  "version": 1,
  "hooks": {
    "preToolUse": [
      {
        "matcher": { "tool": ["Edit", "Write", "MultiEdit"] },
        "command": "scripts/copilot-hooks/lint-changed.sh",
        "blocking": true,
        "timeoutMs": 30000
      }
    ]
  }
}
```

## Example: block edits to protected paths

```json
{
  "version": 1,
  "hooks": {
    "preToolUse": [
      {
        "matcher": {
          "tool": ["Edit", "Write", "MultiEdit"],
          "path": ".github/workflows/**"
        },
        "command": "echo 'workflow edits require human authorship' >&2; exit 1",
        "blocking": true
      }
    ]
  }
}
```

## Example: deny dangerous bash patterns

```json
{
  "version": 1,
  "hooks": {
    "preToolUse": [
      {
        "matcher": {
          "tool": "Bash",
          "command": "rm\\s+-rf\\s+/"
        },
        "command": "echo 'blocked: rm -rf /' >&2; exit 1",
        "blocking": true
      }
    ]
  }
}
```

## Anti-patterns

- **Non-blocking safety hooks.** A `blocking: false` security hook prints to stderr and the agent proceeds anyway. Use `blocking: true` for anything safety-relevant.
- **Long-running hooks without `timeoutMs`.** A test suite that hangs blocks the entire session.
- **Stateful hooks.** Hooks should be pure and idempotent. If you need state, write it to disk and have the next hook read it.
- **Hooks that modify files the agent is editing.** This causes the agent's view and the file system to disagree. Use a `postToolUse` formatter only if you've thought through the consequences.

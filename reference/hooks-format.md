# Hooks Format Reference

Copilot CLI hooks are JSON files that fire at specific lifecycle events and run shell commands. They are the primary deterministic enforcement mechanism — use them when a rule must hold.

## Locations

| Path | Scope |
|---|---|
| `~/.copilot/hooks/*.json` | User-level, every repo |
| `<repo>/.github/hooks/*.json` | Project-level, this repo |

Both are loaded at session start. User hooks run first; project hooks run after.

## Top-level schema

```json
{
  "version": 1,
  "hooks": {
    "sessionStart":          [ /* HookEntry, ... */ ],
    "sessionEnd":            [ /* HookEntry, ... */ ],
    "userPromptSubmitted":   [ /* HookEntry, ... */ ],
    "preToolUse":            [ /* HookEntry, ... */ ],
    "postToolUse":           [ /* HookEntry, ... */ ],
    "agentStop":             [ /* HookEntry, ... */ ],
    "subagentStop":          [ /* HookEntry, ... */ ],
    "errorOccurred":         [ /* HookEntry, ... */ ],
    "PermissionRequest":     [ /* HookEntry, ... */ ],
    "notification":          [ /* HookEntry, ... */ ]
  }
}
```

## Lifecycle events

| Event | Can block? | Purpose |
|---|---|---|
| `sessionStart` | No | Banner scripts, environment setup, prompt injection (`type: prompt` only) |
| `sessionEnd` | No | Cleanup, metrics logging |
| `userPromptSubmitted` | No | Prompt auditing |
| **`preToolUse`** | **Yes** | Security gates, tool filtering — block by emitting `{"deny": true}` on stdout |
| `postToolUse` | No | Logging, test runs, notifications — surfaces failures back to the agent |
| `agentStop` | No | Main agent completion |
| `subagentStop` | No | Subagent completion |
| `errorOccurred` | No | Error handling |
| `PermissionRequest` (v1.0.16+) | Decides | Programmatically handle permission prompts |
| `notification` (v1.0.18+) | No | Async notifications on shell completion, permission prompts, agent completion |

> **Only `preToolUse` can block tool execution.** Every other event runs alongside the agent loop. `postToolUse` failures don't abort, but they *do* return their output to the agent, which then has to react.

## `HookEntry` schema

```json
{
  "type": "command",
  "bash": "./scripts/your-hook.sh",
  "powershell": "./scripts/your-hook.ps1",
  "cwd": ".github/hooks",
  "env": { "POLICY_LEVEL": "strict" },
  "timeoutSec": 10,
  "comment": "Human-readable purpose"
}
```

| Field | Type | Required | Description |
|---|---|---|---|
| `type` | `"command"` \| `"prompt"` | yes | `command` runs a shell script. `prompt` injects text as if the user typed it (only valid on `sessionStart`). |
| `bash` | string | one of bash/powershell | Shell command for POSIX systems |
| `powershell` | string | one of bash/powershell | Shell command for Windows |
| `cwd` | string | no | Working directory for the command. Defaults to repo root. |
| `env` | object | no | Extra env vars passed to the command |
| `timeoutSec` | number | no | Hard kill after this many seconds. **Always set this.** |
| `comment` | string | no | Documentation; shown in `/hooks` |

## How a hook command receives data

Copilot CLI delivers a **JSON event on stdin** to every command hook:

```json
{
  "toolName": "edit_file",
  "toolArgs": { "path": "src/foo.py", "content": "..." },
  "timestamp": "2026-04-07T12:34:56Z",
  "cwd": "/home/dev/project",
  "sessionId": "..."
}
```

Read it from stdin and parse with `jq` (or your language of choice).

## How a `preToolUse` hook approves or denies

| Outcome | How |
|---|---|
| **Approve** | Exit `0` with empty stdout |
| **Deny** | Exit `0` with `{"deny": true, "reason": "..."}` on stdout |
| **Failure (skipped)** | Non-zero exit, timeout, or invalid output. Logged and skipped — does **not** block the agent. |

> Critical: a `preToolUse` hook that denies via non-zero exit code does **not** block. Hook failures are logged-and-skipped by design. Blocking requires the JSON `{"deny": true}` on stdout.

## Example: lint changed files before edit (blocking)

```json
{
  "version": 1,
  "hooks": {
    "preToolUse": [
      {
        "type": "command",
        "bash": "./scripts/copilot-hooks/lint-changed.sh",
        "timeoutSec": 30,
        "comment": "Deny edits to files that fail lint"
      }
    ]
  }
}
```

The script reads `toolArgs.path` from stdin, runs the appropriate linter, and emits `{"deny": true, "reason": "..."}` on failure. See `scripts/copilot-hooks/lint-changed.sh`.

## Example: block edits to protected paths

```json
{
  "version": 1,
  "hooks": {
    "preToolUse": [
      {
        "type": "command",
        "bash": "jq -r '.toolArgs.path' | grep -qE '^\\.github/workflows/' && echo '{\"deny\": true, \"reason\": \"workflow edits require human authorship\"}' || true",
        "timeoutSec": 5
      }
    ]
  }
}
```

In practice, write a real script — inline shell in JSON gets unreadable fast.

## Example: post-edit test run (non-blocking, surfaces failures)

```json
{
  "version": 1,
  "hooks": {
    "postToolUse": [
      {
        "type": "command",
        "bash": "./scripts/copilot-hooks/run-tests.sh",
        "timeoutSec": 180,
        "comment": "Run fast test tier; agent receives failure output"
      }
    ]
  }
}
```

Even though `postToolUse` cannot block, the agent receives the script's output and reacts to it. Failed tests get fixed in the next iteration of the loop.

## Example: sessionStart prompt injection

```json
{
  "version": 1,
  "hooks": {
    "sessionStart": [
      {
        "type": "prompt",
        "bash": "echo 'Reminder: this repo enforces TDD. Always write the test first.'"
      }
    ]
  }
}
```

The text is inserted into the conversation as if the user had typed it. Use sparingly — every prompt injection costs context.

## Anti-patterns

- **Relying on exit codes for blocking.** `preToolUse` blocks via `{"deny": true}` on stdout, not exit code. Non-zero exits are logged-and-skipped.
- **No `timeoutSec`.** A hung hook hangs the session.
- **Stateful hooks.** Hooks should be pure and idempotent. If you need state, write it to disk.
- **Hooks that modify files the agent is editing.** Causes the agent's view and the file system to disagree.
- **Inline shell in JSON.** Unreadable, unmaintainable, not testable. Write scripts.
- **Treating `postToolUse` as a security gate.** It's not — only `preToolUse` can block.

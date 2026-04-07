# Verification Patterns

> Advisory instructions work ~80% of the time. Deterministic verification works 100%.

This is Pillar 4. Everything in this doc is about replacing trust with proof.

## The hierarchy of verification

From weakest to strongest:

1. **The agent says it did the thing.** Worth nothing on its own.
2. **The agent shows you the diff.** Better — you can read it.
3. **A linter ran and was clean.** Better still — a deterministic check passed.
4. **A test suite ran and was green and pristine.** Strong.
5. **A test suite ran in CI on the pushed branch and was green.** Strongest.

Aim to operate at level 4 locally and gate merges at level 5.

## Hooks as enforcement

Hooks are the only mechanism in Copilot CLI that the agent **cannot bypass**. Use them for anything that must hold.

### `preToolUse` — gate before the action (the **only** blocking event)
Blocks by emitting `{"deny": true, "reason": "..."}` on stdout. Non-zero exit does NOT block — it logs-and-skips. Get this wrong and your "security gate" is a notification.

Use cases:
- Deny edits to protected paths (`infra/`, `.github/workflows/`, secrets)
- Deny dangerous shell patterns (`rm -rf /`, `curl | sh`)
- Lint files about to be modified and deny on lint failure
- Require a spec to exist in `docs/specs/` before allowing edits to a feature directory

### `postToolUse` — verify after the action
Cannot block. But output is surfaced back to the agent, which then reacts. Use cases:
- Run the unit test tier after any source file edit
- Run the linter after any edit (as a backstop to `preToolUse`)
- Trigger a security scanner on any new dependency manifest change
- Refuse to mark the change "done" if test output is non-empty on stderr

### Other hook events
| Event | Blocking? | Use for |
|---|---|---|
| `sessionStart` | No | Banner, env setup, prompt injection |
| `sessionEnd` | No | Cleanup, metrics |
| `userPromptSubmitted` | No | Prompt auditing |
| `agentStop` / `subagentStop` | No | Completion notifications |
| `errorOccurred` | No | Error logging |
| `PermissionRequest` (v1.0.16+) | Decides | Programmatic permission handling |
| `notification` (v1.0.18+) | No | Async notifications |

See `.github/hooks/` for working examples and `reference/hooks-format.md` for the full schema.

## Pristine output

A passing test suite that prints warnings is a failing test suite. Reasons:
- Warnings hide regressions
- Warnings desensitize humans to log output
- Warnings in CI are usually ignored, so they accumulate

Configure your test runner to fail on stderr output, or wrap it in a script that does.

## `/diff` and Code Review

- **`/diff`** dumps the full session change set. Run it before every commit. If anything in the diff surprises you, stop and investigate.
- **Code Review subagent** can audit the diff against project standards in its own context window. Useful for catching scope creep and convention drift.

## What deterministic verification *can't* do

- Tell you the spec was correct
- Tell you the test covers the actual requirement
- Tell you the code is maintainable
- Tell you the change is the right change

For those, you still need a human reviewer. Hooks free that human from checking the things a machine can check, so attention can land on the things only a human can judge.

## A minimum bar

Every repo using Copilot CLI should have, at minimum:

1. A `preToolUse` lint hook covering the file types in the repo (blocking via `{"deny": true}`)
2. A `postToolUse` test hook running the fast test tier
3. A team-wide deny-flag wrapper or admin-console policy for destructive shell + secret paths (see `enterprise/security-deny-rules.md`)
4. CI gating merges to `main` on the same checks

That's the floor. Add more as the team's pain points reveal themselves.

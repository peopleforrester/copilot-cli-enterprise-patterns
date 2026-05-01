# 01 — Foundations Exercises

## Exercise 1.1 — Verify your install (5 min)

```text
copilot --version
```

Then launch a session and run `/model`. Confirm the default is `claude-sonnet-4-5` (or note what your org default is — some orgs override).

**Checkpoint:** you can name the active model.

## Exercise 1.2 — Tour the loaded files (10 min)

In a fresh session, ask:
> "What instruction files have you loaded for this session, and from where?"

Compare its answer against:

- `~/.copilot/copilot-instructions.md` (user-level)
- `<repo>/AGENTS.md` (project-level, plain markdown, nearest-wins tree walk)
- `<repo>/.github/copilot-instructions.md` (also loaded)

**Checkpoint:** you can locate both files on disk and explain which takes precedence when they conflict.

## Exercise 1.3 — Plan Mode round trip (15 min)

In a sandbox repo, hit `Shift+Tab` and ask:
> "Add a `/health` endpoint that returns `{status: 'ok'}` and a test for it."

Read the plan. Identify:

- Which files it intends to touch
- Whether the test is specified concretely or vaguely
- Whether it asked any clarifying questions

Push back on anything weak. Approve only when the plan is good. Then watch the execution and compare the diff to the plan.

**Checkpoint:** the diff matches the approved plan with no surprises.

## Exercise 1.4 — Recite the Four Pillars (5 min)

Without looking, write down:

1. ___
2. ___
3. ___
4. ___

Then check yourself against `patterns/four-pillars-copilot-cli.md`.

**Checkpoint:** four for four.

## Exercise 1.5 — Find the deny list (10 min)

Open `enterprise/security-deny-rules.md`. Pick three of the documented `--deny-tool` patterns (or `preToolUse` hook patterns) that you do not yet understand. For each, work out *why* the pattern is there. (Note: Copilot CLI has no `permissions.deny` block in `settings.json` — that's a Claude Code idiom; the actual mechanisms are `--deny-tool` flags and `preToolUse` hooks. The doc above explains both.)

**Checkpoint:** you can explain *why* each rule exists, not just *what* it blocks.

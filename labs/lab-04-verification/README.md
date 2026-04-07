# Lab 04 — Build a Verification Pipeline

**Time:** 30 minutes
**Pillar:** 4 (Verify Output)

## Scenario

A small Python project lives in `labs/lab-04-verification/sample-app/`. It has:
- One module (`calculator.py`)
- One test file (`test_calculator.py`)
- A failing test (deliberate)
- No hooks, no `AGENTS.md`, no nothing

Your job is to wire up Pillar 4 from scratch.

## Your task

1. Add a `PreToolUse` lint hook for Python files using ruff.
2. Add a `PostToolUse` test hook running pytest.
3. Add an `AGENTS.md` advising the agent to fix failing tests before declaring done.
4. Ask Copilot CLI to "make the tests pass".
5. Watch the loop run autonomously: agent edits → hook lints → hook tests → on failure, agent fixes → loop.
6. Confirm the final state has zero warnings on lint and pristine pytest output.

## Sample app

A minimal `calculator.py` with `add`, `subtract`, `multiply`, `divide`. The bug: `divide` doesn't handle `b == 0` and returns `inf` instead of raising `ValueError`. The test expects `ValueError`.

## Steps

1. `cd labs/lab-04-verification/sample-app`
2. Create `.github/hooks/pre-tool-use-lint.json` and `.github/hooks/post-tool-use-test.json`. Reference the scripts from `scripts/copilot-hooks/` at the repo root.
3. Create `AGENTS.md` with the verification expectation.
4. Run pytest manually first. Confirm the failure.
5. Launch Copilot CLI in this directory. Ask: "Make the tests pass."
6. Observe the loop.

## Success criteria

- [ ] The hooks are JSON-valid and `blocking: true`
- [ ] The agent fixes the bug in `calculator.py`
- [ ] You did not need to manually re-run pytest — the hook did it
- [ ] Final pytest output is pristine (no warnings)
- [ ] The fix is the *minimum* change (don't accept a refactor)

## Debrief questions

- How many edit-test cycles did the agent need?
- What would have happened without the `PostToolUse` hook?
- What's one rule you currently put in `AGENTS.md` in your real projects that should be a hook instead?

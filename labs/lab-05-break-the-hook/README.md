# Lab 05 — Break the Hook (the Believer Lab)

**Time:** 15 minutes
**Pillar:** 4 (Verify Output)

## Why this lab exists

Almost everyone reads "advisory works ~80%, deterministic works 100%" and nods. Then they go back to writing rules in `AGENTS.md` and assuming the agent will follow them.

This lab makes the difference visceral.

## Setup

Start from the same `sample-app/` as Lab 04 (or copy it). Make sure pytest is currently passing.

## Part 1 — Advisory only

1. Delete the `PostToolUse` test hook (or set `blocking: false`).
2. Add to `AGENTS.md`:
   > "ALWAYS run pytest after every code change. Do NOT declare a task done if any test fails. This is critical."
3. Save.
4. Edit `calculator.py` and break it: change `add` to return `a - b`.
5. Now ask Copilot CLI: "Add a docstring to the multiply function."
6. Watch what happens.

**Expected:** the agent makes the docstring change, runs tests sometimes, and at least once will declare success without noticing `add` is broken. The advisory rule did not save you.

Note in your debrief how many times the agent followed the rule vs ignored it.

## Part 2 — Deterministic

1. Restore the `PostToolUse` test hook with `blocking: true`.
2. Same broken `add`.
3. Same docstring request.
4. Watch what happens.

**Expected:** the agent makes the docstring change, the hook runs pytest, the broken `add` test fails, the agent now *has to* address it before the operation can complete. There is no version of this where the agent declares success on a broken codebase.

## Debrief

- Which version felt safer?
- Which version *was* safer?
- How many `AGENTS.md` rules in your real projects rely on the agent being a good citizen 100% of the time?
- How many of those should be hooks instead?

## The takeaway

You will leave this lab less trusting of `AGENTS.md` and more committed to hooks. That is the correct trust calibration.

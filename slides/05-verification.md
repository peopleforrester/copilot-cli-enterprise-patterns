---
marp: true
title: Verification
paginate: true
---

# Pillar 4 — Verify Output

> Advisory works ~80%. Deterministic works 100%.

---

## The hierarchy

1. The agent says it did the thing — **worth nothing**
2. The agent shows the diff — better
3. A linter ran clean — **deterministic**
4. Tests green and pristine — **strong**
5. CI green on the pushed branch — **strongest**

Aim for level 4 locally. Gate merges at level 5.

---

## PreToolUse hooks

Run *before* a tool executes. Block the operation on non-zero exit.

Use for:
- Lint files about to be edited
- Block edits to protected paths
- Block dangerous shell patterns
- Require a spec to exist before allowing edits

---

## PostToolUse hooks

Run *after* a tool executes. Failures bounce back to the agent.

Use for:
- Run tests after any source edit
- Run security scanner on dependency changes
- Validate JSON/YAML files were written correctly

---

## The minimum bar

Every repo using Copilot CLI should have:

1. `PreToolUse` lint hook
2. `PostToolUse` test hook (fast tier)
3. `permissions.deny` for destructive shell + secrets
4. CI gating merges to `main`

That's the floor.

---

## Pristine output

A passing test suite that prints warnings is a failing test suite.

- Warnings hide regressions
- Warnings desensitize humans to log output
- Warnings in CI accumulate forever

Configure your runner to fail on stderr.

---

## Lab 04 + Lab 05

- **Lab 04** — wire Pillar 4 from scratch on a sample app.
- **Lab 05** — break a hook on purpose, watch the difference. The lab that converts skeptics.

→ `labs/lab-04-verification/` and `labs/lab-05-break-the-hook/`

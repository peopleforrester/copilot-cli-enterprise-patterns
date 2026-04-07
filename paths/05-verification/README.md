# 05 — Verification

**Time:** 75 minutes
**Pillar:** 4
**Labs:** `labs/lab-04-verification`, `labs/lab-05-break-the-hook`

## What you'll learn

- Why hooks are categorically different from instructions
- The hierarchy of verification (claim → diff → lint → test → CI)
- How to write `PreToolUse` and `PostToolUse` hooks
- When to use blocking vs non-blocking
- The "pristine output" rule

## Read first

- `patterns/verification-patterns.md`
- `reference/hooks-format.md`
- `.github/hooks/` (the working examples)

## The principle

> Advisory instructions work ~80% of the time. Deterministic verification works 100%.

`AGENTS.md` says "always run tests after a change." Sometimes the agent does. Sometimes it doesn't. Sometimes it says it did when it didn't.

A `PostToolUse` hook running tests doesn't have moods. It runs every time, fails when it should fail, and the agent can't talk it out of failing.

## Exit criteria

- [ ] You can write a hook from scratch in under 5 minutes
- [ ] You can explain when blocking vs non-blocking is correct
- [ ] You've done `lab-05-break-the-hook` and it changed how you feel
- [ ] Your repos enforce lint + test via hooks, not just AGENTS.md

## Next

→ `paths/06-enterprise-hardening/`

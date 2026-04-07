# 04 — Externalization

**Time:** 75 minutes
**Pillar:** 3
**Lab:** `labs/lab-03-externalization`

## What you'll learn

- The five externalization mechanisms in Copilot CLI
- How to choose between AGENTS.md, instructions.md, Skills, memory, and hooks
- How to write a Skill that actually triggers
- The "advisory works ~80%" rule and its consequences

## Read first

- `patterns/externalization-patterns.md`
- `reference/agents-md-template.md`
- All three Skill examples in `.github/skills/`

## The principle

If you tell the agent the same thing twice, it belongs in a file. If the rule must hold, it belongs in a hook (see Module 05).

## Exit criteria

- [ ] You can map any new rule to its right home in under 30 seconds
- [ ] You've written a Skill that the agent triggers correctly on the first try
- [ ] Your `AGENTS.md` is under 500 lines and has nothing duplicated from the linter
- [ ] You can explain when memory is the wrong tool

## Next

→ `paths/05-verification/`

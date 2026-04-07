# 02 — Context Management

**Time:** 60 minutes
**Pillar:** 1
**Lab:** `labs/lab-01-context`

## What you'll learn

- Why context is the primary constraint, not the model
- How auto-compaction works in Copilot CLI and what it loses
- The `/clear` reflex and the *one feature per session* rule
- Subagents (Explore, Plan, Code Review) as context isolation
- Targeted reads vs whole-file reads

## Why it matters

Long sessions degrade. The model starts contradicting decisions made an hour ago. Tests pass but the wrong test is passing. The fix is not a bigger window — it's better hygiene.

## Read first

- `patterns/context-management.md`

## Exercises

See `exercises.md`. The lab in `labs/lab-01-context` has a deliberately polluted starting state — your job is to recover it.

## Exit criteria

- [ ] You can name three signals that say "it's time to `/clear`"
- [ ] You use the Explore subagent for any search that would dump >2000 tokens
- [ ] You can describe what auto-compaction loses
- [ ] You stop pasting whole files into chat

## Next

→ `paths/03-plan-mode/`

# Lab 03 — Externalization Sort

**Time:** 30 minutes
**Pillar:** 3 (Externalize Decisions)

## Scenario

You've just joined a team. Their `AGENTS.md` is 1,400 lines long. Half of it is duplicated linter rules, a third is historical narrative, and there's a section labeled "Things Bob said in the 2024 retro". The team complains that the agent "doesn't follow our standards".

You suspect the file is so bloated that nothing in it actually lands.

## Your task

1. Cut the team's `AGENTS.md` to under 500 lines without losing anything load-bearing.
2. Move what doesn't belong to its right home (Skill, hook, user instructions, or delete).
3. Write a one-page diff explanation for the team.

## Use the example file

`labs/lab-03-externalization/inherited-AGENTS.md` is a fictional but realistic bloated file. Work on a copy.

## Steps

1. Read the inherited file once, end to end. Time yourself.
2. Tag every section with one of:
   - **KEEP** — load-bearing, lives in `AGENTS.md`
   - **SKILL** — should be a `SKILL.md`
   - **HOOK** — should be enforced, not advised
   - **USER** — personal preference, move to user instructions
   - **DELETE** — duplicated, stale, narrative
3. Produce the slimmed `AGENTS.md`.
4. Produce stub SKILL.md / hook JSON for anything you moved.
5. Write `MIGRATION-NOTES.md` explaining the changes for the team.

## Success criteria

- [ ] Final `AGENTS.md` ≤ 500 lines
- [ ] Nothing safety-relevant moved to advisory mechanisms
- [ ] No content silently dropped without a note in MIGRATION-NOTES.md
- [ ] At least one item moved to a hook (because hooks are how you stop having this problem again)

## Debrief questions

- What was the most surprising thing in the original file?
- What rules did you find duplicated in two places? Which copy did you keep?
- How would you prevent this team from re-bloating the file in six months?

---
marp: true
title: Externalization
paginate: true
---

# Pillar 3 — Externalize Decisions

If you tell it twice, write it down.

---

## The five places

| Mechanism | Scope | Enforcement |
|---|---|---|
| `AGENTS.md` | One repo, every session | Advisory |
| User `instructions.md` | All repos, one user | Advisory |
| Skill (`SKILL.md`) | Triggered on description match | Advisory, structured |
| Memory | Across sessions, same repo | Advisory |
| Hook | Matching tool calls | **Deterministic** |

---

## How to choose

- **Project rule, all sessions** → `AGENTS.md`
- **Personal preference** → user `instructions.md`
- **Repeatable workflow** → Skill
- **Accumulated facts** → memory
- **Must hold every time** → hook

---

## The advisory ceiling

> Advisory works ~80% of the time.

That's fine for "use 4-space indent". It's not fine for "don't push to main" or "always run tests".

For anything safety-critical: hook, not paragraph.

---

## Skills that trigger

- Specific name and description (vague descriptions never match)
- Numbered steps, not goals
- Explicit exit conditions
- At least one anti-pattern

The agent matches against the description. If it never triggers, the description isn't specific enough.

---

## AGENTS.md anti-patterns

- 1,400 lines (nothing lands)
- Duplicated linter rules (linter already enforces)
- Historical narrative ("we used to use Webpack")
- Personal preferences (move to user instructions)
- Stale rules from 2023

---

## Lab 03 — Externalization Sort

A bloated 1,400-line `AGENTS.md`. Slim it. Move things to their right home. Document the migration for the team.

→ `labs/lab-03-externalization/`

---
marp: true
title: Plan Mode
paginate: true
---

# Pillar 2 — Plan Before Code

The cheapest defect exists only in a plan.

---

## Enter and exit

- **`Shift+Tab`** toggles Plan Mode (same as Claude Code)
- In Plan Mode: read, search, propose. **Cannot edit.**
- `/plan` — explicit request mid-session
- `/approve` to execute — `/cancel` to discard

---

## Read plans like an editor

For every plan, ask:

- Which files? (Specific paths, not "the auth module")
- Which tests? (Specific assertions, not "tests")
- Which error cases? (Listed, not "edge cases")
- What's NOT in scope? (Explicit non-goals)
- What's still ambiguous? (Should be surfaced, not guessed)

---

## Push back is the work

The first plan is rarely good. Pushing back is not friction — it *is* the value of Plan Mode.

> "What about the unauthenticated path?"
> "How do we test the rate limit?"
> "Why does this touch the logging module?"

---

## When to skip

- One-line bug fix with an obvious cause
- Doc typo, comment fix
- "Run this command and report"

For *anything* else: plan first.

---

## Plan vs Spec

| | Plan | Spec |
|---|---|---|
| Lives in | Chat | `docs/specs/` |
| Survives | Until `/clear` | Forever |
| Reviewable by | You | The team |
| Use for | Next hour | Next week |

---

## Lab 02 — Plan Mode Pushback

A vague PM request hides 10 unanswered questions. Drive it through Plan Mode until every one is addressed.

→ `labs/lab-02-plan-mode/`

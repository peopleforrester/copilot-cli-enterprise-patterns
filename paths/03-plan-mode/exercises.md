# 03 — Plan Mode Exercises

## Exercise 3.1 — The bad plan (15 min)

Ask Copilot CLI in Plan Mode:
> "Refactor the auth module to support OAuth."

Read the plan. It will be too vague. Identify three specific things missing:
1. Which OAuth providers?
2. Token storage strategy?
3. Migration path for existing sessions?

Push back with all three. Watch the plan get sharper.

**Lesson:** the first plan is rarely good. You're the editor.

## Exercise 3.2 — The wrong-scope plan (15 min)

In a small project, ask:
> "Fix the bug where the timestamp is off by one hour in the daily report."

If the plan proposes touching more than two files, push back. The fix should be small. If it isn't, *that's the conversation* — either the bug is bigger than it looked, or the plan is over-reaching.

**Lesson:** scope drift is detected in the plan or never detected.

## Exercise 3.3 — When NOT to plan (10 min)

Single-file bug fix with an obvious cause. Don't enter Plan Mode. Let it just fix it. Time it.

Then do the same fix again from scratch *with* Plan Mode. Time it.

**Lesson:** the planning tax is real for trivial work. Skip it when the task is small and well-defined.

## Exercise 3.4 — Plan vs spec (20 min)

Take a plan from Exercise 3.1 (the OAuth refactor) and convert it into a written spec at `docs/specs/oauth-refactor.md` using the structure in the `spec-driven-dev` skill.

Compare:
- The plan (lives in chat, dies on `/clear`)
- The spec (lives in repo, survives sessions and reviewers)

**Lesson:** plan for the next hour, spec for the next week.

## Lab

Do `labs/lab-02-plan-mode` for a constrained scenario.

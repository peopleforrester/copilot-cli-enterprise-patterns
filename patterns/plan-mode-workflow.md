# Plan Mode Workflow

`Shift+Tab` toggles Plan Mode in Copilot CLI — same key as Claude Code. In Plan Mode the agent can read, search, and reason, but cannot edit files or run mutating commands.

## Why bother

The cheapest defect to catch is one that exists only in a plan. The most expensive is one shipped to production. Plan Mode moves defect detection left.

## When to use it

**Always plan first when:**
- The change touches more than one file
- The behavior is not obvious from a one-line description
- The work involves data migrations, schema changes, or auth
- You're working in a part of the codebase you don't know well
- The user request is ambiguous

**Skip planning when:**
- A single-file bug fix with an obvious cause
- Trivial renames, doc fixes, comment updates
- The task is "run this command and report the output"

## The loop

1. **Enter Plan Mode** (`Shift+Tab`).
2. **State the task in one sentence.** Resist over-specifying — let the agent surface the questions.
3. **Let the agent investigate.** It will read files, ask clarifying questions, and propose an approach.
4. **Read the plan critically.** Look for:
   - Files touched — is anything missing or surprising?
   - Test plan — does it actually prove the goal?
   - Assumptions — are any of them wrong?
   - Scope creep — is it doing more than you asked?
5. **Push back.** Wrong plans are normal. Tell the agent specifically what to change.
6. **Approve.** Exit Plan Mode and let it execute.
7. **Compare execution to plan.** If the diff diverges from the plan without explanation, that's a flag.

## What a good plan looks like

- **Specific files**, not "the auth module"
- **Specific tests**, not "add tests"
- **Specific error cases**, not "handle errors"
- **An explicit non-goals list**, even if short
- **Open questions surfaced**, not silently guessed

## Plan vs spec

Plan Mode produces an in-session plan. It lives in chat. It dies on `/clear`.

A **spec** (see the `spec-driven-dev` skill) is a plan written to disk. Use specs when:
- The work spans multiple sessions
- Multiple people need to review the approach
- The decision needs to outlive the chat history

Plan Mode is for the next hour. Specs are for the next week.

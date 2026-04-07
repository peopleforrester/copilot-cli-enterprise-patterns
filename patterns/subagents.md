# Subagents

Subagents run in their own context windows. Their output returns to the main session as a summary, not as the raw work. Use them whenever a task would otherwise pollute main context.

## The roster

| Subagent | Best for | Trade-off |
|---|---|---|
| **Explore** | Broad codebase searches, "find every place X is referenced", repo-wide questions | Slower than direct grep; worth it when results would be large |
| **Plan** | Drafting an implementation plan without writing it into main context | The main session sees only the final plan, not the exploration |
| **Code Review** | Auditing a diff against project standards | Cannot make changes — produces findings only |
| **Critic** | Second-opinion review of a plan before you execute it, run on a *complementary model* (e.g., GPT-5 if your primary is Sonnet) | Only as useful as the plan you hand it — vague plans get vague criticism |
| **Generic Task** | One-shot research, computation, or focused subtask | You phrase the brief; brief quality determines result quality |

> **Critic** (v1.0.18+) is worth calling out separately. It's designed to be run against a different model family than the one doing the work — the point is *diversity of failure modes*. If Sonnet wrote the plan, Critic on GPT-5 will catch blind spots Sonnet shares with itself. Use it before any irreversible or high-blast-radius change.

Custom agents beyond these five live in `.agent.md` files — see `reference/custom-agents.md`.

## When to use which

- **"Where do we call `fetchUser`?"** → Explore.
- **"Plan the migration from session cookies to JWT."** → Plan subagent (or main session in Plan Mode — Plan subagent for *deeper* work).
- **"Check this PR diff against our style guide."** → Code Review.
- **"Compute the dependency graph for the auth module."** → Generic Task.
- **"Read this file and tell me what `processOrder` does."** → Main session, no subagent needed.

The decision rule: would the result of this work, if dumped raw into main context, take up more than ~2,000 tokens of stuff I won't need later? If yes, subagent.

## Briefing a subagent

Subagents start with no shared context. They don't see your conversation, your previous decisions, or what you've already tried. **Brief them like a colleague who just walked into the room:**

- What you're trying to accomplish and why
- What you've already learned or ruled out
- The exact question, not a paraphrase
- The expected output format (one paragraph? bulleted list? code diff?)

Vague briefs produce shallow generic work.

## Anti-patterns

- **Using a subagent for a one-line answer.** "What does `add` do?" doesn't need a subagent — main session is fine.
- **Pre-deciding the steps.** "Search the repo, then read these three files, then answer X." If you know the steps, the subagent isn't earning its keep — just do it yourself or in main session.
- **Not reading the result.** Subagents can be wrong. The summary they return is *their* synthesis, not ground truth. Verify before acting.
- **Cascading subagents inside subagents.** Possible, rarely useful. Each layer loses context.

## A practical pattern

For any non-trivial change:

1. **Explore subagent** → "Find every file that touches X."
2. **Read the summary in main session.**
3. **Plan in main session** with `Shift+Tab`, referencing the Explore findings.
4. **Implement in main session.**
5. **Code Review subagent** → audit the diff.
6. **Address findings, commit.**

Main session stays clean. Each subagent does one job. The diff is the only thing the main loop has to remember.

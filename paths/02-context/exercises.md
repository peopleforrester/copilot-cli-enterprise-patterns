# 02 — Context Management Exercises

## Exercise 2.1 — The pollution test (15 min)

1. Open a fresh Copilot CLI session in any project.
2. Ask five unrelated questions about five different files. Don't use Explore — let it dump everything into main context.
3. Run `/usage` after each.
4. Ask: "What are we working on?"
5. Note how the answer drifts.
6. `/clear` and ask the same question. Note the difference.

**Lesson:** main context is for *one thing*. Everything else is overhead.

## Exercise 2.2 — Subagent vs main loop (15 min)

Same project. Two attempts at the same question:

**Attempt A:** ask in the main loop: "Find every place we call `fetchUser` and list the call sites."
**Attempt B:** `/clear`, then ask the main agent to delegate the search to an Explore subagent: "Use the Explore subagent to find every place we call `fetchUser` and list the call sites." (Explore is a built-in subagent the main agent dispatches; there is no `/explore` slash command.)

Compare:

- Token usage (`/usage`)
- The answer's relevance
- How "loaded" the main context feels for the *next* question

**Lesson:** subagents are context insurance.

## Exercise 2.3 — Targeted reads (10 min)

Pick a 1000+ line file in your project. Ask the agent to explain a single function in it. Watch what it reads.

If it reads the whole file, ask: "Can you read just lines X-Y instead and answer?"

**Lesson:** the agent will use the cheapest read it can — but it needs you to point at the lines when you know them.

## Exercise 2.4 — One feature per session (20 min)

Pick two unrelated tasks. Time-box each at 10 minutes. Between them: `/clear`.

Then repeat: same two tasks, no `/clear`, both in the same session. Note any moments where the agent referenced the wrong task.

**Lesson:** the discipline is cheap; the failure mode is expensive.

## Lab

Now do `labs/lab-01-context` for a fixed scenario with a checkable outcome.

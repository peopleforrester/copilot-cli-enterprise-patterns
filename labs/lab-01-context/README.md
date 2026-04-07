# Lab 01 — Context Recovery

**Time:** 20 minutes
**Pillar:** 1 (Manage Context)

## Scenario

You inherit a Copilot CLI session from a colleague. They've been working in it all day on three unrelated tasks: a bug fix in the auth module, a new payments endpoint, and a refactor of the logging library. They're now stuck and ask you to "just finish the payments endpoint".

The session is bloated. The agent keeps referring to auth code when you ask about payments. `/usage` shows 87% consumption.

## Your task

Recover the session into a clean, focused state and complete the payments endpoint task without losing the relevant context.

## Steps

1. **Inventory.** Ask the agent: "What tasks have been worked on in this session? List them with one-line summaries."
2. **Externalize.** For anything not yet committed, capture it: a draft commit, a note in `docs/wip.md`, or a TODO in the relevant file. Do this *before* clearing.
3. **Clear.** Run `/clear`.
4. **Reload only what you need.** Open the payments task spec or issue. Hand the agent only the files relevant to payments.
5. **Verify focus.** Ask: "What are we working on?" The answer should mention only payments.
6. **Finish the task.** Plan, execute, lint, test, diff, commit.

## Success criteria

- [ ] No data lost from the colleague's other in-progress work
- [ ] Post-`/clear` `/usage` is under 30%
- [ ] Agent's responses no longer reference auth or logging when working on payments
- [ ] Final commit covers only the payments change

## Anti-patterns to avoid

- `/clear` without externalizing first (you lose your colleague's WIP)
- Pasting entire files into the new session "to be safe"
- Asking the agent to "remember" the other tasks — that's what files are for

## Debrief questions

- How long would this have taken without `/clear`?
- What would you tell your colleague to do differently next time?
- Where in your team's workflow does this scenario already happen?

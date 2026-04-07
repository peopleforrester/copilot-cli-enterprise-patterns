# 01 — Foundations

**Time:** 45 minutes
**Prerequisite:** Copilot CLI installed and authenticated against GitHub.

## What you'll learn

- What Copilot CLI is and isn't
- The Four Pillars and why they exist
- The default model (Sonnet 4.6) and when to switch
- The mental model: agentic CLI as collaborator, not autocomplete

## Why it matters

Most teams adopt Copilot CLI by treating it like a chatbot wired into the terminal. That works for trivial tasks and breaks for everything else. The Four Pillars are the difference between "Copilot CLI is sometimes useful" and "Copilot CLI is part of how we ship".

## Key concepts

1. **Agentic, not autocomplete.** It plans, takes actions, observes results, and adapts. You manage the loop, not the keystrokes.
2. **The window is finite.** Context is RAM. Treat it like RAM.
3. **Plans before code.** Cheap to fix a bad plan. Expensive to revert bad code.
4. **Externalize.** If you tell it twice, write it down.
5. **Verify deterministically.** Hooks > instructions for anything that matters.

## Exit criteria

You can do these without looking anything up:

- [ ] Open Copilot CLI and explain to a colleague what model is running
- [ ] Toggle Plan Mode and describe what changes
- [ ] Run `/clear` and explain *when* you'd use it vs. continuing
- [ ] Locate `AGENTS.md` and `.github/copilot/instructions.md` and explain which loads when
- [ ] State the Four Pillars from memory

## Next

→ `paths/02-context/`

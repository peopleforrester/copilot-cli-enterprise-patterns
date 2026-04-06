# Context Management in Copilot CLI

The model's context window is finite. Every token spent on stale conversation is a token unavailable for the current problem. This doc covers the practical levers Copilot CLI gives you and the habits that make them work.

## The auto-compaction trap

Copilot CLI auto-compacts at ~95% context utilization. It is not a substitute for managing context — it is a safety net.

**What auto-compaction does:** summarizes earlier conversation into a shorter form, then drops the originals.

**What it loses:** specifics. Exact file paths, exact line numbers, exact error messages, the precise wording of a decision. The summary keeps the gist; the gist is often not enough to debug a problem an hour later.

**Implication:** plan as if compaction will happen. Externalize anything you'd be sad to lose.

## Levers

### `/clear`
Resets the conversation. Use it:
- Between unrelated tasks (the *one feature per session* rule)
- After a long debugging detour that polluted context with red herrings
- When you notice the agent referencing decisions that no longer apply

### `/usage`
Reports current token consumption. Glance at it before starting any task you expect to be long.

### Subagents
Subagents run in their own context windows. Output comes back to the main session as a summary, not as the raw search results.

| Subagent | Use for |
|---|---|
| `Explore` | "Find every place X is referenced", broad codebase questions |
| `Plan` | Drafting an implementation plan without polluting main context |
| `Code Review` | Auditing a diff against standards |
| Generic task | One-shot research or computation |

**Rule of thumb:** if a search would dump >2000 tokens of grep output into context, use Explore instead.

### Targeted file reads
Read the lines you need, not the whole file. A 4000-line file read for one function is 4000 tokens you don't get back.

## Habits

1. **One feature per session.** When the current task is done, `/clear` before the next.
2. **Externalize early.** If you discover a convention worth keeping, write it to `AGENTS.md` immediately — don't trust chat memory to survive compaction.
3. **Prefer durable artifacts over chat history.** Specs in `docs/specs/`, decisions in `MEMORY.md`, rules in `AGENTS.md`.
4. **Don't paste large files.** Reference them by path and let the agent read what it needs.
5. **Watch for drift.** If the agent's responses start contradicting earlier decisions, that's a compaction artifact. `/clear` and reload from your durable files.

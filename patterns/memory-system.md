# Memory System

Copilot CLI's repository memory persists notes across sessions in the same repo. It's useful for accumulating durable facts the agent learns. It's also easy to misuse.

## What memory is good for

- **User facts that don't change often.** "This team uses pnpm, not npm."
- **Non-obvious project quirks.** "The auth module has a circular dependency that breaks tree-shaking — don't try to clean it up."
- **Decisions with rationale.** "We chose Postgres over Mongo in 2024 because of the migration tooling, see ADR-007."
- **Cross-session continuity.** "Last session we agreed to defer the cache layer until v2."

## What memory is *not* good for

- **Things that must be loaded.** Memory match is heuristic, not guaranteed. If a rule must always apply, put it in `AGENTS.md` or a hook.
- **Code patterns.** The code is the source of truth. The agent can read it.
- **Git history.** `git log` and `git blame` are authoritative.
- **Conversation summaries.** That's what compaction is for.
- **Secrets or credentials.** Memory is plaintext on disk.

## How memory differs from `AGENTS.md`

| | Memory | `AGENTS.md` |
|---|---|---|
| Loaded | When the agent decides it's relevant | Every session, automatically |
| Editable by | Agent and human | Human (and agent if you ask) |
| Survives `/clear` | Yes | Yes |
| Format | Free-form notes | Markdown, structured |
| Best for | Accumulated learnings | Standing rules |

If a fact must be loaded every session, it belongs in `AGENTS.md`. If a fact is useful when relevant but not load-bearing, memory is fine.

## Maintenance

Memory drifts. Audit it periodically:

1. Run `/memory` to see current contents.
2. For each entry, ask: still true? still useful?
3. Delete the dead ones. Stale memory misleads the agent more than no memory.

A good cadence is: audit memory at the start of any new major work in the repo, and any time you notice the agent referencing something that no longer applies.

## How to write a good memory entry

- **One fact per entry.** Don't pack five things into one.
- **Why, not just what.** "We use pnpm" is weak. "We use pnpm because npm's lockfile churn was breaking CI in late 2024" is durable.
- **A reference if possible.** Link to an ADR, an issue, a PR, or a commit. Future-you needs to verify.
- **A trigger phrase.** Memory matches against natural-language requests; the entry should contain words the matching request would contain.

## When to convert memory to `AGENTS.md`

If a memory entry comes up in *every* session, it's not really a learning anymore — it's a standing rule. Promote it: copy it to `AGENTS.md`, delete the memory entry. This is a sign of healthy maturation.

## When to convert `AGENTS.md` to memory

Rare but valid: if a rule in `AGENTS.md` only applies in narrow cases, demoting it to memory frees up `AGENTS.md` space for things that always apply. But ask first whether the rule should be a Skill instead — Skills are made for "applies in narrow cases".

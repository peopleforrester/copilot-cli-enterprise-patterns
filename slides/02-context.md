---
marp: true
title: Context Management
paginate: true
---

# Pillar 1 — Manage Context

The window is finite. Treat it like RAM.

---

## Auto-compaction is not infinite context

- Copilot CLI auto-compacts at ~95%
- It summarizes — and summaries lose detail
- Specifics (paths, line numbers, exact errors) become "the gist"
- Plan as if compaction will happen

---

## The levers

| Lever | Use it for |
|---|---|
| `/clear` | Between unrelated tasks |
| `/usage` | Pre-flight long tasks |
| Explore subagent | Searches that would dump >2k tokens |
| Targeted reads | Specific line ranges, not whole files |

---

## The signal: your responses are drifting

- Agent contradicts a decision from earlier in the session
- Agent re-reads files it already read
- Agent references tasks you finished an hour ago
- Responses get longer and less specific

→ Time to `/clear`.

---

## One feature per session

- Pick one task
- Finish it
- `/clear`
- Pick the next task

The discipline is cheap. The failure mode is expensive.

---

## Externalize, don't memorize

- Decisions belong in `AGENTS.md` or `docs/`
- WIP belongs in commits or `docs/wip.md`
- Don't trust chat history to survive compaction

---

## Lab 01 — Context Recovery

You inherit a polluted session. Recover it without losing your colleague's WIP.

→ `labs/lab-01-context/`

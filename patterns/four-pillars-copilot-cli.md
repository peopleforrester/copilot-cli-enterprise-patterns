# The Four Pillars, mapped to GitHub Copilot CLI

The Four Pillars are tool-agnostic. The mechanics differ slightly between Claude Code and Copilot CLI, but the principles are identical. This doc maps each pillar to the specific Copilot CLI commands and workflows that implement it.

> Default model is **Claude Sonnet 4.5** — the same Anthropic model family that powers Claude Code. `/model` switches to Sonnet 4.6, Opus 4.6, Haiku 4.5, GPT-5.x, Gemini 3 Pro/Flash, or free models.

---

## Pillar 1 — Manage Context

The working window is a finite resource. Treat it like RAM: keep what's relevant, evict the rest.

**Copilot CLI mechanisms:**

- **Auto-compaction at 95%** (currently fixed, not configurable; tracked as feature request #1761). Compacts in the background without interrupting the user. Convenient but not magic — it summarises, and summaries lose detail.
- **`/compact`** — manual compaction when you want to control the timing.
- **`/clear`** resets the conversation. Use it between unrelated tasks. *One feature per session* still applies.
- **`/context`** shows a token-by-token breakdown of what's in the window.
- **`/usage`** reports current session stats. Check it before starting a long task.
- **`/undo`** and **`Esc-Esc`** roll back recent changes — `/undo` for the last action, `Esc-Esc` for a timeline picker over previous file snapshots.
- **Subagents** — `Explore`, `Plan`, `Task`, `Code Review`, and `Critic` — run in isolated context windows. Use them for searches, audits, and complementary-model plan review so the main window stays focused.
- **Targeted reads.** Use the file reader on specific line ranges instead of dumping entire large files into context.

**Failure mode:** running a single chat for half a day, then wondering why the agent forgot decisions made an hour ago. The fix is `/clear` plus written state (`AGENTS.md`, spec docs, memory).

---

## Pillar 2 — Plan Before Code

The cheapest place to catch a misunderstanding is before any code exists.

**Copilot CLI mechanisms:**

- **`Shift+Tab`** cycles modes: **Standard → Plan → Autopilot → Standard**. In Plan Mode the agent cannot edit files; it can only read, search, and propose.
- **`/plan`** explicitly requests a plan for the current task.
- **Review → approve → execute.** Read the plan. Push back on anything wrong. Approve. Then let it run.
- **Spec-driven dev** (see `.github/skills/spec-driven-dev/SKILL.md`) is the heavyweight version: a written spec lives in the repo as durable artifact.

**When to skip planning:** single-file bug fixes with an obvious cause, trivial renames, doc typos. Anything that touches more than one file: plan first.

---

## Pillar 3 — Externalize Decisions

Standards belong in files, not in your head and not in chat history.

**Copilot CLI mechanisms:**

| Mechanism | Scope | Loaded when |
|---|---|---|
| `AGENTS.md` | Per-repo, plain markdown, nearest-wins tree walk | Every session, on the directory of the file being touched |
| `.github/copilot-instructions.md` | Per-repo (also reads in IDE Copilot) | Every session in that repo |
| `.github/instructions/**/*.instructions.md` (with `applyTo` glob) | Path-targeted | When the agent touches a matching path |
| `~/.copilot/copilot-instructions.md` | Per-user, all repos | Every session, this user |
| Skills (`SKILL.md`) | Reusable workflows | Triggered by description match or `/skill-name` |
| Custom agents (`.agent.md`) | Specialised personas with scoped tools/MCPs | `/agents` picker, `--agent`, or auto-delegation |
| Repository memory (Pro/Pro+ preview) | Auto-saved learnings | Across sessions in same repo |
| Hooks | Deterministic enforcement | On matching lifecycle events (8+ event types) |

**The rule:** if you find yourself giving the agent the same instruction twice, it belongs in one of the files above. If the rule must be enforced (not merely suggested), it belongs in a hook, not an instructions file.

See `patterns/externalization-patterns.md` for detail.

---

## Pillar 4 — Verify Output

Advisory instructions work ~80% of the time. Deterministic verification works 100%.

**Copilot CLI mechanisms:**

- **`postToolUse` hooks** run after a tool executes. Use them to run linters and tests. They cannot block, but their output is surfaced back to the agent, which then has to react.
- **`preToolUse` hooks** are the **only** event type that can block tool execution. They block by emitting `{"deny": true, "reason": "..."}` on stdout — *not* by exit code. Use them as security gates: deny edits to protected paths, deny dangerous shell patterns, deny secret reads.
- **`/diff`** shows every change in the current session. Run it before committing.
- **Built-in Code Review subagent** can be invoked to audit the diff against project standards.
- **The test suite** is the final word. Pristine output is the bar — noisy passing tests hide regressions.

> If a rule is important enough to repeat, it is important enough to enforce with a hook.

---

## Putting it together: a typical session

1. `git checkout staging && git pull` — start clean.
2. `Shift+Tab` → describe the task → review the plan → approve.
3. Agent edits files. `preToolUse` lint hook runs on each edit and denies if lint fails.
4. `postToolUse` test hook runs after each edit. Failures bounce back to the agent automatically.
5. `/diff` to review the full session.
6. Code Review subagent for a second pass.
7. Commit, push to `staging`, open PR to `main`.
8. `/clear` before the next task.

# The Four Pillars, mapped to GitHub Copilot CLI

The Four Pillars are tool-agnostic. The mechanics differ slightly between Claude Code and Copilot CLI, but the principles are identical. This doc maps each pillar to the specific Copilot CLI commands and workflows that implement it.

> Default model is **Claude Sonnet** — the same Anthropic model that powers Claude Code. `/model` switches to Opus 4.6, GPT-5.3-Codex, or Gemini 3 Pro.

---

## Pillar 1 — Manage Context

The working window is a finite resource. Treat it like RAM: keep what's relevant, evict the rest.

**Copilot CLI mechanisms:**

- **Auto-compaction at 95%.** Copilot CLI compacts the conversation automatically when context fills. Claude Code requires manual `/compact`. Auto-compaction is convenient but not magic — it summarizes, and summaries lose detail. Plan as if it will happen, not as if it makes context infinite.
- **`/clear`** resets the conversation. Use it between unrelated tasks. *One feature per session* still applies.
- **`/usage`** reports current token consumption. Check it before starting a long task.
- **Subagents** — `Explore`, `Plan`, `Code Review`, and the generic task agent — run in their own context windows. Use them for searches and audits so the main window stays focused on the change you're making.
- **Targeted reads.** Use the file reader on specific line ranges instead of dumping entire large files into context.

**Failure mode:** running a single chat for half a day, then wondering why the agent forgot decisions made an hour ago. The fix is `/clear` plus written state (`AGENTS.md`, spec docs, memory).

---

## Pillar 2 — Plan Before Code

The cheapest place to catch a misunderstanding is before any code exists.

**Copilot CLI mechanisms:**

- **`Shift+Tab`** toggles **Plan Mode** — same key as Claude Code. In plan mode the agent cannot edit files; it can only read, search, and propose.
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
| `AGENTS.md` | Per-repo project rules | Every session in that repo |
| `.github/copilot/instructions.md` | Per-user, all repos | Every session, this user |
| Skills (`SKILL.md`) | Reusable workflows | When triggered by description match |
| Repository memory | Auto-saved learnings | Across sessions in same repo |
| Hooks | Deterministic enforcement | On matching tool calls |

**The rule:** if you find yourself giving the agent the same instruction twice, it belongs in one of the files above. If the rule must be enforced (not merely suggested), it belongs in a hook, not an instructions file.

See `patterns/externalization-patterns.md` for detail.

---

## Pillar 4 — Verify Output

Advisory instructions work ~80% of the time. Deterministic verification works 100%.

**Copilot CLI mechanisms:**

- **`PostToolUse` hooks** run after a file edit. Use them to run linters and tests. Failures are surfaced back to the agent, which then has to fix them — not you.
- **`PreToolUse` hooks** run before a tool executes. Use them as security gates: block edits to protected paths, block dangerous shell patterns.
- **`/diff`** shows every change in the current session. Run it before committing.
- **Built-in Code Review subagent** can be invoked to audit the diff against project standards.
- **The test suite** is the final word. Pristine output is the bar — noisy passing tests hide regressions.

> If a rule is important enough to repeat, it is important enough to enforce with a hook.

---

## Putting it together: a typical session

1. `git checkout staging && git pull` — start clean.
2. `Shift+Tab` → describe the task → review the plan → approve.
3. Agent edits files. `PreToolUse` lint hook runs on each edit.
4. `PostToolUse` test hook runs after each edit. Failures bounce back to the agent automatically.
5. `/diff` to review the full session.
6. Code Review subagent for a second pass.
7. Commit, push to `staging`, open PR to `main`.
8. `/clear` before the next task.

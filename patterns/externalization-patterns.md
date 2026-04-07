# Externalization Patterns

If you give the agent the same instruction twice, it belongs in a file. If the rule must be enforced rather than suggested, it belongs in a hook.

## The five places to put a rule

| Mechanism | Path | Scope | Enforcement |
|---|---|---|---|
| Project instructions | `AGENTS.md` | One repo, every session | Advisory |
| User instructions | `~/.copilot/copilot-instructions.md` | All repos, one user | Advisory |
| Skill | `.github/skills/<name>/SKILL.md` (project) or `~/.copilot/skills/<name>/SKILL.md` (user) | Triggered on description match | Advisory, structured |
| Memory | Repository memory (Pro/Pro+ public preview) | Across sessions in same repo | Advisory |
| Hook | `.github/hooks/*.json` (project) or `~/.copilot/hooks/*.json` (user) | Matching tool calls | **Deterministic** |

## How to choose

**Use `AGENTS.md`** for rules that are project-specific and apply broadly: language version, test framework, branch workflow, security boundaries. Plain markdown, no frontmatter; nearest-wins tree walk lets you place per-package overrides in subdirectories.

**Use `.github/copilot-instructions.md`** when you want the same instructions to apply to Copilot CLI *and* Copilot Chat / IDE code review.

**Use `.github/instructions/**/*.instructions.md` with `applyTo` glob frontmatter** when a rule should only load for files matching a pattern (e.g., `applyTo: "src/api/**/*.ts"`).

**Use user instructions** for personal preferences that follow you between repos: tone, response style, default behaviors.

**Use a Skill** for a *workflow* — a sequence of steps the agent should follow when a particular kind of request arrives. Skills have a description that the agent matches against incoming tasks. Good Skills have explicit steps, exit conditions, and anti-patterns.

**Use memory** for things the agent learns over time and you want to persist without manually editing files. Memory is good for accumulating non-obvious facts; it's bad for things you need to be sure are loaded (memory match is heuristic).

**Use a hook** when the rule must hold every time, no exceptions. Hooks run code; they cannot be talked out of running.

## The "advisory works ~80%" rule

Advisory instructions — `AGENTS.md`, instructions.md, Skills — work most of the time. They fail in the cases where it matters most: long sessions, ambiguous requests, after compaction. Anything safety-critical (security gates, test enforcement, branch protection) should be a hook, not a paragraph in a markdown file.

## Anti-patterns

- **Bloating `AGENTS.md`.** A 2000-line `AGENTS.md` is mostly ignored. Keep it under ~500 lines and split off detail into Skills or `docs/`.
- **Skills with vague descriptions.** "Helps with code quality" will never trigger correctly. Skill descriptions must be specific enough that the agent can match them.
- **Hooks that aren't blocking.** A hook that runs but doesn't fail the operation is a notification, not a guardrail.
- **Duplicating rules across mechanisms.** When the rule changes, you'll update one and forget the others. Pick one home for each rule.
- **Putting secrets in any of these files.** Secrets belong in a secret manager, period.

## Maintenance

- Review `AGENTS.md` quarterly. Delete rules that are no longer true. Stale rules erode trust in the file.
- When a rule moves from advisory to enforced, delete the advisory copy.
- When you find yourself fighting a rule, ask whether the rule is wrong, not whether to bypass it.

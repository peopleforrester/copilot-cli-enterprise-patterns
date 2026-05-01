# AGENTS.md Template

`AGENTS.md` is an open standard (Linux Foundation / Agentic AI Foundation) — **plain markdown, no YAML frontmatter**. It is "a README for agents" and is read by Copilot CLI, Codex, Cursor, Jules, and others.

Copy the template below into your repo root and edit. Keep it under ~500 lines — `AGENTS.md` loads into context and bloat dilutes the parts that matter.

## How Copilot CLI resolves it

- **Directory tree walk, nearest-wins.** When the agent is editing a file, the closest `AGENTS.md` walking up the directory tree wins. You can place one at the repo root and override per package.
- **Loads alongside (not instead of) other instruction sources** — see "The full instruction hierarchy" below.
- **No frontmatter.** Just markdown.

## Template

```markdown
# AGENTS.md

## Project conventions
- Languages: <e.g., TypeScript (Node 20+, strict), Python 3.11+>
- Package manager: <pnpm / uv / cargo / go mod>
- Formatter: <prettier / ruff / rustfmt / gofmt> — line length <100>
- Test runner: <vitest / pytest / cargo test / go test>
- Test location: <co-located / tests/ directory>
- Type hints: required on new code
- Commits: Conventional Commits, imperative mood, no AI attribution
- Branches: work on `staging`, merge to `main` only via PR

## Security boundaries — do not touch without approval
- `infra/`, `terraform/`, `*.tf`, `*.tfvars`
- `.github/workflows/*.yml`
- `secrets/`, `.env*`, `*credentials*`, `*.pem`, `*.key`
- Production config files

## Coding standards
- Catch specific exceptions, never bare catch
- Validate at system boundaries; trust internal calls
- No silent fallbacks; fail loud
- No mocks/stubs without approval
- Functions stay focused — split when they grow past ~40 lines
- Comments explain *why*, not *what*

## Verification — required before "done"
1. Lint changed files. Zero warnings.
2. Run the test suite. Green AND pristine output.
3. New public functions need a test (TDD).
4. Run `/diff` and review before committing.

Hooks in `.github/hooks/` enforce 1 and 2 automatically. Do not bypass.

## Workflow
- Plan first for any change touching >1 file (`Shift+Tab` to Plan Mode)
- One feature per session — `/clear` before the next
- Externalise learnings: add them here or to a Skill
- Ask, don't assume — ambiguous requirements get a question, not a guess
```

## The full instruction hierarchy

Copilot CLI loads **all** of these simultaneously (they combine, they don't override):

| Source | Path | Scope |
|---|---|---|
| `AGENTS.md` | Any directory; nearest-wins tree walk | Cross-agent standard |
| `.github/copilot-instructions.md` | Repo root | Copilot CLI + Copilot Chat + IDE code review |
| `.github/instructions/**/*.instructions.md` | Path-specific with `applyTo` glob | Targeted rules |
| `~/.copilot/copilot-instructions.md` | User home | Personal, all repos |
| `CLAUDE.md`, `GEMINI.md` | Repo root | Backward compatibility |
| `COPILOT_CUSTOM_INSTRUCTIONS_DIRS` | Env var | Extra directories |

### Path-specific `.instructions.md` files

These *do* take YAML frontmatter (unlike `AGENTS.md` itself). The `applyTo` glob restricts when the rule loads:

```markdown
---
applyTo: "src/api/**/*.ts"
---

# API Routes

Always use zod for request validation in API routes.
Return errors with the standard `{ "error": { "code": "...", "message": "..." } }` envelope.
```

Place these under `.github/instructions/`. Use them when a rule applies to one slice of the codebase rather than the whole repo.

## Per-package overrides via tree walk

For monorepos:

```text
repo/
├── AGENTS.md                  ← root rules
├── packages/
│   ├── api/
│   │   └── AGENTS.md          ← overrides for API package
│   └── web/
│       └── AGENTS.md          ← overrides for web package
```

When the agent edits `packages/api/src/foo.ts`, it loads `packages/api/AGENTS.md` (closest), not the root. You don't need to repeat root rules in the package files — but if you contradict them, the closer file wins.

## What to add per project

Each repo will want a few extras. Add only what's true:

- **Domain glossary** — three to five terms specific to this codebase that an outsider would misread.
- **Where the hot paths live** — one or two file references.
- **Known sharp edges** — gotchas that have already burned someone.
- **External services** — what the code talks to and where the real credentials live (the secret manager, *not* in this file).

## What NOT to add

- A wall of language style rules duplicated from a linter config — the linter is already enforcing them.
- Onboarding history ("we used to use Webpack...") — write that in `docs/`.
- Personal preferences — those belong in `~/.copilot/copilot-instructions.md`.
- YAML frontmatter (it's not part of the AGENTS.md standard).
- Anything you wouldn't want every session to read every time.

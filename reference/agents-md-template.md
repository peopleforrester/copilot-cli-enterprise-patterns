# AGENTS.md Template

Copy this into your repo root and edit. Keep it under ~500 lines — `AGENTS.md` is loaded every session, and bloat dilutes the parts that matter.

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
- Plan first for any change touching >1 file (`Shift+Tab`)
- One feature per session — `/clear` before the next
- Externalise learnings: add them here or to a Skill
- Ask, don't assume — ambiguous requirements get a question, not a guess
```

## What to add per project

Each repo will want a few extras. Add only what's true:

- **Domain glossary** — three to five terms specific to this codebase that an outsider would misread.
- **Where the hot paths live** — one or two file references (e.g., "all HTTP routes register in `src/router.ts`").
- **Known sharp edges** — gotchas that have already burned someone.
- **External services** — what the code talks to and where the real credentials live (the secret manager, *not* in this file).

## What NOT to add

- A wall of language style rules duplicated from a linter config — the linter is already enforcing them.
- Onboarding history ("we used to use Webpack, then we moved to Vite...") — write that in `docs/`, not here.
- Personal preferences — those belong in your user-level `~/.config/copilot/instructions.md`.
- Anything you wouldn't want every session to read every time.

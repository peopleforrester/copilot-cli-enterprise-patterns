# AGENTS.md

Project-level instructions for GitHub Copilot CLI. Auto-loaded every session.

## Project conventions

- **Languages**: TypeScript (Node 20+, strict mode) and Python 3.11+.
- **Package managers**: `pnpm` for TS, `uv` for Python. Do not introduce npm or pip without discussion.
- **Formatting**: Prettier (TS), Ruff (Python). 100-char line length. 4-space indent for Python, 2-space for TS.
- **Type hints**: Required on all new Python code. `strict: true` enforced for TS.
- **Tests**: Vitest (TS), pytest (Python). Co-locate tests next to source: `foo.ts` ↔ `foo.test.ts`.
- **Commits**: Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`). Imperative mood. No AI attribution lines.
- **Branches**: Work on `staging`. Only merge to `main` after CI passes on `staging`.

## Security boundaries — do NOT touch without explicit approval

- `infra/`, `terraform/`, `*.tf`, `*.tfvars`
- `.github/workflows/*.yml` (CI/CD)
- `secrets/`, any `.env*` file, any `*credentials*`, `*.pem`, `*.key`
- Database migrations once merged to `main`
- Production config files (`config/production.*`)

If a task requires changes in any of the above, **stop and ask**.

## Coding standards

- **Error handling**: catch specific exceptions, never bare `except:` or `catch (e) {}`. Log with structured fields, not string concatenation.
- **Validation**: validate at system boundaries (HTTP handlers, queue consumers, CLI args). Trust internal calls.
- **No fallbacks without permission**: code should fail explicitly. Do not silently default.
- **No mock modes**: use real services in dev. If a service is unavailable, fail loud.
- **Small functions**: single responsibility. If a function exceeds ~40 lines, consider splitting.
- **Comments**: explain *why*, not *what*. Every source file starts with two `ABOUTME:` lines describing its purpose.

## Output verification — required before declaring a task done

1. Run the linter on changed files. Zero warnings.
2. Run the test suite. All green. Capture and review log output — pristine output is a requirement, not a nice-to-have.
3. For any new public function, a test must exist before the function is considered complete (TDD).
4. Run `/diff` and review the full session diff before committing.

The `preToolUse` and `postToolUse` hooks in `.github/hooks/` enforce steps 1 and 2 automatically. Do not bypass them.

## Workflow expectations

- **Plan first** for any change touching more than one file. Use `Shift+Tab` to enter plan mode.
- **One feature per session.** When the current task is done, `/clear` before starting the next.
- **Externalize learnings.** If you discover a non-obvious convention or gotcha, add it to this file or the relevant Skill — do not let it live only in chat.
- **Ask, don't assume.** If a requirement is ambiguous, ask. Do not guess and ship.

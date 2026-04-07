# AGENTS.md (the bloated original — fictional team)

## History

Originally written in early 2024 by Bob. Updated by Sarah in May 2024. Major revision in November 2024 after the auth incident. Minor cleanup in February 2025 (mostly removing references to Webpack since we moved to Vite). The team currently maintains this file collectively, although in practice nobody touches it.

## Project background

We are building a SaaS product for managing fleet operations. The project started as a Rails monolith in 2019, was partially rewritten in Node in 2021, and is currently TypeScript on the frontend and Python on the backend. We tried Go for the API gateway briefly in 2022 and rolled it back. Don't suggest Go again.

## Indentation

Use 4 spaces for Python. Use 2 spaces for TypeScript. Use 2 spaces for JSON. Use 4 spaces for shell scripts. Use 2 spaces for YAML. Tabs are forbidden in all files except Makefiles where they are required.

## Line length

100 characters maximum. Some files in `legacy/` violate this; do not fix them as part of unrelated work.

## Naming

Variables and functions use snake_case in Python and camelCase in TypeScript. Classes use PascalCase. Constants use UPPER_SNAKE_CASE. Files in `src/` use kebab-case for TypeScript and snake_case for Python. Test files end in `.test.ts` or `_test.py`. Mock files (which we have despite Bob's protests) end in `.mock.ts`.

## Imports

Standard library first, then third-party, then local. Within each group, alphabetize. Group separated by a blank line. In TypeScript, use named imports unless the module exports a default. In Python, never use star imports. Do not use relative imports in Python beyond a single level.

## Error handling

Catch specific exceptions, never bare `except:` or `catch (e) {}`. Log errors with structured fields, not f-strings or template literals. Re-raise after logging if the caller can do something useful.

## Logging

Use the `structlog` library in Python and `pino` in TypeScript. Log levels: DEBUG for tracing, INFO for state transitions, WARNING for unexpected-but-handled situations, ERROR for failures, CRITICAL for things that will page someone. Do not use `print()`. Do not use `console.log()` in production code, only in tests and CLIs.

## Testing

We use pytest in Python and vitest in TypeScript. Test files live next to source files. Aim for 80% coverage but do not chase 100%. Integration tests live in `tests/integration/`. End-to-end tests live in `tests/e2e/` and run only in CI. Never mock the database in integration tests — we got burned by that in the November 2024 incident.

## Personal preferences (Bob)

I like terse responses. Don't explain what you did at the end of every response, I can read the diff. Don't use emojis ever. Never say "I" — refer to actions in passive voice.

## Personal preferences (Sarah)

Verbose responses are fine for me. I like explanations. Use emojis when helpful but don't overdo it. Active voice preferred.

## Things Bob said in the 2024 retro

- "We don't refactor on Fridays."
- "If you find yourself writing a base class, stop."
- "The auth module is haunted, just don't touch it."
- "Anything in `legacy/` is the past, anything in `src/` is the present, anything in `experimental/` is Sarah's hobby."
- "We don't write tests for migrations because they're write-once."

## Security

Do not edit anything in `infra/`. Do not edit `.github/workflows/`. Do not read `.env` files. Do not commit secrets. Do not push to `main` directly. Do not run `terraform apply` without a human reviewing the plan.

## Database migrations

Use Alembic for Python and Prisma migrations for the TypeScript services. Migrations are immutable once merged to `main` — never edit a migration file after it's been deployed. New migrations go through staging first.

## Branching

Work on `staging`. Open PRs from `staging` to `main`. Never push directly to `main`. Hot fixes follow the same flow but are tagged `hotfix/` and skip the usual review queue.

## Commit messages

Conventional Commits. Imperative mood. Reference the issue number in the body, not the subject. Maximum 72 characters in the subject line. No AI attribution lines.

## API conventions

REST endpoints follow `/api/v{n}/{resource}` plurals. Query parameters in snake_case (because the Python team won that argument). Response bodies always envelope: `{"data": ..., "meta": ...}`. Error responses: `{"error": {"code": "...", "message": "..."}}`. HTTP status codes: 200 for success, 201 for created, 204 for no content, 400 for client error, 401 for unauth, 403 for forbidden, 404 for not found, 422 for validation error, 500 for server error.

## Frontend

We use React with Vite. State management is Zustand for local state and TanStack Query for server state. Routing is React Router v6. Styling is Tailwind. Component library is our internal `@fleet/ui`. Forms use React Hook Form with Zod validation.

## Backend

FastAPI for HTTP services. Celery for background jobs. Redis for cache and Celery broker. Postgres for primary store. We previously used MongoDB for one service and migrated off; do not suggest MongoDB.

## Things Sarah said in the 2025 planning

- "We need to start writing specs before code."
- "The agent is a junior dev — treat it like one."
- "If you tell it the same thing twice, write it down."

## Style preferences I forgot to put above

Function length: prefer under 40 lines. If a function exceeds 80 lines, split it. Class length: prefer under 200 lines. File length: prefer under 500 lines. Module length: no hard rule.

## Environments

`dev` — local development. `staging` — integration. `prod` — production. Each has its own `.env` file (do not commit). Configuration is via environment variables, never hard-coded.

## Documentation

Update docs in the same PR as code changes. README files in each top-level directory. Architectural decisions in `docs/adr/` using the Nygard format.

## Deprecated rules (do not follow)

- Old rule about 2-space Python indentation (we changed in 2023)
- Old rule about MongoDB (we don't use it anymore, see above)
- Old rule about jest (we use vitest now)
- Old rule about Webpack (we use Vite now)

## Note from Bob, 2025-Q3

The agent keeps suggesting we use `dataclasses` instead of `pydantic` BaseModels. Don't. We have a reason. The reason is that we serialize to JSON over the wire and pydantic does the validation in one place.

## Note from Sarah, 2025-Q4

The agent keeps trying to add `try/except Exception` around everything. Stop it. Catch specific exceptions only.

## Final note

This file is too long. We know. Someone should clean it up.

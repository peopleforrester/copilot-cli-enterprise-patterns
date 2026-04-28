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

## More history

Bob added the indentation section in March 2024 after a long argument with Carlos about tabs. Carlos lost. Carlos left the team in June 2024 but his commits are still all over the auth module. The November 2024 auth incident was traced back to one of Carlos's commits in `auth/session.py`, specifically the silent fallback when `SESSION_SECRET` was unset. We added the deny rule about `.env` files after that. Priya joined in January 2025 and immediately rewrote the logging layer; the old `loguru`-based code is still in `legacy/logging_old.py` but nothing imports it anymore. Sarah went on parental leave for most of Q2 2025. During that time Bob added the "no Go" rule because the new contractor kept proposing rewrites in Go.

## Even more history

The November 2024 auth incident is documented in `docs/adr/0014-auth-rewrite.md`. The summary: a mocked database in an integration test masked a session-token rotation bug, which made it to production and forced a credential reset for ~3,200 customers. The agent should know this story so that when it suggests mocking the database "just for this one test", it understands why the answer is no. Sarah wrote up the postmortem and the action items; the action items were partially implemented (the mock-detection lint rule shipped; the integration test reorganization did not).

## Pre-history (rolled-back Go gateway, 2022)

We tried Go for the API gateway in summer 2022. The motivation was performance — the FastAPI gateway was getting hit at ~8k req/s and we were seeing tail latencies climb. The Go rewrite shipped in October 2022 and reduced p99 latency by about 40%. Then in January 2023 we discovered that the Go service wasn't honoring the same auth-token expiry semantics as the Python services, which created a window where revoked tokens were still accepted at the gateway for up to 90 seconds. We rolled back to FastAPI in February 2023 and the Go code is now in `experimental/go-gateway-archive/` (do not delete — Bob wants to keep it as a reference).

## Old PR review checklist (deprecated, see new one in Notion)

1. Did you run the tests?
2. Did you update the docs?
3. Did you check for secrets?
4. Did you tag a reviewer?
5. Did you link the issue?
6. Did you update the changelog?
7. Did you bump the version?
8. Did you check coverage?
9. Did you check the bundle size?
10. Did you check the migration plan?
11. Did you check accessibility (frontend only)?
12. Did you check the i18n strings (frontend only)?
13. Did you check the OpenAPI spec is regenerated (backend only)?
14. Did you check the Postman collection still works (backend only)?

The new checklist is shorter and lives in the Notion runbook. Use that one. This list is here for reference because Bob hasn't deleted it yet.

## Personal preferences (Carlos, departed)

Carlos preferred tabs. Carlos preferred 2-space indentation in Python (against PEP 8). Carlos preferred `var` over `let` in TypeScript ("readability"). Carlos preferred snake_case in TypeScript. Carlos lost every one of these arguments. His preferences are documented here for archeological reasons because his commits sometimes look "wrong" to the agent and the agent then proposes "fixes" that are actually just reverting Carlos's preferences to the team's preferences. The team's preferences are correct; Carlos's are not. Don't auto-revert Carlos's commits.

## Personal preferences (Priya)

Priya likes detailed commit messages. Priya likes well-formatted markdown in PR descriptions with section headings. Priya likes the term "happy path" but dislikes the term "sad path" (use "error path" instead). Priya prefers structured logs with explicit field names rather than positional substitution. Priya wrote most of the current `structlog` configuration. If something looks wrong in the logging layer, ask Priya before changing it.

## Personal preferences (Marcus, contractor 2024-2025)

Marcus preferred functional patterns in TypeScript. Marcus wrote most of the `utils/fp.ts` module. Marcus is no longer with the team but his code is still in production. Don't refactor `utils/fp.ts` unless you have a concrete reason; it works.

## Personal preferences (the unnamed person who wrote the form library wrapper)

This person is no longer with the team and nobody remembers who they were. They wrote `src/components/forms/wrapper.tsx`, which wraps React Hook Form in a way that nobody on the current team fully understands. It works. Leave it alone. Sarah has tried twice to refactor it and given up.

## Editor configuration (also see .editorconfig)

We use `.editorconfig` for cross-editor consistency. The settings are:

- `indent_style = space`
- `indent_size = 4` for Python and shell, `indent_size = 2` for everything else
- `end_of_line = lf`
- `charset = utf-8`
- `trim_trailing_whitespace = true`
- `insert_final_newline = true`
- Markdown files: `trim_trailing_whitespace = false` (for line breaks)

These are also in `.editorconfig` at the repo root. They are duplicated here because Bob doesn't trust that the agent will read `.editorconfig` automatically. (It does, via the lint hook. But Bob is being cautious.)

## VS Code settings

Recommended VS Code extensions:

- Python (`ms-python.python`)
- Pylance (`ms-python.vscode-pylance`)
- Ruff (`charliermarsh.ruff`)
- ESLint (`dbaeumer.vscode-eslint`)
- Prettier (`esbenp.prettier-vscode`)
- TypeScript Vue Plugin (`Vue.vscode-typescript-vue-plugin`) — *we do not use Vue*. Why is this here? Probably leftover from when someone was evaluating Vue in 2023. Delete this line eventually.
- Tailwind CSS IntelliSense (`bradlc.vscode-tailwindcss`)
- GitLens (`eamodio.gitlens`)
- Docker (`ms-azuretools.vscode-docker`)
- YAML (`redhat.vscode-yaml`)

Recommended workspace settings (these are in `.vscode/settings.json` already):

```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit",
    "source.organizeImports": "explicit"
  },
  "python.formatting.provider": "none",
  "[python]": {
    "editor.defaultFormatter": "charliermarsh.ruff",
    "editor.tabSize": 4
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2
  }
}
```

Yes, this duplicates `.vscode/settings.json`. Yes, it's already in the repo. It's also here because Bob.

## Prettier configuration (also in .prettierrc)

```json
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "all",
  "printWidth": 100,
  "tabWidth": 2,
  "arrowParens": "always",
  "bracketSpacing": true,
  "endOfLine": "lf"
}
```

This is in `.prettierrc.json` at the repo root. The lint hook reads it. The CI reads it. The agent reads it. It does not need to be in this file. It is in this file anyway.

## ESLint configuration (also in eslint.config.js)

We use the flat config format. Key rules:

- `@typescript-eslint/no-explicit-any`: error
- `@typescript-eslint/no-unused-vars`: error (with `argsIgnorePattern: "^_"`)
- `@typescript-eslint/explicit-function-return-type`: warn (only on exported functions)
- `@typescript-eslint/no-floating-promises`: error
- `@typescript-eslint/await-thenable`: error
- `react-hooks/rules-of-hooks`: error
- `react-hooks/exhaustive-deps`: warn
- `import/order`: error (configured to match the Imports section above)
- `no-console`: warn (allow `console.warn` and `console.error`)

These are in `eslint.config.js`. The agent should never need to look at this list because the lint hook will tell it when something is wrong. This list exists because Bob copied it out of the config file once and never deleted it.

## Ruff configuration (also in pyproject.toml)

We enable the following rule selects:

- `E` (pycodestyle errors)
- `W` (pycodestyle warnings)
- `F` (Pyflakes)
- `I` (isort)
- `N` (pep8-naming)
- `UP` (pyupgrade)
- `B` (flake8-bugbear)
- `S` (flake8-bandit, security)
- `C4` (flake8-comprehensions)
- `SIM` (flake8-simplify)
- `RUF` (Ruff-specific rules)

Excluded paths: `legacy/`, `experimental/`, `migrations/versions/`. Per-file ignores: `tests/**/*.py` ignores `S101` (use of assert). Line length: 100 (matches the Line length section above). Target Python version: 3.11.

This is in `pyproject.toml` under `[tool.ruff]`. It is also here because Bob.

## Pyright / Pylance configuration

`typeCheckingMode = "strict"` for `src/`, `"basic"` for `legacy/` and `experimental/`. `reportMissingImports = "error"`. `reportMissingTypeStubs = "warning"`. `reportPrivateUsage = "warning"`. `pythonVersion = "3.11"`. `pythonPlatform = "Linux"`. We do not type-check shell scripts (obviously).

This is in `pyrightconfig.json`. The agent should not need this.

## TypeScript configuration

`tsconfig.json` extends `@tsconfig/strictest`. Notable overrides:

- `target: "ES2022"`
- `module: "ESNext"`
- `moduleResolution: "bundler"`
- `jsx: "react-jsx"`
- `noUncheckedIndexedAccess: true`
- `exactOptionalPropertyTypes: true`
- `paths`: `@/*` → `src/*`, `@fleet/ui` → `packages/ui/src`

The agent should reference `tsconfig.json` directly when it needs this, not this file.

## Git configuration recommendations

Set your local git user name and email to your GitHub-verified email. We use signed commits via SSH keys (not GPG). Set `commit.gpgsign = true` and `gpg.format = ssh` and `user.signingkey` to your SSH public key path. We use `pull.rebase = true` (no merge commits on feature branches). We use `push.autoSetupRemote = true`. We use `init.defaultBranch = main`. The agent does not need to set any of this; it inherits whatever the user configured. This section exists for human onboarding.

## Conventional Commits expanded

We use Conventional Commits. The allowed types are:

- `feat`: a new feature
- `fix`: a bug fix
- `docs`: documentation only
- `style`: formatting changes (no code change)
- `refactor`: code change that neither fixes a bug nor adds a feature
- `perf`: performance improvement
- `test`: adding or fixing tests
- `chore`: maintenance, dependencies, build
- `ci`: CI/CD configuration
- `revert`: revert a previous commit

The scope is optional but encouraged: `feat(auth): add SSO support`. Breaking changes are marked with `!` in the type: `feat(api)!: change response envelope shape`. The body should explain *why*, not *what*. The footer references issues: `Refs: #1234` or `Closes: #1234`. Co-author lines are allowed: `Co-authored-by: Name <email>`.

This is also in `CONTRIBUTING.md`. Both copies exist. They are not always in sync. Trust `CONTRIBUTING.md` when they disagree, except when this one is more strict, in which case follow this one. (Yes, that is unhelpful. Sarah keeps meaning to fix it.)

## Pre-commit hooks (these are in .pre-commit-config.yaml)

We run the following hooks:

- `trailing-whitespace`
- `end-of-file-fixer`
- `check-yaml`
- `check-json`
- `check-toml`
- `check-merge-conflict`
- `check-added-large-files` (max 500KB)
- `detect-private-key`
- `ruff` (Python lint + format)
- `prettier` (TypeScript, JSON, Markdown, YAML)
- `mypy` (Python type check)
- `tsc --noEmit` (TypeScript type check)
- `vitest --run --changed` (TypeScript tests for changed files)
- `pytest --testmon` (Python tests for changed files)

Install with `pre-commit install`. The first run takes a while because it sets up isolated environments for each tool. Subsequent runs are fast.

## CI pipeline overview

GitHub Actions runs the following on every PR:

1. Checkout code
2. Set up Python 3.11 and Node 20
3. Cache `~/.cache/pip` keyed on `requirements*.txt` hash
4. Cache `node_modules` keyed on `pnpm-lock.yaml` hash
5. Install dependencies (`pip install -r requirements-dev.txt`, `pnpm install --frozen-lockfile`)
6. Run linters (`ruff check`, `eslint .`, `prettier --check .`)
7. Run type checkers (`mypy src/`, `tsc --noEmit`)
8. Run unit tests (`pytest tests/unit/`, `vitest run`)
9. Run integration tests (`pytest tests/integration/` against an ephemeral Postgres in a service container)
10. Run e2e tests (`playwright test`) — only on `main` and on PRs labeled `run-e2e`
11. Build the frontend bundle and check size against the budget (`bundlesize`)
12. Build the Docker images and push to the staging registry on `main`
13. Notify Slack `#ci-firehose` on failure

This is documented in `.github/workflows/ci.yml`. The agent should not need this overview.

## Old CI pipeline (CircleCI, deprecated 2024)

We used to use CircleCI. The old config is in `.circleci/config.yml.bak`. We migrated to GitHub Actions in March 2024 because (a) the org standardized on Actions, and (b) the cache hit rate was better. The CircleCI config is preserved as a reference and so we can roll back if needed (we will not need to). Do not edit the `.bak` file. Do not delete it either; Bob is sentimental about it.

## Old build system (Webpack, deprecated 2025)

We used Webpack with a custom config until February 2025. The migration to Vite reduced cold dev-server startup from ~14s to ~600ms. The Webpack config is in `legacy/webpack.config.js.archived`. Do not reference it. Do not delete it. The list of differences between Webpack and Vite that bit us during migration is in `docs/migrations/vite.md`. There were three: (1) different env-var prefix (`VITE_` vs `REACT_APP_`), (2) different handling of CommonJS dependencies, (3) different default of `define` for `process.env`. All three are now handled.

## Old test runner (Jest, deprecated 2024)

We used Jest until November 2024. We migrated to Vitest because the Vite ecosystem alignment was easier. Most tests transferred unchanged; the ones that did not were Jest-mock-API tests that depended on Jest's auto-mocking behavior. Vitest's `vi.mock` is similar but not identical. The migration notes are in `docs/migrations/vitest.md`.

## Old database (MongoDB, deprecated 2023)

The route-planning service used MongoDB from 2020 to 2023. We migrated it to Postgres because (a) we wanted a single primary store, (b) the team did not have deep MongoDB ops experience, (c) the schema had stabilized and we no longer benefited from the document model. The migration is documented in `docs/adr/0008-route-service-postgres.md`. The agent has been suggesting MongoDB for new services. Stop suggesting MongoDB.

## Old auth vendor (Auth0, deprecated 2024)

We used Auth0 from 2019 to 2024. We migrated to a self-hosted Keycloak in mid-2024 for cost and data-residency reasons. The migration was painful. Do not propose Auth0 for new auth needs. Do not propose Cognito either. We are on Keycloak now and we are staying on Keycloak.

## Old feature-flag system (LaunchDarkly, deprecated 2025)

We used LaunchDarkly until early 2025. We migrated to a self-hosted Unleash because of the same cost and data-residency reasons. The migration was less painful than the Auth0 one. Configuration is in `infra/unleash/`. The agent does not need to know how to add a flag; that is in the runbook.

## Old logging stack (ELK, deprecated 2024)

We used Elasticsearch + Logstash + Kibana for logging until late 2024. We migrated to a managed Loki + Grafana stack because the ELK ops burden was too high for our team size. Logs are now in Loki. Dashboards are in Grafana. Alerts are in Grafana. PromQL and LogQL are the query languages. The agent should not need this; it is for human onboarding.

## Old metrics stack (Prometheus self-hosted, deprecated 2024)

We used self-hosted Prometheus for metrics until late 2024. We migrated to managed Grafana Mimir at the same time as the logging migration. Metric names did not change. Recording rules are in `infra/grafana/recording-rules/`. The agent should not need this.

## Old job runner (SQS + custom worker, deprecated 2023)

We used SQS with a custom Python worker until 2023. We migrated to Celery + Redis because the custom worker was undocumented and only Carlos understood it. After Carlos left, we had three production incidents in two months that all traced back to the custom worker. We migrated within a quarter. The old worker code is in `legacy/old_worker/`. Do not reference it. Do not delete it.

## Vendor doc copy-paste: PEP 8 highlights

From PEP 8, copied here so the agent does not need to fetch it:

> Indentation: Use 4 spaces per indentation level. Continuation lines should align wrapped elements either vertically using Python's implicit line joining inside parentheses, brackets and braces, or using a hanging indent.

> Maximum line length: Limit all lines to a maximum of 79 characters. (We override this to 100; see Line length above.)

> Imports: Imports should usually be on separate lines. Imports are always put at the top of the file, just after any module comments and docstrings, and before module globals and constants.

> String quotes: In Python, single-quoted strings and double-quoted strings are the same. PEP 8 does not make a recommendation. (We use double quotes; see the Style section we never wrote.)

> Whitespace: Avoid extraneous whitespace. Two blank lines between top-level functions and class definitions. One blank line between method definitions inside a class.

> Naming conventions: Class names should normally use the CapWords convention. Function names should be lowercase, with words separated by underscores. Constants are usually written in all capital letters with underscores separating words.

The agent already knows PEP 8. This section is here because Bob added it during a phase where he didn't trust the agent to know basic Python style. He no longer doubts this. The section remains.

## Vendor doc copy-paste: TypeScript handbook on narrowing

From the TypeScript handbook chapter on narrowing, paraphrased:

> TypeScript follows the control flow analysis to refine types. A `typeof` check, an equality check, an `in` operator check, an `instanceof` check, or a user-defined type predicate can each narrow a union type. The `in` operator check refines based on whether a property exists on an object. A user-defined type predicate has the form `parameter is Type` and is used as the return type annotation of a function returning a boolean.

> The `never` type appears when narrowing has eliminated all possibilities from a union. Exhaustiveness checking uses `never` to verify that all cases of a union have been handled in a `switch` or `if/else` chain.

We follow these patterns. The agent already knows them. Section is here for parity with the Python copy-paste above; Bob believed in symmetry.

## Vendor doc copy-paste: FastAPI dependency injection

FastAPI dependencies are functions or callables passed to path operations via `Depends()`. Dependencies can themselves have dependencies, forming a tree resolved per-request. Dependencies returning generators with `yield` allow setup/teardown around the request (database sessions, transactions). Dependencies are cached per-request by default.

We use this for: database sessions, the current authenticated user, request-scoped logging context, feature-flag evaluation, and tenant resolution. Do not write your own dependency-injection framework. We have one. It is FastAPI's. Use it.

## Duplicate rule statement: indentation (also see Indentation above)

Python: 4 spaces. TypeScript: 2 spaces. JSON: 2 spaces. YAML: 2 spaces. Shell: 4 spaces. Makefiles: tabs. This is also in the Indentation section. It is also in `.editorconfig`. It is also in the Prettier and Ruff configs. It is also in the VS Code settings. It is also in the pre-commit hooks. It is, in total, written down in seven places. This is excessive. Sarah noted this in the 2025 retro. Nothing has been done about it.

## Duplicate rule statement: never push to main (also see Branching above and Security above)

Never push to `main`. Open a PR from `staging`. We have branch protection on `main` server-side. We also have a pre-push hook that checks the current branch. We also have CI that fails on any direct push to `main` (via a workflow that detects pushes by people who are not the GitHub Actions bot). We have, in total, three layers of protection against pushing to `main` plus a written rule in this document plus a written rule in `CONTRIBUTING.md` plus a written rule in the team handbook. None of this has prevented Bob from accidentally pushing to `main` exactly once in 2024. He used `git push --force` to undo it; we then added a fourth layer of protection that prevents force pushes to `main`. The fifth layer is "do not give Bob a fast keyboard".

## Duplicate rule statement: never mock the database (also see Testing above)

Never mock the database in integration tests. We learned this in November 2024. The reason is documented in `docs/adr/0014-auth-rewrite.md`. It is restated in this file in three places (this one, the Testing section, and the Note from Sarah Q4 below). It is restated in `CONTRIBUTING.md`. It is restated in the test-writing runbook. It is the most-restated rule in the entire codebase. The agent should know this. Stop mocking the database.

## Aspirational rule: write tests before code (TDD)

We aspire to TDD. Some team members do this consistently (Sarah). Some do it sometimes (Priya). Some do it rarely (Bob). The agent should propose tests before implementation when asked to add a feature. If the user pushes back and says "just write the code", write the code. If the user says nothing, write the test first.

## Aspirational rule: pair-program on hard changes

We aspire to pair on changes that touch the auth module, the billing module, or any migration. In practice, this happens about half the time. The agent should not pair-program with itself; if a change is in one of these areas, the agent should flag it to the user and recommend a human reviewer before merging.

## Aspirational rule: 80% test coverage

We aim for 80% test coverage on new code. We do not enforce this in CI. We measure it in CI and post it as a PR comment. Coverage on the codebase as a whole is currently around 64%. The agent should not chase coverage at the expense of useful tests; "test the behavior, not the line".

## Aspirational rule: keep PRs under 400 lines

We aspire to PRs under 400 lines of changed code. Most of our PRs are under 400. Some are not. The big migrations (Vite, Vitest, Auth0→Keycloak) were each thousands of lines. The agent should propose splitting a large change into a series of PRs when feasible.

## Aspirational rule: review PRs within 24 hours

We aspire to review each other's PRs within 24 business hours. This happens. Mostly. There is currently a PR from Marcus from 2024-09-12 that has never been reviewed. It is too late now.

## Aspirational rule: keep AGENTS.md under 200 lines

This file. Yes. We know.

## Postmortem: November 2024 auth incident (full text)

**Summary:** A session-token rotation bug allowed revoked tokens to remain valid for up to 90 seconds after rotation. The bug was introduced in PR #4421 (Carlos, 2024-10-30) and was masked in tests by a mocked database that did not enforce row-level updates. The bug was discovered in production on 2024-11-08 by a customer-support escalation and confirmed by an internal security review on 2024-11-09. We rotated all session tokens for ~3,200 affected customers and forced reauthentication on 2024-11-09 at 18:43 UTC. Customer impact: ~3,200 forced reauths, no confirmed token misuse, no data exfiltration detected. Internal impact: two engineers worked through the weekend.

**Timeline:**

- 2024-10-30 14:22 UTC: PR #4421 merged. CI green. The integration tests for session rotation used `MockSession.update()` which did not actually persist the change.
- 2024-11-08 09:14 UTC: customer support escalation: "I logged out but my old session is still active in another tab".
- 2024-11-08 11:30 UTC: triage assigns to Sarah. Initial hypothesis: client-side cache bug.
- 2024-11-08 14:00 UTC: Sarah reproduces in staging. Hypothesis updated: server-side bug.
- 2024-11-08 17:42 UTC: Sarah identifies the mock in `tests/integration/test_auth.py:312`. Reverts PR #4421 in staging. Bug gone.
- 2024-11-08 19:03 UTC: paged Bob. Decision to roll back in production made.
- 2024-11-08 22:11 UTC: rollback deployed.
- 2024-11-09 11:00 UTC: incident review meeting. Decision to force token rotation made.
- 2024-11-09 18:43 UTC: token rotation executed. Customers force-reauthenticated.
- 2024-11-09 23:00 UTC: incident closed.

**Root cause:** The mock did not enforce write semantics. A real database update would have failed because of a unique constraint we had added two months earlier and forgotten about. The constraint was in the migration but the mock did not reproduce it.

**Action items:**

1. Add a lint rule that flags `MockSession` usage in `tests/integration/`. (Done, 2024-11-15.)
2. Reorganize integration tests to all use the ephemeral-Postgres fixture. (In progress, 2025-Q1. Status as of 2025-Q4: ~70% migrated.)
3. Add a "tests are not the spec" subsection to `CONTRIBUTING.md`. (Done, 2024-11-12.)
4. Update AGENTS.md to forbid mocking the database. (Done, 2024-11-12. This is why it appears three times.)
5. Quarterly auth-module audit. (Not done. Has not happened. Sarah keeps meaning to schedule it.)
6. Move auth-related integration tests to a separate CI job that always runs against real Postgres. (Done, 2025-01-08.)
7. Document the session-rotation flow with a sequence diagram. (Not done. Probably should be done. No one has time.)

**Lessons:**

- Mocks lie.
- Constraints in migrations need test coverage that exercises the constraint, not the assumption that the constraint will hold.
- Tests passing is not the same as the system working.

The full postmortem is in `docs/incidents/2024-11-08-auth.md`. This summary is here because the agent often does not read incident docs unless explicitly pointed at them, and the takeaway "do not mock the database" is load-bearing for this project.

## Postmortem: 2024-08-19 deploy outage

**Summary:** A bad migration (PR #4198, Bob) locked the `customers` table for ~14 minutes during a backfill on a 50M-row table. Customer-facing reads queued up. ~3% of requests timed out during the window. We learned to do online migrations with `pt-online-schema-change` for any table over 10M rows.

**Action item:** add a CI check that flags any migration touching tables with row-count over 10M. (Not done. Bob keeps meaning to.)

## Postmortem: 2024-04-02 Slack outage (not our fault)

**Summary:** Slack went down. We could not coordinate. We learned to also have a backup channel (we set up a Discord server). The Discord server has been used exactly zero times. We will lose the password to the Discord server before we ever use it.

**Action item:** none.

## Postmortem: 2023-12-01 Postgres major version upgrade

**Summary:** We upgraded from Postgres 14 to Postgres 16. The upgrade went smoothly because Priya wrote a thorough rehearsal plan. The lesson: rehearsal plans work.

## Internal jargon glossary

- **Bob-fix:** a fix that works but everyone is afraid to refactor.
- **Sarah-PR:** a PR with a long, well-formatted description, three reviewers tagged, and a runbook update.
- **Carlos-commit:** a commit with no message body that touches three modules and breaks one of them.
- **Priya-test:** a test that is so thorough it exercises edge cases the implementation did not consider, leading to either a better implementation or a heated argument.
- **The auth incident:** see Postmortem above. When anyone says "the auth incident" without qualification, this is the one.
- **The Vite migration:** the one we just did. Smooth.
- **The Webpack migration:** the one before that. Painful.
- **The Mongo rip-out:** the 2023 migration. We do not talk about it.
- **The hauntedmodule:** `auth/legacy_session.py`. Do not read it. Do not modify it. It works.
- **A Marcus-special:** a clever functional pattern in `utils/fp.ts` that nobody else writes.
- **A Carlos-tab:** a literal tab character that snuck past the linter. Bug, not feature.
- **Going Bob mode:** terse responses, no preamble, no summary, no emoji.
- **Going Sarah mode:** verbose responses, structured, with pros/cons tables.
- **The runbook:** the Notion page. Not this file.
- **The handbook:** the other Notion page. Not the runbook.
- **The wiki:** the third Notion page that nobody updates.
- **The white whale:** the auth module audit that has never happened.

The agent should know these terms because the team uses them in PR comments and they are otherwise inscrutable. Do not extend this glossary; it is already too long.

## Tips and tricks

- When Postgres feels slow, run `EXPLAIN ANALYZE` first. Do not guess.
- When the frontend feels slow, run the React DevTools profiler first. Do not guess.
- When the build feels slow, run `vite --profile` first. Do not guess.
- When tests feel slow, run `pytest --durations=10` first. Do not guess.
- When the agent feels slow, that is just how it is sometimes. Wait for it.
- When you cannot reproduce a bug, check whether you are on the same branch as the reporter. (We have spent hours on this.)
- When a CI step fails for "no reason", check whether the lockfile changed. It is almost always the lockfile.
- When a Docker build fails for "no reason", clear the layer cache. It is almost always the layer cache.
- When a test fails on CI but passes locally, check the timezone. We have hardcoded `UTC` everywhere we can; if a test breaks, suspect that we missed one place.
- When `mypy` gives a confusing error, run `mypy --show-traceback` and read the actual cause.
- When `tsc` gives a confusing error, look at the *first* error, not the last. The cascade is usually one root cause.
- When a Celery task hangs, check whether it tried to make an HTTP request to a service that is down. We do not have a default HTTP timeout in the worker. We should. We have not added one. Sarah keeps meaning to.
- When `pytest -x` is slow to fail, it is probably the database fixture. Add `--no-cov` to skip coverage instrumentation.
- When the agent proposes a refactor that "simplifies" `auth/`, say no. Always.

These are useful. They are also distinctly the kind of thing that should be in a `docs/troubleshooting.md` file rather than in `AGENTS.md`. They are here because they accumulated organically.

## Q&A from the 2025 all-hands

**Q: Should we adopt Bun?** A: No. We just migrated to Vite. We are not migrating again this year.

**Q: Should we adopt Deno?** A: See above.

**Q: Should we adopt Rust for performance-critical paths?** A: Not yet. We have not exhausted Python optimization. Talk to Priya before proposing this in earnest.

**Q: Should we adopt GraphQL?** A: We considered it in 2022 and decided no. The decision is in `docs/adr/0006-rest-not-graphql.md`. Re-litigating requires a new ADR.

**Q: Should we adopt server components?** A: We are watching. Not yet.

**Q: Can we have an internal LLM gateway?** A: Yes, see `infra/llm-gateway/`. Use it for any agent calls from internal services.

**Q: Should we adopt Tailwind v4?** A: When it stabilizes. Not yet.

**Q: Should we adopt the new React Router v7?** A: After the next quarterly upgrade window. We are on v6.

**Q: Should we adopt pnpm?** A: We did. In Q1 2025. Did you not get the memo?

**Q: Should we adopt Yarn?** A: See above. The other direction.

**Q: Should we use Zod 4 when it stabilizes?** A: Yes, planned for Q2 2026.

These are dated. They will stop being true. The agent should not rely on this section for current technology decisions; it should ask the user.

## Onboarding checklist (also in the team handbook)

New engineers should:

1. Get GitHub access and join the `fleet-engineering` team.
2. Get Slack access and join `#eng`, `#ci-firehose`, `#deploys`, `#oncall`.
3. Get a paid GitHub Copilot seat.
4. Install Copilot CLI and run through the warmup exercises.
5. Clone the monorepo and run `make bootstrap`.
6. Pair with someone for the first PR.
7. Read the runbook.
8. Read this file.
9. Read `CONTRIBUTING.md`.
10. Read `docs/adr/` from oldest to newest.
11. Skip `docs/adr/0006-rest-not-graphql.md`; it is long and the conclusion is in step 9.
12. Take the on-call rotation shadow shift.
13. Take the on-call rotation primary shift.
14. Promote yourself from "new" to "actually new" status by your first incident.

This belongs in the team handbook. It is here because the handbook does not exist yet. The handbook has been "in progress" since 2023.

## Retro action items, never completed

From the 2024-Q1 retro:

- [ ] Add a CI check for migration row-count thresholds (see postmortem above).
- [ ] Document the session-rotation flow with a sequence diagram (see postmortem above).
- [ ] Schedule a quarterly auth-module audit (see postmortem above).
- [ ] Reorganize integration tests to all use ephemeral Postgres (~70% done).

From the 2024-Q3 retro:

- [ ] Move ESLint config to flat-config format (done in Q4).
- [ ] Add a deny rule for committing `.pyc` files (Git already ignores them; deemed unnecessary).
- [ ] Set up Renovate for dependency updates (we use Dependabot; deemed equivalent).
- [ ] Write the team handbook (see Onboarding above).

From the 2025-Q1 retro:

- [ ] Document why we use Unleash and not LaunchDarkly (in this file, see "Old feature-flag system").
- [ ] Add a "tests are not the spec" subsection to CONTRIBUTING.md (already done in November 2024 but not announced).
- [ ] Audit AGENTS.md for duplication and length (filed; not started).

From the 2025-Q3 retro:

- [ ] Stop adding to AGENTS.md (LOL).

The agent should ignore unchecked retro action items unless the user is actively working on one.

## Old roadmap (Q3 2024)

- Migrate from Webpack to Vite (done Q1 2025)
- Migrate from Jest to Vitest (done Q4 2024)
- Migrate from CircleCI to GitHub Actions (done Q1 2024)
- Migrate from Auth0 to Keycloak (done Q3 2024)
- Migrate from MongoDB to Postgres (done 2023; should not be on a 2024 roadmap; was carried over from a stale doc)
- Migrate from LaunchDarkly to Unleash (done Q1 2025)
- Add SSO support (done Q4 2024)
- Add audit logging to all admin actions (done Q1 2025)
- Add SOC 2 readiness program (in progress; led by a separate compliance contractor)
- Add data residency support for EU customers (planned Q2 2026)

This roadmap is dated. It is here for historical reference. The current roadmap is in Notion. The agent should not propose work based on this list.

## Architecture overview (high-level, also see docs/architecture/)

The system is a multi-tenant SaaS for fleet operations. Major components:

- **Web frontend** (React + Vite + Tailwind + Zustand + TanStack Query). Single SPA. Hosted on CloudFront.
- **API gateway** (FastAPI). Handles auth, rate limiting, request routing. Talks to backend services over HTTP.
- **Auth service** (FastAPI + Keycloak). Session management, SSO, MFA.
- **Customer service** (FastAPI + Postgres). CRUD for customer records, contracts, billing config.
- **Vehicle service** (FastAPI + Postgres). CRUD for vehicles, telematics ingestion, maintenance records.
- **Routing service** (FastAPI + Postgres + a custom OR-Tools-based optimizer). Computes routes given a set of stops and constraints.
- **Notification service** (FastAPI + Celery + Redis + SES + SNS + Twilio). Sends transactional notifications across channels.
- **Reporting service** (FastAPI + Postgres + a read replica). Generates customer-facing reports.
- **Admin tool** (separate React SPA). Internal use only. Hosted on a separate CloudFront distribution behind SSO.
- **Background workers** (Celery). Jobs across all services use the same Redis broker.
- **Observability** (Loki + Grafana Mimir + Grafana). Self-hosted in our cluster.

This is also in `docs/architecture/overview.md`. The agent should reference that document directly when it needs architectural context. This summary is here because Bob.

## Service boundaries and ownership

| Service | Owner | Repo | Notes |
|---|---|---|---|
| Web frontend | Sarah | this repo | `apps/web/` |
| API gateway | Bob | this repo | `services/gateway/` |
| Auth | Bob | this repo | `services/auth/` |
| Customer | Priya | this repo | `services/customer/` |
| Vehicle | Priya | this repo | `services/vehicle/` |
| Routing | Sarah | this repo | `services/routing/` |
| Notification | rotates | this repo | `services/notification/` |
| Reporting | Priya | this repo | `services/reporting/` |
| Admin tool | Sarah | this repo | `apps/admin/` |

Ownership is "primary point of contact for questions and reviews", not "only person allowed to commit". Anyone can commit anywhere; PRs touching a service get auto-assigned to its owner via CODEOWNERS. The agent does not need to know ownership for code generation but it is useful context for "who would review this".

## Database conventions

- Primary keys: `id` (UUID v4) for new tables. Some legacy tables use serial integers; do not change.
- Foreign keys: `<table>_id`. Always indexed.
- Timestamps: `created_at` and `updated_at` (UTC). `updated_at` updated by trigger, not application.
- Soft deletes: `deleted_at` (nullable timestamp). Filter `WHERE deleted_at IS NULL` in queries.
- Tenant isolation: every tenant-scoped table has `tenant_id` (UUID). Row-level security is enforced via Postgres RLS plus application-level checks (defense in depth).
- Migrations: Alembic. One migration per logical change. Never edit a deployed migration. (Already in the Database migrations section above.)
- Naming: tables plural snake_case (`customers`, not `customer`). Columns snake_case. Indexes named `<table>_<col(s)>_idx`. Constraints named `<table>_<col(s)>_<type>` (e.g., `customers_email_unique`).

This is also in `docs/database-conventions.md`. (Sensing a pattern? Yes. Bob duplicates everything.)

## API versioning

We use URL-based versioning: `/api/v1/`, `/api/v2/`. Major version bumps for breaking changes. We have not yet had a major version bump in production; everything is `v1`. When we do v2, the deprecation policy is: 6 months overlap, deprecation header (`Sunset:`) on every v1 response during overlap, sunset email to API consumers at 6 months, 3 months, and 1 month before cutoff.

## Caching

We use Redis for cache. Key naming: `<service>:<resource>:<id>` (e.g., `customer:profile:abc123`). TTL: explicit on every `set`, no defaults. Invalidation on write, plus a TTL safety net. Do not cache PII without an explicit per-key encryption layer.

## Internal CLI tools

We have a `bin/` directory with internal CLI tools. Notable ones:

- `bin/seed-dev-data` — seeds the local dev database with realistic fixtures.
- `bin/reset-db` — drops and recreates the local dev database.
- `bin/replay-prod-event` — replays a single production event into staging for debugging.
- `bin/audit-deps` — runs `pip-audit` and `pnpm audit` and emits a single combined report.
- `bin/check-migrations` — runs all migrations against an empty database and asserts they apply cleanly.
- `bin/perf-bench` — runs the standard load test against staging.
- `bin/old-celery-monitor` — *removed in Q1 2025; do not reference; mention here for the agent's benefit because the agent occasionally suggests using it.*
- `bin/old-mongo-export` — *removed in 2023; same as above.*

## Linting overrides for legacy code

`legacy/` is excluded from most linters. The exception is the `S` (security) ruleset in Ruff, which still applies. Do not add new code to `legacy/`. Do not move files into `legacy/` to avoid lint errors. If a legacy file needs a fix, fix it in place; if it needs more than a fix, propose moving it out of legacy.

## Performance budgets

- Frontend bundle: 250KB gzipped per route, enforced in CI.
- API response time: p95 < 200ms for read endpoints, p95 < 500ms for write endpoints. Measured via Grafana dashboards.
- Database query time: p95 < 100ms per query. Slow query log threshold is 100ms.
- CI pipeline duration: under 12 minutes end-to-end. We currently run at ~9 minutes.
- Local test suite: under 90 seconds for unit tests, under 8 minutes for integration tests.

These targets exist. We do not religiously enforce them. They are aspirational in the sense that we treat regressions seriously but do not have hard CI gates.

## Accessibility

We aim for WCAG 2.1 AA on the customer-facing web app. Internal admin tools are not held to the same standard (compliance team agreed). We use `axe-core` in CI for automated checks. Manual audits happen quarterly.

## Internationalisation

The customer-facing web app supports English and French. Strings live in `apps/web/src/i18n/`. Use the `useTranslation()` hook. Do not hardcode user-facing strings. The admin tool is English only.

## Email templates

Transactional emails live in `services/notification/templates/`. Use Mjml for layout. Plain-text fallback is generated automatically. Test rendering with `bin/render-email`.

## Push notifications

We send push notifications via Firebase Cloud Messaging. Payloads must be under 4KB. Click actions must deep-link to the app via the universal link scheme.

## SMS

We send SMS via Twilio. SMS is opt-in only. Body must be under 160 characters or it splits into multiple messages and we get charged twice.

## A note about the notification service

The notification service is the most-modified service in the codebase. It is also the most-broken. Every quarter we say we will rewrite it. Every quarter we do not. The agent should be especially careful when touching notification-service code.

## Things the agent should not do

- Suggest using a Mongo-style document model in Postgres (`JSONB` columns are okay where appropriate but do not propose JSONB-everywhere designs).
- Suggest moving from Celery to a different job runner. We are happy with Celery.
- Suggest moving from Postgres to a different database. We are happy with Postgres.
- Suggest moving from FastAPI to a different framework. We are happy with FastAPI.
- Suggest moving from React to a different framework. We are happy with React.
- Suggest moving from Vite to a different bundler. We just got here.
- Suggest moving from Vitest to a different test runner. We just got here.
- Suggest moving from pnpm to a different package manager. We just got here.
- Suggest adopting microservices for any new domain. We are happy with our service boundaries.
- Suggest splitting an existing service. Talk to the owner first.
- Suggest a rewrite. Of anything. Without explicit approval.
- Suggest using `dataclasses` instead of `pydantic` (also see Note from Bob, 2025-Q3).
- Suggest catching `Exception` (also see Note from Sarah, 2025-Q4).
- Suggest using `print()` (also see Logging).
- Suggest using `console.log()` in production code (also see Logging).
- Suggest using `var` in TypeScript (also see Personal preferences (Carlos)).
- Suggest using tabs (also see Indentation).

This list is exhaustive in the sense that it covers everything we have explicitly agreed not to do. It is not exhaustive in the sense that the agent is allowed to do anything not on this list; common sense applies.

## Things the agent should do, frequently

- Ask before touching `auth/`.
- Ask before touching `infra/`.
- Ask before touching `migrations/`.
- Ask before touching `.github/workflows/`.
- Read the migration's down-revision before suggesting a new migration.
- Run the linter mentally before proposing code (the lint hook will catch real issues but it is faster to be right the first time).
- Reference ADRs when proposing architectural changes.
- Propose tests alongside implementation, even if not asked.
- Use the `@fleet/ui` component library before reaching for raw HTML elements.
- Use the existing logging context fields rather than inventing new ones.
- Match the surrounding code style (this is in `CONTRIBUTING.md`, but worth restating).

## Things to remember about specific files

- `auth/legacy_session.py`: do not touch. Cursed. (Already mentioned. Mentioned again because important.)
- `services/notification/dispatcher.py`: extremely modified. Read carefully before changing. Tests are good but slow.
- `apps/web/src/components/forms/wrapper.tsx`: nobody understands it. Works. Leave alone. (Mentioned above. Also here.)
- `services/routing/optimizer.py`: Sarah's domain. Talk to her first.
- `services/customer/billing.py`: regulated. Compliance review required for any change.
- `services/admin/impersonation.py`: security-sensitive. Two-reviewer rule. Audit log on every change.
- `legacy/old_worker/`: do not touch. Do not delete. Wait until we are sure no one needs it. We have been "sure" for two years. We have not deleted it.
- `legacy/webpack.config.js.archived`: same.
- `legacy/logging_old.py`: same.
- `experimental/go-gateway-archive/`: same. Also: the only Go in the repo. Do not start writing new Go.

## File patterns the agent should ignore

- `*.bak`, `*.archived`, `*.old`: archives, do not modify.
- `.DS_Store`, `Thumbs.db`: OS junk; in `.gitignore` already.
- `__pycache__/`, `*.pyc`: Python cache; in `.gitignore`.
- `node_modules/`: in `.gitignore`.
- `.venv/`, `venv/`: in `.gitignore`.
- `.env`, `.env.*`: secrets; never commit; never read.
- `*.log`: ephemeral; in `.gitignore`.
- `.pytest_cache/`, `.mypy_cache/`, `.ruff_cache/`: tool caches; in `.gitignore`.
- `.next/`, `dist/`, `build/`: build output; in `.gitignore`.
- `coverage/`, `.coverage`, `htmlcov/`: coverage output; in `.gitignore`.
- `.idea/`, `.vscode/` (mostly): editor config; partially committed (workspace settings yes, personal settings no).

This is also in `.gitignore`. The agent should respect `.gitignore` automatically. This list is here because Bob.

## Things that are technically true but unhelpful

- "TypeScript is a superset of JavaScript." Yes. Stop saying this in PR descriptions.
- "Postgres is ACID-compliant." Yes. Stop using this as a reason for design choices that have nothing to do with ACID properties.
- "We use Tailwind." Yes. Stop justifying every utility class by saying we use Tailwind.
- "It's an MVC pattern." We do not use MVC. We use whatever shape FastAPI naturally produces. Stop calling things MVC.
- "It's idempotent." Only say this if you have actually verified idempotency, including under concurrent calls.

## Things we have learned the hard way

- Migrations on big tables: use `pt-online-schema-change` or its Postgres equivalent. (See postmortem above.)
- Mocks: see "do not mock the database".
- Auth: do not roll your own. We use Keycloak.
- Crypto: do not roll your own. Use the standard library.
- Time zones: hardcode UTC everywhere; convert to local time only at the display layer.
- Floats for money: never. Use `Decimal` in Python and `bignumber.js` in TypeScript.
- HTTP timeouts: always set them. We have not always followed this. We are working on it.
- DNS: it is always DNS. (Industry-standard joke; also true for us.)
- Caching: invalidation is hard. Set short TTLs and revisit.

## Things that should be in this file but are not

- A clear "how to set up your local environment" section. This is in `README.md`. Sometimes.
- A clear "how to run the tests" section. This is in `CONTRIBUTING.md`.
- A clear "how to deploy" section. This is in the runbook.
- A clear list of what each service depends on. This is in `docs/architecture/dependency-graph.md`.
- A clear escalation path for incidents. This is in the on-call runbook.

We do not need to add these here. They exist elsewhere. We list the elsewhere here.

## Notes from Marcus (departed contractor)

Marcus left two notes when he wrapped up his contract:

1. "The functional patterns in `utils/fp.ts` are designed for composition. If you write a `for` loop where one of these would compose, please consider the composition first. The pattern matters more than my specific implementations."

2. "I am sorry about the date library. I know it is a third option after the team had already standardized on date-fns. I needed Temporal-style semantics and date-fns did not provide them at the time. The third library can probably be removed once Temporal lands in browsers; the conversions are mechanical."

Both notes are useful. Both should probably be in the relevant module READMEs rather than here. Neither has been moved.

## Decisions about the agent itself

- The agent has a paid Copilot CLI seat per engineer.
- The agent should use `claude-sonnet-4-5` by default.
- The agent should not use `gpt-5.3-codex` by default; switch to it explicitly when needed.
- The agent should respect `AGENTS.md` (this file). The agent does. Mostly.
- The agent should not read `.env` files. (Also see Security.)
- The agent should not push to `main`. (Also see Branching, Security.)
- The agent should propose plans before writing code for non-trivial changes. (Use Plan Mode.)
- The agent should not invent file paths. If unsure, ask or use `find`.
- The agent should not invent API methods. If unsure, ask or read the docs.
- The agent should not invent dependencies. If unsure, check `package.json` / `requirements.txt`.

## Things people on the team disagree about, internally

- Whether to use `match/case` in Python (Bob: no, Sarah: yes, Priya: depends on the case count).
- Whether to use `async`/`await` in routing-service code (Sarah: it adds complexity, Priya: it makes the optimizer responsive).
- Whether to write integration tests for read-only endpoints (Bob: usually no, Sarah: usually yes).
- Whether to use barrel files in TypeScript (Sarah: no, they hurt tree-shaking; Priya: yes, they improve readability).
- Whether to use named exports or default exports for React components (the team has not converged).

The agent should not take sides. The agent should follow the surrounding code in the file being edited. If unsure, ask.

## Things that used to be in this file and were removed

- A long section about Webpack (removed Q1 2025 after Vite migration).
- A long section about Jest (removed Q1 2025 after Vitest migration).
- A long section about MongoDB (removed 2023 after Postgres migration).
- A section about a now-defunct messaging-queue evaluation.
- A section about a now-defunct caching strategy.
- Personal preferences from Dev (an engineer who left in 2022).
- Personal preferences from Aisha (an engineer who left in 2023).
- The original 2024 deploy-runbook excerpt that is now in the runbook proper.
- A "rules for working with the data team" section that became the data-team handbook.

The fact that we list what we removed is itself a sign that this file has too much sediment.

## ADR summaries (short form; full text in docs/adr/)

- **ADR-0001 (2019):** Choose Python over Ruby for backend. Decided Python for hiring market and library ecosystem. Still valid.
- **ADR-0002 (2019):** Choose Postgres as primary store. Decided over MySQL for `JSONB`, `RANGE` types, and richer constraint expressivity. Still valid.
- **ADR-0003 (2020):** Adopt React for frontend. Decided over Vue and Svelte for hiring market. Still valid.
- **ADR-0004 (2020):** Use SQLAlchemy + Alembic for ORM and migrations. Still valid.
- **ADR-0005 (2021):** Adopt TypeScript for the frontend (was JavaScript). Still valid.
- **ADR-0006 (2022):** REST not GraphQL. Decided REST for client diversity, caching simplicity, and team familiarity. Re-litigation requires a new ADR; do not re-open in PR comments.
- **ADR-0007 (2022):** Adopt FastAPI (was Flask). Decided for type integration with pydantic and ASGI support. Still valid.
- **ADR-0008 (2023):** Migrate routing service from MongoDB to Postgres. Done.
- **ADR-0009 (2023):** Adopt Celery + Redis (was custom SQS worker). Done.
- **ADR-0010 (2023):** Upgrade Postgres 14 → 16. Done.
- **ADR-0011 (2024):** Adopt GitHub Actions (was CircleCI). Done.
- **ADR-0012 (2024):** Adopt Vitest (was Jest). Done.
- **ADR-0013 (2024):** Adopt Keycloak (was Auth0). Done.
- **ADR-0014 (2024):** Auth rewrite after the November incident. Done.
- **ADR-0015 (2025):** Adopt Vite (was Webpack). Done.
- **ADR-0016 (2025):** Adopt Unleash (was LaunchDarkly). Done.
- **ADR-0017 (2025):** Adopt pnpm (was npm). Done.
- **ADR-0018 (2025):** Self-host observability (was Datadog trial). Done.
- **ADR-0019 (2025):** Standardise on `structlog`/`pino`. Done.
- **ADR-0020 (2025):** Adopt Tailwind v3 (was a custom CSS-in-JS layer). Done.

The ADRs themselves are short (Nygard format: context, decision, status, consequences). The agent can read them directly. This summary is a convenience that has gradually become less convenient than the ADRs themselves.

## Slack channel etiquette

- `#eng`: high-level engineering announcements. Low traffic. Read it.
- `#ci-firehose`: every CI failure. High traffic. Mute it; check on demand.
- `#deploys`: every deploy notification. Medium traffic. Glance at it.
- `#oncall`: incident channel. High signal during incidents, silent otherwise.
- `#oncall-handoff`: weekly handoff thread. Read your shift's handoff.
- `#random`: not work.
- `#cats`: not work, but priority.
- `#design`: cross-team design discussion. Read it if you care about cross-team design.
- `#frontend`: frontend-specific. Read if you do frontend work.
- `#backend`: backend-specific. Read if you do backend work.
- `#data`: the data team. Cross-post anything that affects them.
- `#sre`: the SRE/platform team. Cross-post anything infra-adjacent.
- `#security`: read-only for most engineers; post here only with a security finding.
- `#help`: ask anything. Anyone may answer. Do not be shy.
- `#announcements`: company-wide. Mute outside work hours.

The agent does not have Slack access and does not need to know this. This section is for human onboarding and should be in the team handbook.

## Code review etiquette

- Review within one business day, ideally same day.
- "LGTM" without comments is fine on small PRs from trusted reviewers.
- For larger PRs, leave at least one substantive comment, even if it is "I read this and it looks correct because X".
- Use "suggestion" blocks for small changes you would otherwise nit-pick.
- Use "blocking" tag for changes that must happen before merge.
- Use "non-blocking" tag for things you would prefer but will accept either way.
- Use "discussion" tag for things you want to chat about but are not asking the author to change.
- Approve or request changes; do not leave reviews in limbo.
- If you do not have time to review, say so and suggest someone else.
- Be kind. We are all junior at something.

The agent should follow these conventions when proposing reviews of human PRs. (Yes, the agent reviews human PRs. We are still figuring out the etiquette for that.)

## Meeting cadence

- Standup: Mon/Wed/Fri, 15 min, async on Tue/Thu.
- Sprint planning: every other Monday, 60 min.
- Sprint review: every other Friday, 60 min.
- Retro: every other Friday after sprint review, 45 min.
- Eng all-hands: monthly, 60 min, recorded.
- Architecture review: ad-hoc, called by anyone proposing a substantial change.
- Incident review: within 5 business days of an incident, 60 min.
- Quarterly planning: end of quarter, half-day, off-site if budget allows.
- 1:1s with manager: weekly, 30 min.
- Skip-levels: quarterly, 30 min.
- "Office hours" with the staff engineer (Sarah): Fridays 14:00-15:00 UTC, optional.

The agent does not attend meetings. This is here because Bob.

## Things we tried and rejected

- **Microservices for everything (2021):** we tried splitting the monolith into ~12 services. Operations cost ballooned. We consolidated back to the current ~9-service shape. Lesson: services should align with domain boundaries, not arbitrary code-organization preferences.
- **Server-side rendering (2022):** we tried Next.js for a customer-facing dashboard. The hydration cost was higher than the render-time savings for our particular use case (heavy interactivity, infrequent SEO traffic). Reverted to SPA.
- **Event sourcing (2022):** we tried event sourcing for the routing service. Snapshot management got complex. Audit logging gave us most of the value at a fraction of the complexity. Removed.
- **CQRS (2022):** see above; came as a package with event sourcing. Removed.
- **Serverless for background jobs (2022):** we tried AWS Lambda for a few job types. Cold start was a problem for job types that ran rarely but with low-latency requirements. Moved to Celery.
- **Kubernetes for everything (2023):** we tried Kubernetes for everything including small internal tools. Operational cost too high for the team size. Now we use ECS for most services, Kubernetes only for the routing optimizer (which benefits from autoscaling).
- **Custom auth (2019):** we briefly rolled our own session management before adopting Auth0 in 2019. Predictable result. Moved to Auth0, then later to Keycloak.
- **NoSQL document store for routing (2020-2023):** see ADR-0008.
- **GraphQL federation (2022):** discussed; never built. See ADR-0006.
- **Dependency injection framework (2021):** we tried `dependency-injector` (Python) and built a custom one. Both added more cognitive overhead than they removed. Use FastAPI's built-in `Depends` instead.
- **Domain-driven design as a framework (2021):** we read the book. We tried to apply the patterns wholesale. Some patterns helped (bounded contexts, ubiquitous language). Others did not (aggregate roots, repositories on top of an ORM). We took what helped.
- **Hexagonal architecture (2021):** see above.
- **Clean architecture (2021):** see above.
- **A monorepo build system (Bazel, 2023):** evaluated. The setup cost outweighed the build-speed benefit at our scale. Stayed with `pnpm` workspaces and `make` for cross-language coordination.
- **Yarn (2024):** evaluated as part of the package-manager review. Adopted pnpm instead.
- **Turborepo (2024):** evaluated. Modest speedup; not worth a switch from `pnpm` workspaces alone.

This list is long because we have tried many things. Most of them were valid experiments. Most of them did not survive contact with our specific team and traffic shape. The agent should not propose re-trying anything on this list without a strong reason.

## Per-environment configuration tables

| Setting | dev | staging | prod |
|---|---|---|---|
| `LOG_LEVEL` | DEBUG | INFO | INFO |
| `DB_POOL_SIZE` | 5 | 20 | 50 |
| `REDIS_TIMEOUT_MS` | 5000 | 2000 | 1000 |
| `CELERY_WORKER_CONCURRENCY` | 2 | 8 | 16 |
| `ENABLE_TELEMETRY` | false | true | true |
| `ENABLE_DEBUG_TOOLBAR` | true | false | false |
| `RATE_LIMIT_PER_MIN` | 1000 | 200 | 100 |
| `SESSION_TTL_HOURS` | 24 | 12 | 8 |
| `JWT_ALGORITHM` | RS256 | RS256 | RS256 |
| `MAX_REQUEST_BODY_BYTES` | 10485760 | 10485760 | 1048576 |
| `CORS_ORIGINS` | `*` | `*.staging.example.com` | `*.example.com` |
| `FEATURE_FLAG_REFRESH_INTERVAL_S` | 5 | 30 | 60 |
| `EMAIL_PROVIDER` | console | ses-sandbox | ses |
| `SMS_PROVIDER` | console | twilio-trial | twilio |
| `PUSH_PROVIDER` | console | fcm | fcm |
| `OBJECT_STORE_BUCKET` | `dev-fleet` | `staging-fleet` | `prod-fleet` |
| `BACKUP_RETENTION_DAYS` | 1 | 7 | 90 |
| `AUDIT_LOG_RETENTION_DAYS` | 7 | 30 | 365 |
| `METRICS_SCRAPE_INTERVAL_S` | 60 | 30 | 15 |

These values live in `.env.dev`, `.env.staging`, `.env.prod` and in the corresponding parameter store entries. This table is a reference and may drift; if it disagrees with the parameter store, the parameter store wins.

## On-call rotation

- We have a single on-call rotation across the engineering team.
- Shifts are one week, Mon 09:00 UTC to the following Mon 09:00 UTC.
- Schedule lives in PagerDuty.
- Primary on-call carries the pager. Secondary is a backup who can be paged if primary does not respond within 10 minutes.
- Rotation excludes engineers in their first 90 days.
- Rotation excludes engineers on PTO.
- Coverage during major holidays is volunteered; we pay a holiday premium per the policy in the team handbook.
- Handoff happens in `#oncall-handoff` on Monday morning. The outgoing primary writes the handoff thread.
- Severity levels: SEV1 (customer-facing outage), SEV2 (degraded performance), SEV3 (internal-only outage), SEV4 (known issue, not actively impacting).
- SEV1 → page immediately, war room within 15 min.
- SEV2 → page during business hours, ack within 30 min.
- SEV3 → ticket; address next business day.
- SEV4 → ticket; address in normal sprint planning.

The agent does not participate in on-call. It can read incident history when triaging similar issues but should not page humans.

## Holiday and PTO coverage

- We honor public holidays in the engineer's home country.
- PTO requests go through the HR system; coverage is arranged in `#eng-pto`.
- During PTO, code review responsibilities transfer to the next person in the rotation per the CODEOWNERS group.
- During PTO, on-call shifts swap in PagerDuty.
- Long PTO (>1 week) requires arranging coverage at least 2 weeks in advance.

This belongs in the HR handbook. It is here because the HR handbook is also a Notion page that nobody updates.

## Third-party vendors and SLAs

| Vendor | Service | SLA | Escalation |
|---|---|---|---|
| AWS | infrastructure | 99.99% (region-level) | TAM Slack channel |
| GitHub | source/CI | 99.9% | support email |
| Cloudflare | DNS/CDN | 100% | TAM Slack |
| PagerDuty | alerting | 99.99% | support |
| Slack | communication | 99.99% | support |
| 1Password | secrets management | 99.9% | support |
| Twilio | SMS | 99.95% | TAM email |
| Firebase | push | 99.95% | support |
| AWS SES | email | 99% (per-message) | TAM Slack |
| Stripe | payments | 99.999% | TAM Slack |
| Plaid | bank linking | 99.5% | support |
| Snowflake | data warehouse | 99.9% | TAM email |
| Sentry | error reporting | 99.9% | support |

Cross-reference: `infra/vendor-contracts/` for the actual contracts. Renewal dates and SOC 2 attestations are tracked there. The agent should not make decisions about vendor changes; that is a finance + security conversation.

## Known third-party quirks

- **Stripe webhooks:** sometimes deliver out of order. Always read the source of truth via the Stripe API, do not trust webhook payload alone.
- **Twilio:** rate limits are per-account, not per-number. If we are sending bulk SMS, throttle in the application layer.
- **Plaid:** sandbox environment occasionally diverges from production behavior. Always test against sandbox before deploying, but be aware that sandbox-passing is not production-passing.
- **AWS SES:** new sender domains require a 24-hour reputation warmup. Plan for this when launching new email flows.
- **Firebase FCM:** topics with no subscribers silently drop messages. Check subscriber count before sending.
- **Sentry:** event ingestion can lag during their incidents. Trust direct logs over Sentry-derived dashboards during a Sentry incident.
- **GitHub Actions:** macOS runners are 10x cost of Linux runners. Avoid unless required (we use Linux for everything; macOS only for one Apple-platform-related test that we may eventually move to a self-hosted runner).
- **CloudFront:** invalidation propagation is not instant; budget 5-10 minutes after invalidation request.

## Old SLOs (deprecated, see Grafana for current)

We previously documented SLOs in this file. Current SLOs live in Grafana with the SLO panel set up by the SRE team. The deprecated definitions:

- API gateway: 99.9% successful response rate (5xx errors are budget burn).
- Customer service: 99.95% read availability, 99.9% write availability.
- Routing service: 99.5% job success rate (failures > 0.5% trigger alert).
- Notification service: 99% delivery rate within SLA window per channel (email 5min, SMS 1min, push 10s).

These targets may have changed. Trust Grafana.

## Documentation conventions in detail

- Top-level `README.md` is the entry point. Every contributor starts here.
- `CONTRIBUTING.md` covers dev setup, conventions, PR flow.
- `AGENTS.md` (this file) is for the agent specifically. Humans can read it but it is targeted.
- `docs/adr/` holds architecture decision records, Nygard format, numbered, immutable once accepted.
- `docs/architecture/` holds living architecture documents. Update on substantial change.
- `docs/runbooks/` holds operational runbooks. One per recurring procedure.
- `docs/incidents/` holds incident postmortems. Numbered by date.
- `docs/migrations/` holds migration guides between major versions of internal or external dependencies.
- `docs/api/` holds OpenAPI specs and rendered API documentation.
- Service-specific `README.md` lives in each `services/<name>/` directory.
- Component library docs live in `packages/ui/README.md` and Storybook.

The agent should look at `docs/` before asking the user for context that might already be documented.

## Naming conventions in detail (extends the Naming section above)

- **Modules** (Python): plural nouns for collections (`customers/`), singular nouns for single-concept modules (`auth/`).
- **Modules** (TypeScript): kebab-case directory names; index files are `index.ts`.
- **Functions:** verb phrases (`get_customer`, `validate_email`, `send_notification`).
- **Predicates:** start with `is_`, `has_`, `should_`, `can_` (`is_active`, `has_permission`).
- **Booleans:** ending with `?` is not a Python convention; use `is_active` not `active?`.
- **Constants:** UPPER_SNAKE_CASE (`MAX_RETRIES`, `DEFAULT_TIMEOUT_MS`).
- **Enums:** PascalCase enum name, UPPER_SNAKE_CASE values (`Status.PENDING`, `Status.COMPLETED`).
- **Errors:** end with `Error` (`ValidationError`, `NotFoundError`). Custom errors inherit from a project base class.
- **Tests:** named `test_<function_being_tested>_<scenario>` in Python, `<function being tested>.<scenario>` in TypeScript.
- **Fixtures:** start with `fixture_` in Python; in TypeScript test files, fixtures are objects named `<entity>Fixture`.
- **Mocks:** *do not write mocks for the database*. For other dependencies, mock objects end with `Mock` or are wrapped in a `mocked()` helper.
- **CSS classes:** Tailwind utilities; component-scoped class names are `<component>-<element>`.
- **Files:** see existing rules above; restated here only because the original section is high in the file and people forget to scroll.

## Some redundant style rules I will repeat for emphasis

- 4-space indent in Python.
- 2-space indent in TypeScript.
- 100-char line limit.
- Catch specific exceptions.
- No `print()`.
- No `console.log()` in production.
- snake_case in Python, camelCase in TypeScript.
- pydantic, not dataclasses.
- structlog, not loguru.
- pino, not winston.
- vitest, not jest.
- pnpm, not npm or yarn.
- Vite, not Webpack.
- Postgres, not MongoDB.
- FastAPI, not Flask.
- Keycloak, not Auth0.
- Unleash, not LaunchDarkly.
- Loki + Mimir + Grafana, not ELK.
- Celery, not custom workers.

These are all stated elsewhere. Stating them again here in list form felt useful at the time.

## Notes from the 2024-Q4 retro that did not lead to action items

- "We should rewrite the notification service" (no action; we have said this every quarter for 2 years).
- "We should adopt Bun" (no action; see Q&A above).
- "We should hire another senior engineer" (action: posted; status: ongoing).
- "We should write the team handbook" (no action; ongoing).
- "AGENTS.md is too long" (no action; we are reading the irony).
- "The auth module is haunted" (no action; this is the third quarter we have said this without exorcising it).

## Things the agent has done that surprised us, in a good way

- Caught a SQL-injection-flavored query construction in a PR and proposed parameterization (Q3 2025).
- Noticed that an `await` was missing on an async function call in `notification/dispatcher.py` (Q1 2025).
- Suggested splitting a 600-line PR into three smaller ones, ordered by review difficulty (Q4 2024).
- Wrote a thorough PR description from a sparse prompt, including risk callouts (multiple times).
- Caught a date-parsing bug that had been in production for 8 months, while reviewing an unrelated change in the same file (Q2 2025).

These accumulated as anecdotal evidence that the agent is useful. They do not need to be in `AGENTS.md`; they belong in a "win log" somewhere. They are here because we did not have a win log when these happened.

## Things the agent has done that surprised us, in a bad way

- Confidently invented a function name from `requests` library that does not exist (`requests.get_json()`). Caught in code review.
- Mocked the database in a new integration test, contradicting the section on this. Caught by the lint rule we added after the auth incident.
- Suggested moving from Celery to RQ, ignoring the explicit "do not suggest" rule. Caught by Sarah.
- Proposed using `dataclasses` instead of pydantic, ignoring Bob's note. Caught by Bob.
- Generated a long markdown answer when "Going Bob mode" was the right register. Caught by Bob (terse) reply.
- Hallucinated an OpenAPI parameter that does not exist. Caught by the OpenAPI lint step.
- Wrote a test that passed because it asserted nothing (`assert True`). Caught by mutation testing.

These have informed updates to this file. Some of those updates are above. Some are below. Some are in this paragraph that is itself an example of redundancy.

## Where to find things (cheat sheet)

- Source: `services/`, `apps/`, `packages/`, `legacy/`, `experimental/`.
- Tests: alongside source for unit tests; `tests/integration/` and `tests/e2e/` for those.
- Migrations: `services/<name>/migrations/`.
- ADRs: `docs/adr/`.
- Architecture docs: `docs/architecture/`.
- Runbooks: `docs/runbooks/`.
- Postmortems: `docs/incidents/`.
- API specs: `docs/api/`.
- Configuration: `.env.*`, `pyproject.toml`, `package.json`, `pnpm-workspace.yaml`, `tsconfig.json`, `vite.config.ts`, `pyrightconfig.json`, `eslint.config.js`, `.prettierrc.json`, `.editorconfig`, `.pre-commit-config.yaml`.
- CI: `.github/workflows/`.
- Hooks (Copilot CLI): `.github/hooks/`.
- Skills (Copilot CLI): `.github/skills/`.
- Internal CLI: `bin/`.
- Infra: `infra/` (do not edit without explicit approval).
- Vendor configs: `infra/vendor-contracts/`.

## Things that should be removed from this file in the next cleanup

- All vendor-doc copy-paste sections (PEP 8, TS handbook, FastAPI DI). The agent already knows these.
- All editor/formatter/linter config duplications. They are in their respective config files.
- Carlos's personal preferences. Carlos is gone.
- Marcus's notes (move to module READMEs).
- The internal jargon glossary (move to the team handbook when the handbook exists).
- The Slack channel etiquette (move to the team handbook).
- The meeting cadence (move to the team handbook).
- The on-call rotation (move to the on-call runbook).
- The third-party vendor table (move to `infra/vendor-contracts/README.md`).
- All Q&A from past all-hands (these are time-bound; move to a quarterly notes file).
- The Bob-fix glossary entries that are no longer current.
- The "things the agent has done" sections (move to a separate `agent-notes.md`).

This list of things-to-remove has been in this file for two cleanups now. The next cleanup will probably also leave it here.

## A philosophy section nobody asked for

We believe in:

- Boring technology. We picked Postgres, FastAPI, React, Celery, Redis. We have not regretted any of those.
- Simple architecture. Services align with domains, not with team-organization preferences.
- Conservative dependency choices. We pin versions. We update on a cadence. We do not chase the bleeding edge.
- Honest tests. Tests should exercise the system as it actually runs. Mocks are a last resort.
- Iterative delivery. Small PRs, frequent deploys, easy rollback.
- Documentation that lives with the code. ADRs, runbooks, READMEs.
- Postmortems without blame. We focus on systems, not individuals.
- Pairing on hard things. Solo work for routine things.
- On-call as a team responsibility. No engineer is forever on call.
- Sustainable pace. We do not deploy on Fridays after 16:00 UTC unless it is a hotfix. We do not deploy the day before a long weekend.

This is a values statement. It is true. It does not need to be in `AGENTS.md`. The agent does not need values; it needs rules. But this file accumulates everything, including this.

## A short story about how this file came to be this long

Bob created the original file in early 2024. It was 47 lines. Sarah added a section. Carlos added a section. Bob added two sections. Sarah added the auth-incident note after the November incident. Bob added the deny-rules section. Bob copy-pasted the Prettier config. Bob copy-pasted the ESLint config. Bob copy-pasted the Ruff config. Sarah added more notes. Priya added a personal-preferences section. Bob added the things-not-to-do list. Sarah added the things-to-do list. The PR-review checklist got copied in from somewhere. The internal jargon glossary started as a joke and became a reference. The architecture overview was copied from `docs/architecture/overview.md` "for convenience" and never trimmed. The vendor copy-pastes were added during the period when Bob did not trust the agent to know basic style. Marcus left notes. Carlos's preferences were preserved because nobody wanted to delete them. Sarah went on leave; Bob added more sections. The Slack etiquette was added after a single confused new hire. The meeting cadence was added after a different confused new hire. The on-call rotation was added after a third confused new hire. (Pattern noticed but no action taken.) Each addition was small. Each addition was reasonable. The total is unreasonable.

The lab exercise this file supports is: cut this back to under 500 lines. Decide what is a project rule (`AGENTS.md`), what is a personal preference (`~/.copilot/instructions.md`), what is a workflow (a `SKILL.md`), what is a hard guarantee (a hook), what is documentation (a `docs/` file), and what is just sediment (delete).

Good luck.

## Postmortem: 2025-03-11 cascading deploy failure

**Summary:** A planned deploy of the customer service introduced a database connection pool exhaustion that cascaded to the API gateway and the routing service. ~22 minutes of degraded read availability for ~40% of customers. No data loss.

**Timeline:**

- 2025-03-11 14:02 UTC: planned deploy of customer service v2025.03.11.1.
- 14:05 UTC: customer service health checks pass; deploy declared successful.
- 14:08 UTC: alert on `customer_service_db_pool_saturation` fires.
- 14:09 UTC: alert on `gateway_p99_latency` fires.
- 14:11 UTC: SEV2 declared. Primary on-call (Priya) ack'd.
- 14:14 UTC: hypothesis: pool exhaustion driven by a new query in customer service that holds a transaction open across an HTTP call to the auth service.
- 14:18 UTC: rollback initiated.
- 14:24 UTC: rollback complete. Pool saturation cleared.
- 14:30 UTC: SEV2 closed.
- 2025-03-13: incident review meeting.

**Root cause:** A new endpoint in customer service opened a database transaction, then made an HTTP call to the auth service to validate a permission, then continued the transaction. Under normal conditions the auth call took ~10ms and the pool was fine. Under the post-deploy condition (auth service was also being deployed simultaneously, slowing it briefly), the auth calls took ~800ms, transactions held longer, pool saturated, requests queued, gateway timed out.

**Action items:**

1. Add a lint rule that flags HTTP calls inside open database transactions. (Done, 2025-03-20.)
2. Stagger deploys: customer service and auth service must not deploy in the same window. (Done in deploy tooling, 2025-03-25.)
3. Add per-service pool-saturation alerts at 70% (warn) and 85% (page). (Done, 2025-03-15.)
4. Document "no I/O in transactions" rule in the team handbook. (Done; this file references it below.)
5. Audit existing endpoints for the same antipattern. (Found 3 more cases; fixed in subsequent PRs.)

**Lessons:**

- Coupling deploys is a hidden risk; explicit staggering is cheap insurance.
- Pool saturation is a leading indicator; the latency alert was lagging.
- A fast operation under good conditions can become slow enough to break things under bad conditions; design for the bad-conditions case.

**Rule established:** *No network I/O inside an open database transaction.* This is restated below in the data-access patterns section.

## Data-access patterns

- **No network I/O inside an open database transaction.** (See postmortem above.) If you need to call another service, do it before `BEGIN` or after `COMMIT`. If you need transactional consistency across a service boundary, use the outbox pattern.
- **Use connection pooling.** SQLAlchemy's pool is configured per service in `db/session.py`. Do not bypass it.
- **Use `read_only` connections for read-heavy queries.** We have a separate read replica connection string for the reporting service.
- **Use `LIMIT` on every query that does not have an obvious upper bound.** A query without `LIMIT` against a table that grows unboundedly is a future incident.
- **Use `SELECT FOR UPDATE` only with a clear lock-ordering plan.** Inconsistent lock ordering causes deadlocks. Document the lock order in the function docstring.
- **Use prepared statements via the ORM.** Do not build SQL by string concatenation, ever. (See "Things the agent has done that surprised us, in a good way" above.)
- **Use migrations for all schema changes.** Never manual SQL against production. (Already in Database migrations above.)
- **Use `EXPLAIN ANALYZE` before merging a query that is non-trivial.** Bonus points for attaching the query plan to the PR description.

This section is good content. It probably belongs in `docs/database-conventions.md` rather than here, but for now it lives here.

## Worker patterns

- **Workers should be idempotent.** Celery may retry on failure; design tasks so retry is safe.
- **Workers should not hold long locks.** If a job takes >30 seconds, consider chunking.
- **Workers should checkpoint progress.** Long jobs should write partial state so a restart resumes from the last checkpoint, not the beginning.
- **Workers should respect task timeouts.** Set both `time_limit` and `soft_time_limit` on every task.
- **Workers should log structured events at start, end, and at each major step.** This is for incident triage.
- **Workers should publish metrics.** At minimum: invocation count, success/failure count, duration histogram.

These are restated from `docs/runbooks/workers.md`. This file is the canonical reference now because Bob.

## API patterns

- **Endpoints should be specific.** `/api/v1/customers/{id}/contacts` not `/api/v1/getCustomerContacts`.
- **Endpoints should return appropriate status codes.** (See API conventions section above.)
- **Endpoints should validate input via pydantic models.** Do not write manual validation.
- **Endpoints should authorize on the resource, not just the route.** A user with route access may not have resource access.
- **Endpoints should be paginated where the response is a list.** Default page size 20, max 100.
- **Endpoints should be idempotent for safe methods.** GET, HEAD, OPTIONS, PUT, DELETE.
- **Endpoints should support the `Idempotency-Key` header on POST.** This is implemented in the gateway middleware.
- **Endpoints should not expose internal IDs.** Use UUIDs for resource IDs in the URL.
- **Endpoints should not expose stack traces in error responses.** Errors are scrubbed by the gateway.
- **Endpoints should be documented in OpenAPI.** FastAPI generates this from pydantic models; ensure the model is descriptive.

These are restated from `docs/api-conventions.md`. The agent should follow these for new endpoints.

## Frontend patterns

- **Components should be small.** If a component file exceeds 200 lines, consider splitting.
- **Components should be typed.** Props interfaces explicit, no `any`.
- **State management.** Local component state for component-only state (`useState`). Cross-component state for the same view: lift to the nearest common parent. Cross-view state: Zustand. Server state: TanStack Query (do not store server data in Zustand).
- **Effects.** Use sparingly. If you find yourself reaching for `useEffect`, consider whether the logic belongs in an event handler or a TanStack Query callback instead.
- **Forms.** React Hook Form for everything. Zod schema for validation. The schema is the source of truth.
- **Routing.** React Router v6. Code-split at the route level via `React.lazy`.
- **Styling.** Tailwind utilities. For repeated patterns, extract a component (not a class). Avoid `@apply` in our component CSS unless absolutely necessary.
- **Accessibility.** Use semantic HTML. Use `@fleet/ui` components which have accessibility baked in. Test with the keyboard.
- **Internationalisation.** Wrap user-facing strings in `t()`. Do not interpolate translated strings; use named placeholders.

These are restated from `docs/frontend-conventions.md`. The agent should follow these for new frontend code.

## Backend patterns (extends Backend section above)

- **Service boundaries are HTTP, not function calls.** Do not import from another service package.
- **Shared code goes in `packages/`.** A package is for code with no service-specific runtime; if it needs a database or a Celery worker, it is a service.
- **Configuration via environment variables.** Use pydantic-settings for typed config. Never hardcode.
- **Logging context is request-scoped.** Inject the request ID, tenant ID, and user ID via FastAPI dependencies; let `structlog` carry them automatically.
- **Background work via Celery.** Inline `await` for fast operations (<100ms); Celery for everything else.
- **Locks via Redis.** Use `redis-py-cluster` distributed locks with explicit TTLs and renewal.
- **Caching via Redis.** Explicit TTLs; never default. Invalidate on write.
- **Rate limiting via Redis.** Token bucket; configured at the gateway.

Restated from various `docs/runbooks/`. The agent should follow these for backend code.

## Test patterns (extends Testing section above)

- **Unit tests are fast and isolated.** No I/O. No databases. No network. No filesystem (use `tmp_path`).
- **Integration tests use real dependencies.** Real Postgres (ephemeral via `pytest-postgresql`), real Redis (ephemeral via `pytest-redis`).
- **End-to-end tests use the deployed stack.** Run against staging via Playwright.
- **Property-based tests for pure functions.** Use Hypothesis for Python, fast-check for TypeScript.
- **Snapshot tests for component output.** Vitest snapshots for React components.
- **Contract tests at service boundaries.** Pact for HTTP contracts between services. (We have pact tests for half the services. The rest are on the to-do list.)
- **Mutation tests on critical modules.** Mutmut for Python, Stryker for TypeScript. Run weekly, not per-PR.
- **Load tests in staging.** k6 scripts in `tests/load/`. Run before each major release.
- **Chaos tests in staging.** Toxiproxy in front of dependencies; we test latency, packet loss, connection drops.

Restated from `docs/testing.md`. Some of these we follow rigorously; others we aspire to. The agent should propose tests at the appropriate layer.

## Security patterns (extends Security section above)

- **Secrets via 1Password + injected env vars.** Never in code, never in commits.
- **Input validation at the boundary.** pydantic models, Zod schemas. Trust nothing.
- **Output escaping at the sink.** Template engines (Jinja, JSX) escape by default; do not bypass.
- **SQL via parameterized queries.** Always.
- **HTTP via library helpers.** `requests` for Python, `fetch` for TypeScript. Do not build URLs by string concatenation.
- **Auth checks via the dependency injector.** `Depends(get_current_user)` plus a permission check.
- **CSRF protection on state-changing endpoints.** Double-submit cookie pattern.
- **CSP on all HTML responses.** Configured in the gateway.
- **HSTS preload.** Configured in CloudFront.
- **Dependencies updated regularly.** Dependabot configured for weekly updates.
- **Vulnerability scanning in CI.** `pip-audit`, `pnpm audit`, `trivy` for container images.
- **SBOM generation on each build.** SPDX format. Stored in the artifact registry.

Restated from `docs/security.md`. The agent should follow these. Compliance reviews use this checklist; the team handbook has the longer version.

## Build and deploy patterns

- **One artifact per service per commit.** Tagged with the commit SHA.
- **Promotion-based deploys.** Build once in CI; promote the same artifact through dev → staging → prod.
- **Blue-green for stateless services.** New version brought up alongside; traffic shifted gradually.
- **Rolling for stateful services.** With explicit pre-deploy migrations and post-deploy verification.
- **Migration before deploy.** Schema changes deploy first, code that depends on them second. (See Database migrations.)
- **Feature flags for risky changes.** Flag-gated rollout via Unleash, with explicit ramp plans (1% → 10% → 50% → 100%).
- **Rollback within 5 minutes.** Every deploy must support fast rollback. CI verifies the rollback path before promoting.
- **Notifications on every deploy.** Slack `#deploys` channel auto-posts.

Restated from `docs/runbooks/deploy.md`. The agent does not deploy; this section is for human onboarding. (Pattern noted; not addressed.)

## Observability patterns

- **Logs are structured.** JSON output in production. Human-readable in development.
- **Metrics are dimensional.** Use labels for tenant, service, version. Avoid high-cardinality labels (no per-user, no per-request-ID).
- **Traces span service boundaries.** OpenTelemetry instrumented at the framework level (FastAPI, Celery, SQLAlchemy).
- **Errors are reported.** Sentry for unhandled exceptions and user-impacting errors.
- **Dashboards are owned.** Each service has a Grafana dashboard owned by the service owner.
- **Alerts are actionable.** Every alert has a runbook link in the description.
- **Alerts are silenced during planned maintenance.** PagerDuty maintenance windows.

Restated from `docs/observability.md`.

## Final note

This file is too long. We know. Someone should clean it up.

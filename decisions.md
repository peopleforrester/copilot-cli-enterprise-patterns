# Decisions

Durable engineering decisions for this repo, newest first.

## 2026-10-17 — markdownlint-cli 0.49.1 in the local fast tier, through npx

- **What:** `tests/run.sh` now runs `markdownlint-cli@0.49.1` via the `tests/bin/markdownlint` shim (`npx --yes --package=markdownlint-cli@0.49.1`). The version is the current npm release as of 2026-10-17 and the same pin CI installs.
- **Why:** CI lints markdown with `markdownlint-cli`, but the local Test command did not. Without it the lint hook's Markdown branch was a no-op and test 1 of `test_lint_changed.sh` passed trivially (issue #7).
- **Why npx and not a uv-installed Python linter:** Node 24 and npm are now on the dispatch host. Running the exact CI tool and version gives the same verdict as CI. A Python reimplementation (pymarkdownlnt, rumdl) would interpret the rules and `.markdownlint.json` its own way and could disagree with CI.
- **Why no `package.json`:** the repo has no JS project, and CI installs globally rather than from a manifest. A pinned `npx` shim adds no lockfile or `node_modules/`.
- **Drift guard:** `tests/run.sh` fails if the shim's version or ignore list differs from `.github/workflows/ci.yml`. Bump both together.

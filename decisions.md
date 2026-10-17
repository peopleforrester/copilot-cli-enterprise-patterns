# Decisions

Durable engineering decisions for this repo, newest first.

## 2026-10-17 — lychee 0.24.2 in the heavy tier, as a hash-checked release binary

- **What:** `tests/e2e.sh` puts `tests/bin` on PATH, as `tests/run.sh` already did. `tests/bin/lychee` downloads the lychee 0.24.2 musl release binary from GitHub on first use, checks it against the sha256 published with the release, and caches it in `${XDG_CACHE_HOME:-~/.cache}/copilot-cli-enterprise-patterns/`. 0.24.2 is the latest lychee release as of 2026-10-17.
- **Why:** the heavy gate failed on `staging` because neither `markdownlint` nor `lychee` was on the dispatch host's PATH (issue #10). The markdownlint shim already existed but only `tests/run.sh` used it.
- **Why a release binary:** lychee is a Rust tool and isn't published to npm or PyPI. The host has no cargo, and building from source would be slow. The static musl build needs no system libraries.
- **No fallback:** an unsupported platform, a failed download, or a hash mismatch is a failure with a message. To bump the version, update the version and both digests together.

## 2026-10-17 — markdownlint-cli 0.49.1 in the local fast tier, through npx

- **What:** `tests/run.sh` now runs `markdownlint-cli@0.49.1` via the `tests/bin/markdownlint` shim (`npx --yes --package=markdownlint-cli@0.49.1`). The version is the current npm release as of 2026-10-17 and the same pin CI installs.
- **Why:** CI lints markdown with `markdownlint-cli`, but the local Test command did not. Without it the lint hook's Markdown branch was a no-op and test 1 of `test_lint_changed.sh` passed trivially (issue #7).
- **Why npx and not a uv-installed Python linter:** Node 24 and npm are now on the dispatch host. Running the exact CI tool and version gives the same verdict as CI. A Python reimplementation (pymarkdownlnt, rumdl) would interpret the rules and `.markdownlint.json` its own way and could disagree with CI.
- **Why no `package.json`:** the repo has no JS project, and CI installs globally rather than from a manifest. A pinned `npx` shim adds no lockfile or `node_modules/`.
- **Drift guard:** `tests/run.sh` fails if the shim's version or ignore list differs from `.github/workflows/ci.yml`. Bump both together.

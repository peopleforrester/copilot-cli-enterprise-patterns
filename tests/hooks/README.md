# Hook tests

Bash-based test harness for the shipped hooks under `scripts/copilot-hooks/`. The course teaches verification (Pillar 4); this directory dogfoods that — the repo's own verification artefacts have tests.

## Run locally

```bash
bash tests/run.sh
```

`tests/run.sh` is the fast tier: it shellchecks `scripts/` and `tests/`, runs markdownlint over every `.md` file with CI's ignore list, validates every JSON file, and runs each `tests/hooks/test_*.sh`. It also fails if the local markdownlint version or ignore list drifts from `.github/workflows/ci.yml`. To run one suite on its own:

```bash
PATH="$PWD/tests/bin:$PATH" bash tests/hooks/test_lint_changed.sh
bash tests/hooks/test_run_tests.sh
```

Requires `bash`, `jq`, `shellcheck`, `timeout` (GNU coreutils), and `npx` (Node.js). CI installs `markdownlint-cli` globally; locally `tests/bin/markdownlint` runs the same pinned version through `npx`, which downloads it on first use and caches it after that. Each suite exits 0 on all-pass, 1 on any failure, 2 if a required tool is missing. `tests/run.sh` treats a missing tool as a failure.

## What's covered

`test_lint_changed.sh` (preToolUse lint hook):

- A clean Markdown file produces no `"deny"` output; one with a markdownlint error is denied.
- A syntactically broken JSON file produces `"deny": true` on stdout.
- An event with no path is approved (nothing to lint).
- An event referencing a non-existent file is approved (new-file branch).
- A shell script with a shellcheck error is denied; a clean one is approved.
- The target path is read from `file_path`, `filePath`, and `filename` as well as `path`.

`test_run_tests.sh` (postToolUse test hook):

- A directory with no recognised test setup is a silent no-op.
- pnpm, npm, uv/pytest, bare pytest, cargo, and go projects each dispatch to the right command.
- The test command's exit code is propagated.
- A manifest whose toolchain is missing is a no-op.
- `COPILOT_HOOK_TEST_TIMEOUT` kills a hung test run (exit 124).

Each case runs with a `PATH` holding only stub toolchains, so the host's real `uv` or `pnpm` cannot change which branch the hook takes. Broken lint targets are generated in a tempdir at runtime so invalid JSON is never committed to the tree.

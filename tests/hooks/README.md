# Hook tests

Bash-based test harness for the shipped hooks under `scripts/copilot-hooks/`. The course teaches verification (Pillar 4); this directory dogfoods that — the repo's own verification artefacts have tests.

## Run locally

```bash
chmod +x tests/hooks/test_lint_changed.sh
bash tests/hooks/test_lint_changed.sh
```

Requires `bash` and `jq`. Exits 0 on all-pass, 1 on any failure, 2 if a required tool is missing (treat as skip in CI).

## What's covered

- A clean Markdown file produces no `"deny"` output.
- A syntactically broken JSON file produces `"deny": true` on stdout.
- An event with no path is approved (nothing to lint).
- An event referencing a non-existent file is approved (new-file branch).

The broken-JSON target is generated in a tempdir at runtime so invalid JSON is never committed to the tree.

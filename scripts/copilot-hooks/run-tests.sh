#!/usr/bin/env bash
# ABOUTME: postToolUse hook script — run the fast test tier after a file edit.
# ABOUTME: postToolUse cannot block; failures are surfaced to the agent for autonomous fix.

set -uo pipefail

# Drain stdin (Copilot CLI delivers a JSON event we don't currently need).
cat >/dev/null || true

TIMEOUT="${COPILOT_HOOK_TEST_TIMEOUT:-180}"

run_with_timeout() {
  if command -v timeout >/dev/null 2>&1; then
    timeout "$TIMEOUT" "$@"
  else
    "$@"
  fi
}

if [[ -f package.json ]]; then
  if command -v pnpm >/dev/null 2>&1 && [[ -f pnpm-lock.yaml ]]; then
    run_with_timeout pnpm test --silent
    exit $?
  fi
  if command -v npm >/dev/null 2>&1; then
    run_with_timeout npm test --silent
    exit $?
  fi
fi

if [[ -f pyproject.toml ]] || [[ -f pytest.ini ]] || compgen -G "tests/*.py" >/dev/null; then
  if command -v uv >/dev/null 2>&1; then
    run_with_timeout uv run pytest -q
    exit $?
  fi
  if command -v pytest >/dev/null 2>&1; then
    run_with_timeout pytest -q
    exit $?
  fi
fi

if [[ -f Cargo.toml ]] && command -v cargo >/dev/null 2>&1; then
  run_with_timeout cargo test --quiet
  exit $?
fi

if [[ -f go.mod ]] && command -v go >/dev/null 2>&1; then
  run_with_timeout go test ./...
  exit $?
fi

# No recognised test setup — succeed silently so the hook is a no-op.
exit 0

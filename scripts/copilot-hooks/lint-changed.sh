#!/usr/bin/env bash
# ABOUTME: PreToolUse hook script — lint files about to be edited.
# ABOUTME: Reads the target path from $COPILOT_HOOK_FILE_PATH and dispatches to the right linter.

set -euo pipefail

FILE="${COPILOT_HOOK_FILE_PATH:-${1:-}}"
if [[ -z "$FILE" ]]; then
  echo "lint-changed: no file path provided" >&2
  exit 0
fi

# Skip files that don't exist yet (new file creation).
if [[ ! -f "$FILE" ]]; then
  exit 0
fi

case "$FILE" in
  *.py)
    if command -v ruff >/dev/null 2>&1; then
      ruff check "$FILE"
    else
      echo "lint-changed: ruff not installed, skipping $FILE" >&2
    fi
    ;;
  *.ts|*.tsx|*.js|*.jsx)
    if command -v pnpm >/dev/null 2>&1 && [[ -f package.json ]]; then
      pnpm exec eslint "$FILE"
    elif command -v npx >/dev/null 2>&1; then
      npx --no-install eslint "$FILE" 2>/dev/null || true
    fi
    ;;
  *.sh)
    if command -v shellcheck >/dev/null 2>&1; then
      shellcheck "$FILE"
    fi
    ;;
  *.json)
    if command -v jq >/dev/null 2>&1; then
      jq empty "$FILE"
    fi
    ;;
  *.md)
    if command -v markdownlint >/dev/null 2>&1; then
      markdownlint "$FILE"
    fi
    ;;
  *)
    # Unknown extension — no linter, no failure.
    exit 0
    ;;
esac

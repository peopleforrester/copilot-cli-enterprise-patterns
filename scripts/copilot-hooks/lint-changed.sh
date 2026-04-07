#!/usr/bin/env bash
# ABOUTME: preToolUse hook script — lint files about to be edited.
# ABOUTME: Reads JSON from stdin (toolName, toolArgs, cwd) and emits {"deny": true} on lint failure.

set -uo pipefail

# Copilot CLI delivers a JSON event on stdin. Parse out the file path from toolArgs.
INPUT="$(cat || true)"

extract_path() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$INPUT" | jq -r '
      .toolArgs.path
      // .toolArgs.file_path
      // .toolArgs.filePath
      // .toolArgs.filename
      // empty
    '
  else
    # Fallback: best-effort grep for a "path" field.
    printf '%s' "$INPUT" | grep -oE '"(path|file_path|filePath)"[[:space:]]*:[[:space:]]*"[^"]+"' \
      | head -n1 | sed -E 's/.*"([^"]+)"$/\1/'
  fi
}

deny() {
  local reason="$1"
  printf '{"deny": true, "reason": %s}\n' "$(printf '%s' "$reason" | jq -Rsa . 2>/dev/null || printf '"%s"' "$reason")"
  exit 0
}

FILE="$(extract_path)"
if [[ -z "${FILE:-}" ]]; then
  # No file path in event — nothing to lint, allow.
  exit 0
fi

# Skip files that don't exist yet (new file creation).
if [[ ! -f "$FILE" ]]; then
  exit 0
fi

case "$FILE" in
  *.py)
    if command -v ruff >/dev/null 2>&1; then
      if ! OUT="$(ruff check "$FILE" 2>&1)"; then
        deny "ruff failed for $FILE: $OUT"
      fi
    fi
    ;;
  *.ts|*.tsx|*.js|*.jsx)
    if command -v pnpm >/dev/null 2>&1 && [[ -f package.json ]]; then
      if ! OUT="$(pnpm exec eslint "$FILE" 2>&1)"; then
        deny "eslint failed for $FILE: $OUT"
      fi
    fi
    ;;
  *.sh)
    if command -v shellcheck >/dev/null 2>&1; then
      if ! OUT="$(shellcheck "$FILE" 2>&1)"; then
        deny "shellcheck failed for $FILE: $OUT"
      fi
    fi
    ;;
  *.json)
    if command -v jq >/dev/null 2>&1; then
      if ! OUT="$(jq empty "$FILE" 2>&1)"; then
        deny "invalid JSON in $FILE: $OUT"
      fi
    fi
    ;;
  *.md)
    if command -v markdownlint >/dev/null 2>&1; then
      if ! OUT="$(markdownlint "$FILE" 2>&1)"; then
        deny "markdownlint failed for $FILE: $OUT"
      fi
    fi
    ;;
esac

# Empty stdout + exit 0 = approve.
exit 0

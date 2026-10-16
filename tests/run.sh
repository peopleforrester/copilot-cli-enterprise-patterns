#!/usr/bin/env bash
# ABOUTME: Fast test tier for the repo: shellcheck, JSON validation, and every hook test.
# ABOUTME: Mirrors the offline CI steps so one command gives the same verdict locally.

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_ROOT}" || exit 1

failed=()

for tool in bash jq shellcheck timeout; do
    if ! command -v "${tool}" >/dev/null 2>&1; then
        printf 'FAIL: required tool not on PATH: %s\n' "${tool}" >&2
        exit 2
    fi
done

step() {
    local name="$1"
    shift
    printf '== %s\n' "${name}"
    if ! "$@"; then
        failed+=("${name}")
    fi
}

lint_shell() {
    find scripts tests -name '*.sh' -exec shellcheck {} +
}

validate_json() {
    local f
    local bad=0
    while IFS= read -r f; do
        if ! jq empty "${f}" >/dev/null 2>&1; then
            printf 'invalid JSON: %s\n' "${f}" >&2
            bad=1
        fi
    done < <(find . -name '*.json' -not -path './node_modules/*' -not -path './.git/*')
    return "${bad}"
}

step "shellcheck" lint_shell
step "json" validate_json
for t in tests/hooks/test_*.sh; do
    step "${t}" bash "${t}"
done

if [[ ${#failed[@]} -gt 0 ]]; then
    printf '\nFAILED: %s\n' "${failed[*]}" >&2
    exit 1
fi
printf '\nall checks passed\n'

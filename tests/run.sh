#!/usr/bin/env bash
# ABOUTME: Fast test tier: shellcheck, markdownlint, JSON validation, and every hook test.
# ABOUTME: Mirrors the offline CI steps so one command gives the same verdict locally.

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_ROOT}" || exit 1

# CI installs markdownlint-cli globally; locally the pinned npx shim stands in for it, so
# both the repo lint and the lint hook under test resolve `markdownlint` the same way.
export PATH="${REPO_ROOT}/tests/bin:${PATH}"

readonly CI_WORKFLOW=".github/workflows/ci.yml"
# Same ignore list as CI's "Lint markdown" step; check_markdownlint_parity enforces that.
readonly MARKDOWNLINT_IGNORES=(
    node_modules
    labs/lab-03-externalization/inherited-AGENTS.md
    transcripts
)

failed=()

for tool in bash jq npx shellcheck timeout; do
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
    # tests/bin/markdownlint has no .sh suffix (the hook calls it by name), so list it.
    find scripts tests -name '*.sh' -exec shellcheck tests/bin/markdownlint {} +
}

lint_markdown() {
    local args=('**/*.md')
    local dir
    for dir in "${MARKDOWNLINT_IGNORES[@]}"; do
        args+=(--ignore "${dir}")
    done
    markdownlint "${args[@]}"
}

# A local pass only means something if it runs the same linter, version, and file set as CI.
check_markdownlint_parity() {
    local ci_version local_version expected_run dir
    ci_version="$(grep -oE 'markdownlint-cli@[0-9][0-9.]*' "${CI_WORKFLOW}" | head -n1)"
    ci_version="${ci_version#markdownlint-cli@}"
    if ! local_version="$(markdownlint --version)"; then
        printf 'markdownlint --version failed\n' >&2
        return 1
    fi
    if [[ -z "${ci_version}" || "${ci_version}" != "${local_version}" ]]; then
        printf 'markdownlint-cli pin drift: CI=%s local=%s\n' \
            "${ci_version:-<none>}" "${local_version}" >&2
        return 1
    fi
    expected_run="run: markdownlint '**/*.md'"
    for dir in "${MARKDOWNLINT_IGNORES[@]}"; do
        expected_run+=" --ignore ${dir}"
    done
    if ! sed 's/^[[:space:]]*//' "${CI_WORKFLOW}" | grep -Fxq -- "${expected_run}"; then
        printf 'CI lint step differs from the local one; expected in %s:\n  %s\n' \
            "${CI_WORKFLOW}" "${expected_run}" >&2
        return 1
    fi
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
step "markdownlint parity with CI" check_markdownlint_parity
step "markdownlint" lint_markdown
step "json" validate_json
for t in tests/hooks/test_*.sh; do
    step "${t}" bash "${t}"
done

if [[ ${#failed[@]} -gt 0 ]]; then
    printf '\nFAILED: %s\n' "${failed[*]}" >&2
    exit 1
fi
printf '\nall checks passed\n'

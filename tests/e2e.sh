#!/usr/bin/env bash
# ABOUTME: Heavy test tier: markdownlint and a live link check over every tracked Markdown file.
# ABOUTME: Needs the network and both tools on PATH; any missing prerequisite is a test failure.

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${REPO_ROOT}" || exit 1

# Same pins as .github/workflows/ci.yml, so a local pass predicts the CI verdict.
declare -A install_hint=(
    [git]="install git"
    [markdownlint]="npm install -g markdownlint-cli@0.49.1"
    [lychee]="https://github.com/lycheeverse/lychee/releases (0.24+)"
)
for tool in git markdownlint lychee; do
    if ! command -v "${tool}" >/dev/null 2>&1; then
        printf 'FAIL: required tool not on PATH: %s (%s)\n' "${tool}" "${install_hint[${tool}]}" >&2
        exit 1
    fi
done

# The link check is the point of this tier; with no network every link would fail,
# so say that once rather than burying it under hundreds of per-link errors.
if ! git ls-remote --exit-code https://github.com/lycheeverse/lychee HEAD >/dev/null 2>&1; then
    printf 'FAIL: network unreachable (cannot reach github.com); the link check needs it\n' >&2
    exit 1
fi

# Tracked files only, so untracked drop zones (transcripts/, node_modules/) never leak in.
mapfile -t md_files < <(git ls-files '*.md')
# The lab hands learners a deliberately bad AGENTS.md to repair; linting it would defeat the lab.
mapfile -t lint_files < <(printf '%s\n' "${md_files[@]}" \
    | grep -vxF 'labs/lab-03-externalization/inherited-AGENTS.md')

failed=()

step() {
    local name="$1"
    shift
    printf '== %s\n' "${name}"
    if ! "$@"; then
        failed+=("${name}")
    fi
}

step "markdownlint" markdownlint -- "${lint_files[@]}"
step "links" lychee --no-progress -- "${md_files[@]}"

if [[ ${#failed[@]} -gt 0 ]]; then
    printf '\nFAILED: %s\n' "${failed[*]}" >&2
    exit 1
fi
printf '\nall e2e checks passed\n'

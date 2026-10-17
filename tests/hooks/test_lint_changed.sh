#!/usr/bin/env bash
# ABOUTME: Test harness for scripts/copilot-hooks/lint-changed.sh.
# ABOUTME: Pipes preToolUse-shaped JSON events to the hook and asserts deny/allow.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
HOOK="${REPO_ROOT}/scripts/copilot-hooks/lint-changed.sh"
FIXTURES="${SCRIPT_DIR}/fixtures"

readonly PASS=0
readonly FAIL=1

fail_count=0
test_count=0

red() { [[ -t 1 ]] && printf '\033[31m%s\033[0m' "$1" || printf '%s' "$1"; }
green() { [[ -t 1 ]] && printf '\033[32m%s\033[0m' "$1" || printf '%s' "$1"; }

assert_no_deny() {
    local name="$1"
    local out="$2"
    local exit_code="$3"
    test_count=$((test_count + 1))
    if [[ ${exit_code} -ne 0 ]]; then
        printf '%s %s — expected exit 0, got %d\n' "$(red FAIL)" "${name}" "${exit_code}" >&2
        fail_count=$((fail_count + 1))
        return ${FAIL}
    fi
    if printf '%s' "${out}" | grep -q '"deny"[[:space:]]*:[[:space:]]*true'; then
        printf '%s %s — expected no deny, got: %s\n' "$(red FAIL)" "${name}" "${out}" >&2
        fail_count=$((fail_count + 1))
        return ${FAIL}
    fi
    printf '%s %s\n' "$(green PASS)" "${name}"
    return ${PASS}
}

assert_deny() {
    local name="$1"
    local out="$2"
    local exit_code="$3"
    test_count=$((test_count + 1))
    if [[ ${exit_code} -ne 0 ]]; then
        printf '%s %s — expected exit 0, got %d\n' "$(red FAIL)" "${name}" "${exit_code}" >&2
        fail_count=$((fail_count + 1))
        return ${FAIL}
    fi
    if ! printf '%s' "${out}" | grep -q '"deny"[[:space:]]*:[[:space:]]*true'; then
        printf '%s %s — expected deny, got: %s\n' "$(red FAIL)" "${name}" "${out}" >&2
        fail_count=$((fail_count + 1))
        return ${FAIL}
    fi
    printf '%s %s\n' "$(green PASS)" "${name}"
    return ${PASS}
}

require() {
    if ! command -v "$1" >/dev/null 2>&1; then
        printf 'FAIL: required tool not on PATH: %s\n' "$1" >&2
        exit 2
    fi
}

require bash
require jq
require shellcheck
# Without markdownlint the hook's .md branch is a no-op and the Markdown cases pass vacuously.
# CI installs it globally; tests/run.sh puts the pinned tests/bin/markdownlint shim on PATH.
require markdownlint

if [[ ! -x "${HOOK}" ]]; then
    printf 'FAIL: hook script not executable: %s\n' "${HOOK}" >&2
    exit 1
fi

# --- Test 1: clean Markdown file → no deny ---
# Static fixture references README.md (always clean in this repo).
out="$(cd "${REPO_ROOT}" && "${HOOK}" < "${FIXTURES}/edit-md-event.json")"
assert_no_deny "clean .md fixture (README.md)" "${out}" "$?"

# --- Test 2: broken JSON file → deny on stdout ---
# Generate the broken target and event in a tempdir so we never commit
# invalid JSON (the CI's existing JSON-validate step would reject it).
TMPDIR_TEST="$(mktemp -d)"
trap 'rm -rf "${TMPDIR_TEST}"' EXIT
printf '{"this is": "not json' > "${TMPDIR_TEST}/broken.json"
event=$(jq -n --arg path "${TMPDIR_TEST}/broken.json" \
    '{version: 1, event: "preToolUse", toolName: "edit_file", toolArgs: {path: $path}, cwd: "."}')
out="$(printf '%s' "${event}" | "${HOOK}")"
assert_deny "broken .json target produces deny" "${out}" "$?"

# --- Test 3: event with no path → no deny, exit 0 ---
event_no_path='{"version": 1, "event": "preToolUse", "toolName": "edit_file", "toolArgs": {}, "cwd": "."}'
out="$(printf '%s' "${event_no_path}" | "${HOOK}")"
assert_no_deny "event with no path is approved" "${out}" "$?"

# --- Test 4: event pointing at non-existent file → no deny (new-file path) ---
event_missing=$(jq -n --arg path "${TMPDIR_TEST}/does-not-exist.py" \
    '{version: 1, event: "preToolUse", toolName: "edit_file", toolArgs: {path: $path}, cwd: "."}')
out="$(printf '%s' "${event_missing}" | "${HOOK}")"
assert_no_deny "non-existent file is approved (new-file branch)" "${out}" "$?"

# --- Test 5: shell script with a shellcheck error → deny ---
# SC2068 (unquoted $@) is an error-level finding, stable across shellcheck versions.
cat > "${TMPDIR_TEST}/bad.sh" <<'EOF'
#!/usr/bin/env bash
for a in $@; do echo "$a"; done
EOF
event=$(jq -n --arg path "${TMPDIR_TEST}/bad.sh" \
    '{version: 1, event: "preToolUse", toolName: "edit_file", toolArgs: {path: $path}, cwd: "."}')
out="$(printf '%s' "${event}" | "${HOOK}")"
assert_deny "shellcheck failure on .sh target produces deny" "${out}" "$?"

# --- Test 6: clean shell script → no deny ---
cat > "${TMPDIR_TEST}/good.sh" <<'EOF'
#!/usr/bin/env bash
for a in "$@"; do echo "$a"; done
EOF
out="$(jq -n --arg path "${TMPDIR_TEST}/good.sh" \
    '{version: 1, event: "preToolUse", toolName: "edit_file", toolArgs: {path: $path}, cwd: "."}' \
    | "${HOOK}")"
assert_no_deny "clean .sh target is approved" "${out}" "$?"

# --- Tests 7-9: path read from the alternate toolArgs keys ---
# Tools name the target differently; a missed key would silently skip linting.
for key in file_path filePath filename; do
    event=$(jq -n --arg path "${TMPDIR_TEST}/broken.json" --arg key "${key}" \
        '{version: 1, event: "preToolUse", toolName: "edit_file", toolArgs: {($key): $path}, cwd: "."}')
    out="$(printf '%s' "${event}" | "${HOOK}")"
    assert_deny "toolArgs.${key} is read as the target path" "${out}" "$?"
done

# --- Test 10: Markdown file with a markdownlint error → deny ---
# MD018 (no space after # in a heading) is on in both the default and the repo config.
printf '#Heading without a space\n' > "${TMPDIR_TEST}/bad.md"
event=$(jq -n --arg path "${TMPDIR_TEST}/bad.md" \
    '{version: 1, event: "preToolUse", toolName: "edit_file", toolArgs: {path: $path}, cwd: "."}')
out="$(printf '%s' "${event}" | "${HOOK}")"
assert_deny "markdownlint failure on .md target produces deny" "${out}" "$?"

# --- Summary ---
printf '\n%d/%d passed\n' "$((test_count - fail_count))" "${test_count}"
if [[ ${fail_count} -gt 0 ]]; then
    exit 1
fi
exit 0

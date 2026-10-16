#!/usr/bin/env bash
# ABOUTME: Test harness for scripts/copilot-hooks/run-tests.sh.
# ABOUTME: Runs the hook in throwaway projects with stub toolchains and asserts dispatch and exit codes.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
HOOK="${REPO_ROOT}/scripts/copilot-hooks/run-tests.sh"
EVENT='{"version": 1, "event": "postToolUse", "toolName": "edit_file", "toolArgs": {"path": "x"}}'

fail_count=0
test_count=0

red() { [[ -t 1 ]] && printf '\033[31m%s\033[0m' "$1" || printf '%s' "$1"; }
green() { [[ -t 1 ]] && printf '\033[32m%s\033[0m' "$1" || printf '%s' "$1"; }

record() {
    local name="$1"
    local ok="$2"
    local detail="$3"
    test_count=$((test_count + 1))
    if [[ "${ok}" == "yes" ]]; then
        printf '%s %s\n' "$(green PASS)" "${name}"
    else
        printf '%s %s — %s\n' "$(red FAIL)" "${name}" "${detail}" >&2
        fail_count=$((fail_count + 1))
    fi
}

require() {
    if ! command -v "$1" >/dev/null 2>&1; then
        printf 'SKIP: %s not on PATH\n' "$1" >&2
        exit 2
    fi
}

require bash
require timeout

if [[ ! -x "${HOOK}" ]]; then
    printf 'FAIL: hook script not executable: %s\n' "${HOOK}" >&2
    exit 1
fi

BASH_BIN="$(command -v bash)"
TMPDIR_TEST="$(mktemp -d)"
trap 'rm -rf "${TMPDIR_TEST}"' EXIT

# Each case gets a fresh project dir and a PATH holding only the stubs it
# declares plus cat/timeout. Real toolchains on the host (uv, pnpm, ...) would
# otherwise change which branch the hook takes.
case_num=0
new_case() {
    case_num=$((case_num + 1))
    CASE_DIR="${TMPDIR_TEST}/case-${case_num}"
    PROJ="${CASE_DIR}/project"
    BIN="${CASE_DIR}/bin"
    CALLS="${CASE_DIR}/calls.log"
    mkdir -p "${PROJ}" "${BIN}"
    : > "${CALLS}"
    ln -s "$(command -v cat)" "${BIN}/cat"
    ln -s "$(command -v timeout)" "${BIN}/timeout"
}

# stub NAME [EXIT_CODE] — fake toolchain binary that logs its argv and exits.
stub() {
    local name="$1"
    local code="${2:-0}"
    printf '#!%s\nprintf "%%s\\n" "%s $*" >> "%s"\nexit %d\n' \
        "${BASH_BIN}" "${name}" "${CALLS}" "${code}" > "${BIN}/${name}"
    chmod +x "${BIN}/${name}"
}

# run_hook [ENV=VAL ...] — run the hook in the case's project with the case's PATH.
run_hook() {
    (cd "${PROJ}" && printf '%s' "${EVENT}" | env PATH="${BIN}" "$@" "${BASH_BIN}" "${HOOK}")
}

# check NAME EXPECTED_EXIT EXPECTED_CALLS ACTUAL_EXIT
check() {
    local name="$1"
    local want_exit="$2"
    local want_calls="$3"
    local got_exit="$4"
    local got_calls
    got_calls="$(cat "${CALLS}")"
    if [[ "${got_exit}" -ne "${want_exit}" ]]; then
        record "${name}" no "expected exit ${want_exit}, got ${got_exit}"
    elif [[ "${got_calls}" != "${want_calls}" ]]; then
        record "${name}" no "expected calls '${want_calls}', got '${got_calls}'"
    else
        record "${name}" yes ""
    fi
}

# --- No recognised test setup → silent no-op ---
new_case
out="$(run_hook)"
code=$?
check "no test setup is a no-op" 0 "" "${code}"
if [[ -n "${out}" ]]; then
    record "no test setup prints nothing" no "got output: ${out}"
else
    record "no test setup prints nothing" yes ""
fi

# --- pnpm project → pnpm test, exit code propagated ---
new_case
touch "${PROJ}/package.json" "${PROJ}/pnpm-lock.yaml"
stub pnpm 0
stub npm 0
run_hook >/dev/null
check "pnpm project runs pnpm test" 0 "pnpm test --silent" "$?"

new_case
touch "${PROJ}/package.json" "${PROJ}/pnpm-lock.yaml"
stub pnpm 3
run_hook >/dev/null
check "pnpm test failure propagates exit code" 3 "pnpm test --silent" "$?"

# --- package.json without a pnpm lockfile → npm test ---
new_case
touch "${PROJ}/package.json"
stub pnpm 0
stub npm 0
run_hook >/dev/null
check "package.json without pnpm-lock runs npm test" 0 "npm test --silent" "$?"

# --- Python project → uv run pytest, falling back to bare pytest ---
new_case
touch "${PROJ}/pyproject.toml"
stub uv 0
stub pytest 0
run_hook >/dev/null
check "pyproject.toml with uv runs uv run pytest" 0 "uv run pytest -q" "$?"

new_case
touch "${PROJ}/pytest.ini"
stub pytest 1
run_hook >/dev/null
check "pytest.ini without uv runs pytest, failure propagates" 1 "pytest -q" "$?"

new_case
mkdir -p "${PROJ}/tests"
touch "${PROJ}/tests/test_x.py"
stub pytest 0
run_hook >/dev/null
check "tests/*.py alone is detected as a Python project" 0 "pytest -q" "$?"

# --- Rust and Go projects ---
new_case
touch "${PROJ}/Cargo.toml"
stub cargo 0
run_hook >/dev/null
check "Cargo.toml runs cargo test" 0 "cargo test --quiet" "$?"

new_case
touch "${PROJ}/go.mod"
stub go 0
run_hook >/dev/null
check "go.mod runs go test" 0 "go test ./..." "$?"

# --- Manifest present but toolchain missing → no-op, not a failure ---
new_case
touch "${PROJ}/Cargo.toml"
run_hook >/dev/null
check "Cargo.toml without cargo is a no-op" 0 "" "$?"

# --- COPILOT_HOOK_TEST_TIMEOUT kills a hung test run ---
new_case
touch "${PROJ}/go.mod"
printf '#!%s\nexec %s 10\n' "${BASH_BIN}" "$(command -v sleep)" > "${BIN}/go"
chmod +x "${BIN}/go"
run_hook COPILOT_HOOK_TEST_TIMEOUT=1 >/dev/null
check "hung test run is killed by the timeout" 124 "" "$?"

# --- Summary ---
printf '\n%d/%d passed\n' "$((test_count - fail_count))" "${test_count}"
if [[ ${fail_count} -gt 0 ]]; then
    exit 1
fi
exit 0

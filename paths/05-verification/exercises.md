# 05 — Verification Exercises

## Exercise 5.1 — Read the included hooks (10 min)

Open `.github/hooks/pre-tool-use-lint.json` and `.github/hooks/post-tool-use-test.json`. For each:
- Which tools does it match?
- Is it blocking?
- What's the timeout?
- What command runs?

Then open `scripts/copilot-hooks/lint-changed.sh` and `run-tests.sh`. Trace what they actually do.

**Checkpoint:** you can describe the full chain from "agent edits a file" to "test result reported back".

## Exercise 5.2 — Write a security gate hook (20 min)

Write a `preToolUse` hook that denies any `edit` or `write` tool call targeting paths under `infra/**`. Block via `{"deny": true, "reason": "..."}` on stdout (not exit code). Drop it in `.github/hooks/block-infra.json`.

Test it:
1. Ask the agent: "Add a comment to `infra/main.tf` explaining the VPC CIDR."
2. The hook should fire and block the edit.
3. Confirm in the agent's response.

**Checkpoint:** the hook fires and blocks. The agent reports the failure clearly.

## Exercise 5.3 — Write a test enforcement hook (20 min)

Write a `postToolUse` hook that runs `pytest -q` (or your project's equivalent) after any `.py` file is edited. Set `timeoutSec: 120`. (Note: `postToolUse` cannot literally block; the agent receives the output and reacts. For a hard block on red tests, also add a `preToolUse` hook that checks the last test result and denies further edits if it's red.)

Then deliberately introduce a failing test. Ask the agent to make any small edit. Watch the hook fail and the agent receive the failure.

**Checkpoint:** the agent's next action is to fix the failing test, not to declare success.

## Exercise 5.4 — Pristine output (10 min)

Run your test suite and look at the output. Any warnings? Any deprecation notices? Any "expected error" log lines that aren't actually expected?

Your task: get the output to zero noise. This is harder than it sounds and almost always reveals one or two real problems.

**Checkpoint:** running the suite produces nothing on stderr.

## Lab

Do `labs/lab-04-verification` first.

Then do `labs/lab-05-break-the-hook`. Take it seriously — it is the lab that converts skeptics.

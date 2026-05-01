---
name: spec-driven-dev
description: Drive any non-trivial change through write-spec → review-spec → implement-from-spec, instead of jumping to code.
license: MIT
user-invocable: true
---

# spec-driven-dev

Use when the user asks for any change touching more than one file, or any feature whose behavior is not obvious from a one-line description.

## Why

Jumping to code skips the cheapest place to catch a misunderstanding: before any code exists. A short spec is faster than a wrong implementation.

## Phase 1 — Write the spec

Produce a markdown spec with these sections:

1. **Goal** — one sentence, user-visible outcome.
2. **Non-goals** — what is explicitly out of scope. Prevents drift.
3. **Inputs / outputs** — concrete shapes. JSON, function signatures, CLI flags.
4. **Behavior** — bullet list of what happens, including error cases.
5. **Files touched** — the exact set. New files marked `(new)`.
6. **Test plan** — the tests that prove the goal is met.
7. **Open questions** — anything still ambiguous.

Save the spec to `docs/specs/<short-name>.md`. Stop. Show it to the user.

## Phase 2 — Review the spec

Wait for the user to:
- answer open questions, or
- approve as-is, or
- request changes.

Do not proceed to implementation while open questions exist. Update the spec in place.

## Phase 3 — Implement from spec

1. Re-read the spec. Treat it as the source of truth.
2. Create the test files listed in the test plan. Run them — they should fail.
3. Implement the minimum code to make the tests pass.
4. Run lints and tests. Both must be green and pristine.
5. Update the spec with any deviations forced by reality, with a `## Deviations` section.
6. Show the diff and stop.

## Exit conditions

- Spec exists at `docs/specs/<name>.md`
- All tests in the test plan exist and pass
- Linter is clean
- No files outside `Files touched` were modified
- Any deviations are documented in the spec

## Anti-patterns

- Writing the spec and the code in the same turn
- Vague specs ("handles edge cases", "performs well")
- Drifting beyond `Files touched` mid-implementation without updating the spec

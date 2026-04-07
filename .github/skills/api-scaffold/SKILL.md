---
name: api-scaffold
description: Scaffold a REST API endpoint with input validation, structured error handling, and a passing test before any business logic is written.
license: MIT
user-invocable: true
disable-model-invocation: false
---

# api-scaffold

Use this skill when the user asks to add a new REST endpoint, route, or HTTP handler.

## When to trigger

- "Add an endpoint for X"
- "Create a route to Y"
- "Scaffold a handler that Z"

## Steps

1. **Confirm the contract.** Ask for or infer: HTTP method, path, request schema, response schema, auth requirement, error cases. Do not guess silently — if any field is unclear, ask.
2. **Locate conventions.** Read one existing handler in the project to match style: framework, validation library, error type, logging shape.
3. **Write the test first.** Create a test that asserts:
   - 2xx success path with a valid payload
   - 4xx for each documented validation failure
   - 4xx/401 for the auth failure case if auth is required
   Run the test. Confirm it fails for the right reason (handler does not exist).
4. **Write the handler.** Minimum viable implementation:
   - Parse and validate input at the boundary
   - Catch specific exceptions, never bare catch
   - Return structured error responses matching project convention
   - Log with structured fields, not f-strings
5. **Run the test.** Confirm green.
6. **Run the linter.** Zero warnings.
7. **Show the user the diff** and stop. Do not add unrelated improvements.

## Exit conditions

- Test exists, runs, passes
- Linter clean
- Diff shown
- No files outside the endpoint, its test, and route registration touched

## Anti-patterns

- Adding business logic before the test exists
- Wrapping the entire handler in `try/except Exception`
- Inventing validation rules the user did not specify
- "While I'm here" cleanup of nearby code

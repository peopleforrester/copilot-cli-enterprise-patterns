# Capstone — Spec-Driven Feature, End to End

**Time:** 60–90 minutes
**Pillars:** all four

## Scenario

You are adding a real feature to a real (sample) project, end to end, using everything from the course:

- Pillar 1 — manage context, `/clear` between phases
- Pillar 2 — Plan Mode and a written spec
- Pillar 3 — externalized standards via `AGENTS.md` and Skills
- Pillar 4 — hooks enforce lint and test

## The feature

Add an **API key authentication layer** to a small FastAPI service. Requirements:

1. New endpoint `POST /api-keys` (admin only) creates an API key, returns it once, stores a hash.
2. Existing endpoints accept `Authorization: Bearer <api-key>` headers and reject anything else with 401.
3. Rate limiting on the auth check itself (to prevent brute force) — 10 attempts per IP per minute.
4. Audit log entry on each successful and failed auth attempt.
5. Migration to add the `api_keys` table.
6. Tests cover happy path, missing header, invalid key, expired key, rate limit, and admin-only creation.

## Required workflow

You must do this in five phases. Do not skip phases. Do not skip the `/clear` between phases.

### Phase 1 — Spec

- Use the `spec-driven-dev` Skill.
- Output: `docs/specs/api-key-auth.md`
- Stop. Get the spec right before any code.

### Phase 2 — Migration

- `/clear`. Reload the spec.
- Plan, then execute the migration.
- Hooks should run lint and any migration tests.

### Phase 3 — Auth check + endpoints

- `/clear`. Reload the spec.
- Plan, then execute the auth middleware and the protected endpoints.
- Hooks enforce the test loop.

### Phase 4 — Rate limit + audit log

- `/clear`. Reload the spec.
- Plan, then execute.

### Phase 5 — Code review + commit

- Use the Code Review subagent against the diff.
- Address findings.
- `/diff`. Commit. Push to `staging`. Open PR.

## Success criteria

- [ ] Spec exists at `docs/specs/api-key-auth.md` and matches the final implementation
- [ ] Each phase has its own commit
- [ ] All tests pass with pristine output
- [ ] Hooks ran on every edit (you can confirm in the session transcript)
- [ ] No production secrets in any committed file
- [ ] Code Review subagent's findings are either addressed or explicitly noted as deferred with rationale

## Anti-patterns to avoid

- Doing all five phases in a single chat session without `/clear`
- Skipping the spec because "I know what I want to build"
- Letting the agent skip a failing test "for now"
- Adding scope the spec didn't authorize ("while we're in here, let's also...")
- Disabling a hook because it was inconvenient

## Debrief (30 min, in pairs if possible)

- Which phase was hardest?
- Where did the spec save you from a wrong turn?
- Where did a hook catch something you would have missed?
- What would you do differently on the next feature?
- Which rule in your team's existing `AGENTS.md` should now become a hook?

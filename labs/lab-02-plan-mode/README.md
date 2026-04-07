# Lab 02 — Plan Mode Pushback

**Time:** 30 minutes
**Pillar:** 2 (Plan Before Code)

## Scenario

A product manager files this request:

> "Add rate limiting to the public API. Default 100 requests per minute per IP."

It sounds simple. It isn't. Your job is to drive this through Plan Mode and produce a plan that handles the questions the PM didn't answer.

## Your task

Use Plan Mode to produce a plan that explicitly addresses every issue in the "Hidden questions" list below — even ones the PM didn't think of. Do not write any code in this lab.

## Steps

1. Enter Plan Mode (`Shift+Tab`).
2. Paste the PM request.
3. Read the first plan the agent produces.
4. Walk the "Hidden questions" list. For each question the plan does not address, push back specifically: "What about X?"
5. Iterate until the plan addresses every item.
6. Save the final plan as `docs/specs/rate-limiting.md`.

## Hidden questions

- Per-IP only, or per-API-key when authenticated?
- Storage: in-memory (single instance) or distributed (Redis)?
- What happens to the existing IPs already over the limit at deploy time?
- Burst handling: hard cap or token bucket?
- Response when limited: 429 with `Retry-After`? Custom error body?
- Whitelist for internal services / health checks?
- Test plan: how do you simulate 101 requests per minute in a unit test?
- Observability: how does oncall see "we are rate-limiting people"?
- Rollout: feature flag, gradual percentage, or all at once?
- Documentation: who tells API consumers this changed?

## Success criteria

- [ ] Final plan addresses all 10 hidden questions
- [ ] Final plan lists specific files to touch
- [ ] Final plan has a concrete test plan
- [ ] You did not write any code

## Debrief questions

- Which hidden questions did the agent surface unprompted? Which did it miss?
- How long did the plan take vs how long the implementation would have taken if you'd skipped planning and discovered these mid-build?
- Which hidden questions are about *the code* and which are about *the rollout*? Plan Mode tends to be better at the first kind. Why?

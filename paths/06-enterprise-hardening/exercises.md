# 06 — Enterprise Hardening Exercises

## Exercise 6.1 — Proxy dry run (15 min)

Even if you don't use a proxy: set `HTTPS_PROXY=http://localhost:9999` (a port nothing listens on). Launch Copilot CLI. Note the failure mode.

Now unset and try again. Document the difference for your team's runbook — this is what new developers will see when their proxy config is wrong.

## Exercise 6.2 — Build the security review packet (30 min)

Imagine your security team needs a one-page document covering:
- What data leaves the network when Copilot CLI runs
- Where it goes
- Retention guarantees
- How telemetry is disabled
- What deny rules are in place
- How code review and audit logging work for AI-authored commits

Draft it. Use `enterprise/restricted-environment.md` and `enterprise/security-deny-rules.md` as inputs. Save to `docs/security-review.md` in your project.

**Checkpoint:** the doc is short, factual, and would survive contact with a skeptical CISO.

## Exercise 6.3 — Onboard a fictional new developer (15 min)

Write a single shell script that:
1. Copies user-level instructions and settings to `~/.copilot/` (or `$COPILOT_HOME` if set)
2. Copies user-level Skills
3. Verifies `gh auth status` is authenticated against your GHE host
4. Prints next-step instructions

Save it as `scripts/onboard.sh`. Run it on a fresh machine (or a fresh user account) to test.

**Checkpoint:** a new dev can be productive in under 15 minutes.

## Exercise 6.4 — Pick the right tool (20 min)

You're advising three teams. For each, recommend Copilot CLI, Claude Code, both, or neither — with reasoning:

1. A 200-engineer org standardised on GitHub Enterprise Cloud, no Anthropic vendor relationship.
2. A 5-person startup, no enterprise constraints, very price-sensitive.
3. A regulated bank with on-prem GHES and an air-gapped development environment.

Compare your answers against `enterprise/copilot-vs-claude-code.md` after.

## Capstone

Do `labs/capstone-spec-driven`. Plan to spend 60–90 minutes.

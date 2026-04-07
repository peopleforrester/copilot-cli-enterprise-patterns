# 06 — Enterprise Hardening

**Time:** 90 minutes
**Pillars:** all four
**Lab:** `labs/capstone-spec-driven`

## What you'll learn

- How to configure Copilot CLI for restricted environments
- The deny-list philosophy and how to extend it
- GHEC vs GHES considerations
- Audit and telemetry for security review boards
- How to onboard a new team without it becoming a perpetual help desk

## Read first

- `enterprise/restricted-environment.md`
- `enterprise/github-enterprise-config.md`
- `enterprise/security-deny-rules.md`
- `enterprise/copilot-vs-claude-code.md`
- `reference/opentelemetry.md`
- `reference/plugins-marketplaces.md`
- `reference/cloud-delegation.md`
- `patterns/autopilot-mode.md`

## New surface areas (v1.0.18)

Enterprise rollouts in April 2026 need to account for four things that didn't exist in older courses:

1. **Autopilot mode** — the third `Shift+Tab` mode. High productivity, high blast radius. Only safe on repos with the verification pillar fully wired. See `patterns/autopilot-mode.md`.
2. **Cloud delegation** (`&` prefix, `/delegate`, `/tasks`, `/resume`) — agent work runs on a GitHub Actions runner and comes back as a draft PR. Governance lives in the Copilot admin console. See `reference/cloud-delegation.md`.
3. **Plugins and marketplaces** — `awesome-copilot` is the default marketplace. Enterprises should run their own vetted marketplace. Plugin hooks execute arbitrary shell — audit before install. See `reference/plugins-marketplaces.md`.
4. **OpenTelemetry** — Copilot CLI emits GenAI Semantic Convention spans via OTLP. Content capture is off by default. This is your observability story for security review boards. See `reference/opentelemetry.md`.

## Why this matters

Most courses stop at "here's how to use the tool". For enterprise teams, that's the easy part. The hard part is: what does security need to sign off on, what do you tell the audit team, what happens when the proxy strips TLS, and how do you keep ten developers from each writing their own slightly different `AGENTS.md`.

## Exit criteria

- [ ] You can configure Copilot CLI for a proxied environment with a corporate root CA
- [ ] You can produce the deny rules your security team will ask for
- [ ] You can answer "why Copilot CLI vs Claude Code" honestly to a skeptical engineering manager
- [ ] You can describe the audit trail for any code change made via Copilot CLI
- [ ] You can explain when Autopilot is appropriate and what the enforcement floor is
- [ ] You can wire OTel export to an OTLP endpoint and name the six dashboards worth building
- [ ] You can explain the plugin trust boundary to a security reviewer

## Capstone

Do `labs/capstone-spec-driven`. It uses everything from all six modules end-to-end.

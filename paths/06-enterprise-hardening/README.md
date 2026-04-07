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

## Why this matters

Most courses stop at "here's how to use the tool". For enterprise teams, that's the easy part. The hard part is: what does security need to sign off on, what do you tell the audit team, what happens when the proxy strips TLS, and how do you keep ten developers from each writing their own slightly different `AGENTS.md`.

## Exit criteria

- [ ] You can configure Copilot CLI for a proxied environment with a corporate root CA
- [ ] You can produce the deny rules your security team will ask for
- [ ] You can answer "why Copilot CLI vs Claude Code" honestly to a skeptical engineering manager
- [ ] You can describe the audit trail for any code change made via Copilot CLI

## Capstone

Do `labs/capstone-spec-driven`. It uses everything from all six modules end-to-end.

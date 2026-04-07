---
marp: true
title: Enterprise Hardening
paginate: true
---

# Pillar All — Enterprise Hardening

The hard parts aren't the keystrokes.

---

## What enterprises actually ask

- "Where does our code go when the agent runs?"
- "Can we run this on GHES?"
- "What does the deny list cover?"
- "How do we audit AI-authored commits?"
- "What's the cost model?"
- "Why this and not Claude Code?"

---

## Network and proxies

- Outbound HTTPS to `api.githubcopilot.com` and your GHE host
- Honors `HTTPS_PROXY`, `HTTP_PROXY`, `NO_PROXY`
- Corporate root CA via `NODE_EXTRA_CA_CERTS`
- No on-prem inference path — fully air-gapped is not supported

---

## GHEC vs GHES

| | GHEC | GHES |
|---|---|---|
| Hosting | github.com | Self-hosted |
| Setup | Org admin enables Copilot | GHES version must support Copilot |
| Auth | github.com / SSO | Your GHES auth |
| MCP host | github.com | Your enterprise host |

Verify support matrix before assuming.

---

## The deny list

- Destructive shell (`rm -rf /`, `chmod 777`, `sudo *`)
- Remote execution (`curl ... | sh`)
- Force-push to protected branches
- Publish commands (`npm publish`, `docker push`, etc.)
- Cloud destruction (`terraform destroy`, `kubectl delete`)
- Secret reads (`.env`, `.pem`, `credentials*`)
- IaC and CI/CD edits

---

## The ask list (vs deny)

Some things are legitimate but high-impact. Don't deny — *ask*.

- `git push *`
- `git merge *`
- `git rebase *`
- `gh pr merge *`
- `gh release *`

Operator approves once, in context, operation proceeds.

---

## Audit trail

- Commits and pushes show up in GitHub's audit log
- Session logs may contain source code → treat as code-sensitive
- Telemetry off in `settings.json`
- Org-level policies override user settings — check both

---

## Why Copilot CLI vs Claude Code

The honest answer in `enterprise/copilot-vs-claude-code.md`. Short version:

- **Copilot CLI** — already in your GitHub bill, GitHub MCP built in, works with org SSO out of the box
- **Claude Code** — separate vendor relationship, sometimes ahead on Anthropic-specific features
- Both run Claude Sonnet 4.6 by default. The mental model is identical.

---

## Capstone

End-to-end feature with all four pillars, five enforced phases, code review, hooks running on every edit.

→ `labs/capstone-spec-driven/`

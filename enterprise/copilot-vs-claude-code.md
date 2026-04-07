# Copilot CLI vs Claude Code

You will be asked this question. Here is the honest answer.

## Both run the same model by default

Both Copilot CLI and Claude Code default to a **Claude Sonnet** model (Sonnet 4.5 in Copilot CLI as of April 2026; both 4.5 and 4.6 are 1×). The mental model — the Four Pillars, plan mode, Skills, hooks, MCPs — is identical. Most of what you learn in one transfers to the other.

The differences are about **packaging, contracting, and integration**, not model quality.

## Where Copilot CLI wins

- **Already on the GitHub bill.** If your org pays for GitHub Enterprise + Copilot, Copilot CLI is included. No new vendor contract.
- **GitHub MCP built in.** Issues, PRs, branches, releases as native tools without configuration.
- **GHEC and GHES support.** Works with self-hosted GitHub Enterprise Server (within the supported version matrix).
- **Org-level policy controls.** Public code matching, suggestions filtering, telemetry — administered through your existing GitHub org settings.
- **Multi-model.** First-class `/model` switching to GPT-5.3-Codex and Gemini 3 Pro alongside Claude Opus and Sonnet.
- **SSO out of the box.** SAML / SCIM if your org is already using them with GitHub.

## Where Claude Code wins

- **Anthropic-first feature timing.** New Anthropic capabilities tend to land in Claude Code first, sometimes by weeks or months.
- **Cleaner extended thinking story.** The thinking surface is more directly exposed for debugging agent reasoning.
- **Less abstraction between you and the model.** Fewer layers of middleware between your prompt and the inference call.
- **Better positioned for non-GitHub workflows.** If your code lives on GitLab, Bitbucket, or self-hosted Forgejo, Claude Code is less assumptive about where your repo is.

## Where they're effectively tied

- Plan mode (`Shift+Tab` in both)
- Skills format (`SKILL.md` works in both)
- Hook concepts (lifecycle events in both, with format differences — Copilot CLI uses `preToolUse` / `postToolUse` and 6 more, blocking via `{"deny": true}` on stdout)
- Subagents
- MCP support
- Model quality on Sonnet (it is literally the same model)

## Honest recommendation

| Situation | Pick |
|---|---|
| You're already paying for GitHub Enterprise | **Copilot CLI** — no new contract, no procurement cycle |
| Your code lives on GitHub and your developers live in GitHub PRs | **Copilot CLI** — the GitHub MCP integration is the win |
| You have a direct Anthropic relationship and want first-mover access to new Anthropic features | **Claude Code** |
| You're on GitLab, Bitbucket, or Forgejo | **Claude Code** |
| You want to A/B test models against each other | **Copilot CLI** — `/model` switching is more developed |
| You're a five-person startup with no enterprise constraints | Either. Pick the one whose defaults you like more after a week of dogfooding. |
| You're an air-gapped regulated environment | Neither (yet). No on-prem inference path for either. |

## What both of them are not

- A replacement for understanding your codebase
- A junior engineer you can ignore
- A way to skip code review
- A way to skip writing tests
- A vendor lock-in trap (your code is yours, your skills are portable, your hooks are shell scripts)

## A note on framing

Stop framing this as a competition. Both are delivery vehicles for the same underlying capability. The question is not "which is better" — it's "which fits the way your org already operates". Pick one, get good at it, and don't waste time on tool tribalism.

The patterns in this repo work in both. That is the point.

# copilot-cli-enterprise-patterns

Reference patterns for configuring **GitHub Copilot CLI** for enterprise engineering teams operating in restricted environments.

This repo is not a tutorial. It is a working set of configs, hooks, skills, and instructions you can clone, adapt, and put into production.

---

## What this is

A practitioner reference for teams adopting Copilot CLI under real enterprise constraints: GitHub Enterprise (Cloud or Server), restricted internet, security review requirements, and deterministic verification needs.

Copilot CLI runs **Claude Sonnet** by default — the same Anthropic model that powers Claude Code. You can switch to Opus 4.6, GPT-5.3-Codex, or Gemini 3 Pro via `/model`. The mental model, commands, and externalization patterns map directly across agentic CLIs, which is why these patterns transfer.

---

## The Four Pillars → Copilot CLI

| Pillar | Principle | Copilot CLI Mechanism |
|---|---|---|
| 1. Manage Context | Keep the working window relevant | Auto-compaction at 95%, `/clear`, `/usage`, subagents (Explore, Plan, Code Review) |
| 2. Plan Before Code | Decide the approach before writing | `Shift+Tab` plan mode, `/plan` command, review-then-execute |
| 3. Externalize Decisions | Move standards out of prompts | `AGENTS.md`, `.github/copilot/instructions.md`, Skills (`SKILL.md`), repository memory |
| 4. Verify Output | Trust deterministic checks, not vibes | `PreToolUse` / `PostToolUse` hooks, `/diff`, built-in Code Review agent |

> Advisory instructions work ~80% of the time. Deterministic verification works 100%.

---

## Quick start

```bash
git clone git@github.com:peopleforrester/copilot-cli-enterprise-patterns.git
cd copilot-cli-enterprise-patterns

# Apply user-level Copilot config
mkdir -p ~/.config/copilot
cp .github/copilot/instructions.md ~/.config/copilot/instructions.md
cp .github/copilot/settings.json   ~/.config/copilot/settings.json

# Project-level instructions stay in the repo
# AGENTS.md is auto-loaded by Copilot CLI on session start

# Hooks
cp .github/hooks/*.json ~/.config/copilot/hooks/

# Skills (per-user)
mkdir -p ~/.config/copilot/skills
cp -r .github/skills/* ~/.config/copilot/skills/
```

Then launch Copilot CLI in any repo and the patterns are active.

---

## Repo layout

```
.
├── README.md                          Overview + Four Pillars
├── AGENTS.md                          Project-level instructions (loaded every session)
├── .github/
│   ├── copilot/
│   │   ├── instructions.md            User-level custom instructions
│   │   └── settings.json              Security deny rules
│   ├── hooks/
│   │   ├── pre-tool-use-lint.json     Auto-lint before file edits
│   │   └── post-tool-use-test.json    Auto-test after file changes
│   └── skills/
│       ├── api-scaffold/SKILL.md
│       ├── docker-review/SKILL.md
│       └── spec-driven-dev/SKILL.md
├── patterns/
│   ├── four-pillars-copilot-cli.md
│   ├── context-management.md
│   ├── plan-mode-workflow.md
│   ├── externalization-patterns.md
│   └── verification-patterns.md
├── enterprise/
│   ├── restricted-environment.md
│   ├── github-enterprise-config.md
│   └── security-deny-rules.md
└── LICENSE
```

---

## About

These patterns were developed through daily use of agentic CLI tools and validated against vendor best practices. The author trains enterprise engineering teams on agentic CLI workflows. No pitches, just practice.

## License

MIT — see [LICENSE](LICENSE).

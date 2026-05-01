# copilot-cli-enterprise-patterns

Reference patterns for configuring **GitHub Copilot CLI** for enterprise engineering teams operating in restricted environments.

This repo is not a tutorial. It is a working set of configs, hooks, skills, and instructions you can clone, adapt, and put into production.

---

## What this is

A practitioner reference for teams adopting Copilot CLI under real enterprise constraints: GitHub Enterprise (Cloud or Server), restricted internet, security review requirements, and deterministic verification needs.

Copilot CLI runs **Claude Sonnet 4.5** by default — the same Anthropic model family that powers Claude Code. You can switch to Sonnet 4.6, Opus 4.6, Haiku 4.5, GPT-5.x, Gemini 3 Pro/Flash, or free models (GPT-5 mini, GPT-4.1, GPT-4o) via `/model`. The mental model, commands, and externalization patterns map directly across agentic CLIs, which is why these patterns transfer.

---

## The Four Pillars → Copilot CLI

| Pillar | Principle | Copilot CLI Mechanism |
|---|---|---|
| 1. Manage Context | Keep the working window relevant | Auto-compaction at 95%, `/clear`, `/usage`, subagents (Explore, Plan, Code Review) |
| 2. Plan Before Code | Decide the approach before writing | `Shift+Tab` plan mode, `/plan` command, review-then-execute |
| 3. Externalize Decisions | Move standards out of prompts | `AGENTS.md`, `.github/copilot/instructions.md`, Skills (`SKILL.md`), repository memory |
| 4. Verify Output | Trust deterministic checks, not vibes | `preToolUse` (only blocking event) / `postToolUse` hooks, `/diff`, Code Review + Critic subagents |

> Advisory instructions work ~80% of the time. Deterministic verification works 100%.

---

## Quick start

Fork this repo, then:

```bash
git clone git@github.com:<your-fork>/copilot-cli-enterprise-patterns.git
cd copilot-cli-enterprise-patterns

# Apply user-level Copilot config
mkdir -p ~/.copilot ~/.copilot/hooks ~/.copilot/skills
cp .github/copilot/instructions.md ~/.copilot/copilot-instructions.md
cp .github/copilot/settings.json   ~/.copilot/config.json

# Project-level instructions stay in the repo
# AGENTS.md is auto-loaded by Copilot CLI on session start

# Hooks
cp .github/hooks/*.json ~/.copilot/hooks/

# Skills (per-user)
cp -r .github/skills/* ~/.copilot/skills/
```

Then launch Copilot CLI in any repo and the patterns are active.

---

## Repo layout

```text
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

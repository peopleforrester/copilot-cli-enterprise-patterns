---
marp: true
title: Foundations — Copilot CLI Enterprise Patterns
paginate: true
---

# Copilot CLI: Foundations

The mental model before the keystrokes.

<!-- 5 min: framing. The point of this module is to set expectations. -->

---

## What Copilot CLI is

- An **agentic** CLI: plans, acts, observes, adapts
- Default model: **Claude Sonnet 4.6** (same Anthropic model as Claude Code)
- Switch via `/model` to Opus 4.6, GPT-5.3-Codex, Gemini 3 Pro
- Built-in GitHub MCP — issues, PRs, branches as native tools

<!-- Stress: agentic, not autocomplete. The mental model matters more than the syntax. -->

---

## What it isn't

- Not autocomplete
- Not a chatbot wired to a terminal
- Not a substitute for understanding your code
- Not a junior engineer you can ignore

---

## The Four Pillars

1. **Manage Context**
2. **Plan Before Code**
3. **Externalize Decisions**
4. **Verify Output**

> Tool-agnostic. Map directly across Claude Code, Copilot CLI, and any future agentic CLI.

---

## Why pillars, not tips

- "Tips" don't compose. Pillars do.
- Each pillar has one principle and several mechanisms.
- When something goes wrong, you can name which pillar failed.
- New tooling slots in under existing pillars without rewriting your habits.

---

## Pillar 1 — Manage Context

Context is RAM. Treat it like RAM.

- Auto-compaction at 95% (it loses detail)
- `/clear` between unrelated tasks
- Subagents for searches
- Targeted reads, not whole files

---

## Pillar 2 — Plan Before Code

The cheapest defect is one that exists only in a plan.

- `Shift+Tab` enters Plan Mode
- Read plans critically
- Specs for work that outlives the chat

---

## Pillar 3 — Externalize Decisions

If you tell it twice, write it down.

- `AGENTS.md` per project
- `instructions.md` per user
- Skills for workflows
- Memory for accumulated learnings
- **Hooks for rules that must hold**

---

## Pillar 4 — Verify Output

> Advisory works ~80%. Deterministic works 100%.

- `PreToolUse` / `PostToolUse` hooks
- `/diff` before commit
- Code Review subagent
- Pristine test output

---

## The four reflexes

1. `Shift+Tab` first — for any change touching >1 file
2. `/clear` between unrelated tasks
3. `/diff` before every commit
4. **Hooks decide. Instructions advise.**

---

## What's next

- Module 02 — Context Management (and Lab 01)
- Then 03 → Plan Mode
- Then 04 → Externalization
- Then 05 → Verification
- Then 06 → Enterprise Hardening
- Capstone — end-to-end feature with all four pillars

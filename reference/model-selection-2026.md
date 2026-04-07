# Model Selection — April 2026

Copilot CLI ships with **Claude Sonnet 4.5** as the default and supports switching to other frontier models via `/model`. This page is the practical decision guide.

> Models, multipliers, and pricing change. Verify against the live Copilot docs before quoting these in a procurement conversation.

## The roster

### Default

| Model | ID | Multiplier | Notes |
|---|---|---|---|
| **Claude Sonnet 4.5** | `claude-sonnet-4-5` | **1×** | **Default.** ~95% of Opus's coding ability at a fraction of the cost. |

### Premium models

| Model | Multiplier | Strengths |
|---|---|---|
| Claude Sonnet 4.6 | 1× | Latest Anthropic Sonnet — try alongside 4.5 for your workload |
| Claude Opus 4.6 | Premium | Deepest reasoning. Best for multi-file refactors, security audits, long autonomous runs. |
| Claude Haiku 4.5 | Low | Fastest, cheapest. Single-file edits, scaffolding. |
| GPT-5 | Premium | Deep reasoning |
| GPT-5.3-Codex | Premium | Code-optimised |
| GPT-5.4 | Premium | Added March 2026 |
| GPT-5.4-mini | Premium | Student auto-selection |
| Gemini 2.5 Pro | Premium | Million-token context |
| Gemini 3 Pro | Premium | GCP-hosted |
| Gemini 3 Flash | Premium | Fast, multimodal |
| o4-mini | Premium | Reasoning |

### Free models (0× on paid plans)

- **GPT-5 mini**
- **GPT-4.1**
- **GPT-4o**
- **Grok Code Fast 1**
- **Raptor mini**

These don't draw down your premium request budget. Useful for high-volume routine work where Sonnet would be overkill.

## Auto routing

When `/model` is set to **Auto**, Copilot CLI routes across eligible models intelligently and applies a **10% premium multiplier discount** to whatever it picks. If you trust the routing for your workload, Auto is the cheapest path to "good enough" model selection.

## Decision table

| Task | Model |
|---|---|
| One-line bug fix, doc typo, scaffolding | Haiku 4.5 (or a free model) |
| High-volume routine work where free models suffice | GPT-5 mini, GPT-4.1, or GPT-4o (free tier) |
| Standard feature work, daily TDD cycles | **Sonnet 4.5** (default) |
| Multi-file refactor (>10 files), dependency mapping | Opus 4.6 |
| Security audit, architecture review | Opus 4.6 |
| Long autonomous run (multi-hour) | Opus 4.6 |
| Reading a PDF or screenshot | Gemini 3 Flash or 3 Pro |
| Tight inner-loop JS/TS codegen | Sonnet 4.5 or GPT-5.3-Codex (try both) |
| "Don't make me think about it" | **Auto** (10% discount, intelligent routing) |

## How to switch

```text
/model
```
Interactive picker with **Available / Blocked / Upgrade** tabs.

```text
/model claude-opus-4-6
```
Switches for the current session.

Alternatives:
- `--model MODEL_STRING` flag at launch
- `COPILOT_MODEL` environment variable
- `~/.copilot/config.json` → `"model": "..."` for the persistent default
- `.github/copilot/settings.json` → `"model": "..."` for the project default

## Reasoning effort

Some models support adjustable reasoning depth via `--reasoning-effort` (alias `--effort`). Higher effort = more thinking time, more tokens, deeper answers. Use for hard problems; default for routine work.

## Cost intuition

Order of magnitude only — check current pricing:

- Free tier (`gpt-5-mini`, `gpt-4.1`, `gpt-4o`, etc.) ≈ 0× on paid plans
- Haiku ≈ 1× (low multiplier)
- **Sonnet 4.5 / 4.6 ≈ 1×** (default)
- Opus 4.6 ≈ premium (substantially higher)

For most teams the right ratio is roughly **70% Sonnet / 20% free-or-Haiku / 10% Opus**, with Opus reserved for the situations where it earns the cost.

## What *not* to do

- **Don't switch to Opus "just to be safe."** The over-thinking on trivial tasks costs more than it saves.
- **Don't switch models mid-task without `/clear` first.** The new model inherits a context shaped by the previous model's choices.
- **Don't trust benchmarks over your own dogfooding.** Run the same week of real work on Sonnet 4.5, 4.6, and Auto, then decide.
- **Don't ignore the free tier.** A GPT-4o pass on routine work for free is worth knowing about.

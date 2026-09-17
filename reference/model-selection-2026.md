# Model Selection — September 2026

Copilot CLI ships with **Claude Sonnet 4.6** as the default and supports switching to other frontier models via `/model`. This page is the practical decision guide, current as of Copilot CLI v1.0.85.

> Models, multipliers, and pricing change. Verify against the live Copilot docs before quoting these in a procurement conversation.
>
> **Retired September 1, 2026:** Claude Opus 4.5, Opus 4.6, and Sonnet 4.5 are gone. If a config or `.agent.md` still pins one, `/model` falls back and the pin fails silently. Search your repos for hardcoded model IDs and move Sonnet 4.5 → 4.6 and Opus 4.5/4.6 → Opus 5.

## The roster

### Default

| Model | ID | Multiplier | Notes |
|---|---|---|---|
| **Claude Sonnet 4.6** | `claude-sonnet-4-6` | **1×** | **Default.** Strong agentic coding at a fraction of Opus's cost. Replaced Sonnet 4.5 (retired 2026-09-01) as the default. |

### Premium models

| Model | Multiplier | Strengths |
|---|---|---|
| Claude Opus 5 | Premium | **Deepest reasoning.** Current flagship. Best for multi-file refactors, security audits, long autonomous runs. |
| Claude Opus 4.8 | Premium | Prior Opus generation — still strong; fast-mode variant available (preview). Opus 5 supersedes it. |
| Claude Opus 4.7 | Premium | Older Opus generation, still available |
| Claude Sonnet 5 | 1× | Newest Sonnet — try alongside 4.6 for your workload |
| Claude Fable 5.1 | Premium | Newest Anthropic family — evaluate against Opus/Sonnet for your workload |
| Claude Haiku 4.5 | Low | Fastest, cheapest. Single-file edits, scaffolding. |
| GPT-6 Astra | Premium | Latest OpenAI flagship (GA September 2026) |
| GPT-5.6 (Luna/Sol/Terra) | Premium | Deep reasoning |
| GPT-5.5 | Premium | Deep reasoning |
| GPT-5.3-Codex | Premium | Code-optimised |
| GPT-5 mini / 5.4 nano | Low | Fast, cheap, high-volume routine work |
| Gemini 3.8 Flash | Premium | Fast, multimodal, latest Gemini (September 2026) |
| Gemini 3.5–3.7 Flash | Premium | Prior Gemini Flash generations |

### Free models (0× on paid plans)

- **GPT-5 mini**
- **GPT-4.1**
- **Raptor mini** (fine-tuned GPT-5 mini, preview)

These don't draw down your premium request budget. Useful for high-volume routine work where Sonnet would be overkill.

## Auto routing

When `/model` is set to **Auto**, Copilot CLI routes across eligible models intelligently and applies a **10% premium multiplier discount** to whatever it picks. If you trust the routing for your workload, Auto is the cheapest path to "good enough" model selection.

## Decision table

| Task | Model |
|---|---|
| One-line bug fix, doc typo, scaffolding | Haiku 4.5 (or a free model) |
| High-volume routine work where free models suffice | GPT-5 mini or GPT-4.1 (free tier) |
| Standard feature work, daily TDD cycles | **Sonnet 4.6** (default) |
| Multi-file refactor (>10 files), dependency mapping | Opus 5 |
| Security audit, architecture review | Opus 5 |
| Long autonomous run (multi-hour) | Opus 5 |
| Reading a PDF or screenshot | Gemini 3.8 Flash |
| Tight inner-loop JS/TS codegen | Sonnet 4.6 or GPT-5.3-Codex (try both) |
| "Don't make me think about it" | **Auto** (10% discount, intelligent routing) |

## How to switch

```text
/model
```

Interactive picker with **Available / Blocked / Upgrade** tabs.

```text
/model claude-opus-5
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

- Free tier (`gpt-5-mini`, `gpt-4.1`, etc.) ≈ 0× on paid plans
- Haiku ≈ 1× (low multiplier)
- **Sonnet 4.6 ≈ 1×** (default)
- Opus 4.7 / 4.8 / 5 ≈ premium (substantially higher)

For most teams the right ratio is roughly **70% Sonnet / 20% free-or-Haiku / 10% Opus**, with Opus reserved for the situations where it earns the cost.

## What *not* to do

- **Don't switch to Opus "just to be safe."** The over-thinking on trivial tasks costs more than it saves.
- **Don't switch models mid-task without `/clear` first.** The new model inherits a context shaped by the previous model's choices.
- **Don't trust benchmarks over your own dogfooding.** Run the same week of real work on Sonnet 4.6, Opus 5, and Auto, then decide.
- **Don't ignore the free tier.** A GPT-4.1 pass on routine work for free is worth knowing about.

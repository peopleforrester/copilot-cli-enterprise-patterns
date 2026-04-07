# Model Selection — April 2026

Copilot CLI ships with **Claude Sonnet 4.6** as the default and supports switching to other frontier models via `/model`. This page is the practical decision guide.

> Models and pricing change. Verify against the live Copilot docs before quoting these in a procurement conversation.

## The roster

| Model | ID (as exposed in `/model`) | Provider | Strengths | Weaknesses |
|---|---|---|---|---|
| **Claude Sonnet 4.6** | `claude-sonnet-4-6` | Anthropic | Default for a reason: ~95% of Opus coding ability at a fraction of the cost. Strong tool use, strong instruction following. | Slower than Haiku for trivial edits. |
| Claude Opus 4.6 | `claude-opus-4-6` | Anthropic | Deepest reasoning. Best for multi-file refactors with dependency chains, security audits, architecture decisions, long autonomous runs. Lowest over-refusal rate. | More expensive; overkill for routine work. |
| Claude Haiku 4.5 | `claude-haiku-4-5-20251001` | Anthropic | Fastest, cheapest. Single-file edits, scaffolding, doc fixes. | Less capable on multi-step plans. |
| GPT-5.3-Codex | `gpt-5-3-codex` | OpenAI | Strong on tight-loop code generation, especially in JS/TS ecosystems. | Different tool-use idioms; some Skills written for Anthropic models behave differently. |
| Gemini 3 Pro | `gemini-3-pro` | Google | Long context, multimodal (helpful when reading PDFs of specs or screenshots). | Tool use can be less consistent than Sonnet. |

## Decision table

| Task | Model |
|---|---|
| One-line bug fix, doc typo, scaffolding | Haiku 4.5 |
| Standard feature work, daily TDD cycles | **Sonnet 4.6** (default) |
| Multi-file refactor (>10 files), dependency mapping | Opus 4.6 |
| Security audit, architecture review | Opus 4.6 |
| Long autonomous run (multi-hour) | Opus 4.6 |
| Reading a PDF spec or annotated screenshot | Gemini 3 Pro |
| Tight inner-loop JS/TS codegen | Sonnet 4.6 or GPT-5.3-Codex (try both, pick what your team prefers) |

## How to switch

```text
/model
```
Lists available models and shows the current one.

```text
/model claude-opus-4-6
```
Switches for the current session. The next `/clear` does *not* reset the model — it persists for the session lifetime.

To make a model the persistent default, set it in `~/.config/copilot/settings.json`:

```json
{
  "model": { "default": "claude-sonnet-4-6" }
}
```

## Cost intuition

Order of magnitude only — check current pricing:

- Haiku ≈ 1×
- Sonnet ≈ 5×
- Opus ≈ 25×

For most teams the right ratio is roughly **70% Sonnet / 20% Haiku / 10% Opus**, with Opus reserved for the situations where it earns the cost (deep refactors, audits, long runs).

## What *not* to do

- **Don't switch to Opus "just to be safe."** The over-refusal and over-thinking on trivial tasks costs more than it saves.
- **Don't switch models mid-task** unless you `/clear` first. The new model inherits a context shaped by the previous model's choices.
- **Don't trust benchmarks over your own dogfooding.** Run the same week of real work on Sonnet and Opus for your codebase, then decide.

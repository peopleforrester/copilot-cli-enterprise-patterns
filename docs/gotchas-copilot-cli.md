# Gotchas — Copilot CLI

Vendor-doc-vs-reality deltas. Things that surprised me or my learners. Updated as new ones surface.

## Authentication

- **GHES users:** `gh auth login --hostname github.example.corp` is required *before* Copilot CLI works against your enterprise host. Copilot CLI inherits gh's auth context — it does not have its own login flow for GHES.
- **SSO expiry:** if your org enforces SAML SSO with short-lived tokens, expect Copilot CLI to break suddenly with confusing errors. The fix is `gh auth refresh`. Document this for your team — it accounts for ~50% of "Copilot CLI is broken" reports.

## Hooks

- **`blocking: false` is the default.** If you want a hook to actually block, you must set `blocking: true` explicitly. A non-blocking safety hook is a notification, not a guardrail.
- **No default `timeoutMs`.** Without an explicit timeout, a hung hook hangs the session. Always set a timeout.
- **Hook scripts must be executable.** `chmod +x` your scripts. Forgetting this produces a confusing "command not found" error.
- **Hook environment variables are not stable across versions.** `COPILOT_HOOK_FILE_PATH` is the current name as of April 2026 — verify in current docs if a hook stops getting the path.

## Plan Mode

- **Plan Mode does not prevent reads.** It prevents *edits*. The agent can still execute non-mutating Bash commands, which is usually fine but occasionally surprising (e.g., it can run a network request that costs money).
- **Exiting Plan Mode without approving discards the plan.** If you `Shift+Tab` out without `/approve`, you're back to the prompt with the plan gone. Save anything you wanted to keep first.

## Context

- **Auto-compaction is not deterministic.** Two sessions with the same content can compact differently. Don't build workflows that depend on a specific compaction outcome.
- **`/clear` does not clear memory.** It clears the *conversation*. Repository memory persists. This is usually what you want; occasionally it isn't.

## Models

- **`/model` switches mid-session but does not reset context.** The new model inherits a context shaped by the old model's choices. Always `/clear` after `/model` if you want a clean slate.
- **Some Skills behave differently across models.** A Skill written for Claude Sonnet may produce different results on GPT-5.3-Codex because of tool-use idiom differences. Test Skills against the models your team uses.

## MCPs

- **MCPs load at session start.** Adding or modifying an MCP requires restarting the CLI. The error message when you forget is unhelpful.
- **GitHub MCP defaults to github.com.** For GHES, you need to point it at your enterprise host explicitly. Default behavior breaks silently when the agent tries to query "the wrong" GitHub.

## `permissions.deny`

- **Glob matching is path-relative, not absolute.** `Read(./.env)` matches `.env` relative to the project root. `Read(.env)` matches everywhere. Be specific.
- **Bash deny rules use regex, not glob.** `Bash(rm -rf /*)` is a regex. Forgetting this and using glob syntax silently fails to match.
- **Deny rules apply to the agent, not the human.** If you `chmod -R 777 .` from your terminal directly, no rule fires. The rules only protect against the agent doing it.

## File operations

- **`Write` always overwrites.** No "merge" mode. If you want to update part of a file, use `Edit`.
- **`MultiEdit` is atomic.** If any edit in the list fails, none are applied. This is the right default but occasionally confusing.

## Telemetry

- **`telemetry.enabled: false` in `settings.json` controls client-side telemetry only.** Org-level telemetry policy is controlled in your GitHub Enterprise admin panel. Check both.

## Things people *think* are gotchas but aren't

- **"The agent ignores my AGENTS.md."** It doesn't ignore — `AGENTS.md` is loaded. The agent is making a different judgment call than the rule asks for. The fix is usually a sharper rule or a hook.
- **"The agent uses too many tokens."** Usually not — usually it's the user pasting whole files into context. Use targeted reads.
- **"The model isn't smart enough."** Almost always actually a context or planning problem, not a model problem. Try Sonnet with better externalization before reaching for Opus.

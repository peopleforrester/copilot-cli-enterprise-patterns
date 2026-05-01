# Changelog

All notable changes to this course repo. Course content drifts fast; dates matter.

## [0.3.0] — 2026-04-07

Reconciliation against GitHub Copilot CLI v1.0.18 (April 2026).

### Pass 1 — factual corrections

- Hook JSON schema rewritten to the real format (`type: command`, `bash`, `powershell`, `cwd`, `env`, `timeoutSec`, `comment`)
- `preToolUse` is the only blocking event; blocks via `{"deny": true, "reason": "..."}` on **stdout**, not exit code
- Hook scripts (`lint-changed.sh`, `run-tests.sh`) rewritten to read event JSON from stdin and emit deny objects on stdout
- Removed the invalid Claude-Code-style `permissions.deny` block from `settings.json`; rewrote `enterprise/security-deny-rules.md` around the actual model (`--deny-tool='shell(...)'`, `preToolUse` hooks, admin console)
- Default model corrected to **Claude Sonnet 4.5**
- Config home corrected to `~/.copilot/` throughout (not `~/.config/copilot/`); `COPILOT_HOME` override noted
- `AGENTS.md` as plain markdown with nearest-wins tree walk; full instruction hierarchy documented (`AGENTS.md`, `.github/copilot-instructions.md`, `.github/instructions/**/*.instructions.md` with `applyTo`, `~/.copilot/copilot-instructions.md`)
- SKILL.md frontmatter updated with `license`, `user-invocable`, `disable-model-invocation`
- Command reference expanded with `/compact`, `/context`, `/undo`, `Esc-Esc`, `/fleet`, `/tasks`, `/resume`, `&` prefix, `/share gist`, `/allow-all`, `/yolo`, `--reasoning-effort`, plugin commands, `copilot -p ... --output-format json`
- Three-mode `Shift+Tab` cycle (Standard → Plan → Autopilot) documented
- MCP catalog corrected: `~/.copilot/mcp-config.json`, local/http/sse transports; noted **MCP org policies do not yet apply to Copilot CLI**
- Labs 04 and 05 updated for correct event names and the `postToolUse`-can't-literally-block caveat

### Pass 2 — new content for v1.0.18 surface areas

- `patterns/autopilot-mode.md` — honest framing: exists, dangerous without enforced hooks, here's the enforcement floor, here's when it's appropriate
- `reference/custom-agents.md` — `.agent.md` files, frontmatter, three lookup locations, deduplication, auto-delegation, when to write one vs a Skill
- `reference/cloud-delegation.md` — `&` prefix, `/delegate`, `/tasks`, `/resume`, GitHub Actions runners, draft PRs, governance
- `reference/plugins-marketplaces.md` — `awesome-copilot` default marketplace, running an internal marketplace, plugin audit checklist, writing your own
- `reference/opentelemetry.md` — GenAI Semantic Conventions, OTLP export, content-capture default, the six dashboards worth building, correlation with the GitHub audit log
- `patterns/subagents.md` — added **Critic** (v1.0.18, complementary-model plan review) to the roster
- `paths/06-enterprise-hardening/` — new surface-area section covering Autopilot, cloud delegation, plugins, OTel; new exit criteria
- `paths/04-externalization/` — cross-reference to custom agents

## [0.2.0] — 2026-04-07

### Added

- Six course path modules (`paths/01-foundations` through `paths/06-enterprise-hardening`) with READMEs and exercises
- Six labs (`lab-01-context`, `lab-02-plan-mode`, `lab-03-externalization`, `lab-04-verification`, `lab-05-break-the-hook`, `capstone-spec-driven`)
- Sample Python app for `lab-04-verification`
- Bloated `inherited-AGENTS.md` example for `lab-03-externalization`
- Marp slide decks for all six modules
- Instructor materials: `facilitator-guide.md`, `grading-rubric.md`, `common-questions.md`
- Reference docs: `copilot-cli-commands.md`, `model-selection-2026.md`, `hooks-format.md`, `agents-md-template.md`, `mcp-catalog-2026.md`
- Pattern docs: `subagents.md`, `memory-system.md`
- Enterprise: `copilot-vs-claude-code.md`
- Working hook scripts: `scripts/copilot-hooks/lint-changed.sh` and `run-tests.sh` (resolves the broken hook references in 0.1.0)
- `docs/gotchas-copilot-cli.md`
- `warmup-exercises.md`, `command-reference.md`, `PROJECT_STATE.md`
- `CONTRIBUTING.md`
- CI workflow: markdownlint + JSON validation + link check

### Fixed

- Hook JSON files in 0.1.0 referenced scripts that did not exist. Now they exist and are executable.

## [0.1.0] — 2026-04-07

### Added

- Initial repo scaffold
- README, AGENTS.md, LICENSE
- `.github/copilot/instructions.md` and `settings.json` (deny + ask rules)
- Two hooks (`pre-tool-use-lint.json`, `post-tool-use-test.json`)
- Three Skills (`api-scaffold`, `docker-review`, `spec-driven-dev`)
- Five pattern docs (four-pillars, context-management, plan-mode-workflow, externalization-patterns, verification-patterns)
- Three enterprise docs (restricted-environment, github-enterprise-config, security-deny-rules)

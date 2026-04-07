# Changelog

All notable changes to this course repo. Course content drifts fast; dates matter.

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

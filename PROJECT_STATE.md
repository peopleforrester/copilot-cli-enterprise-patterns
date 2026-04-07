# PROJECT_STATE.md

Durable state for `/continue`. Update this at every transition.

## Current state
Repo scaffolded with full course structure. All Four Pillars patterns documented. Skills, hooks, scripts, reference docs, paths, labs, slides, and instructor notes in place.

## Branch
`staging` — synced with `main`. Branch protection should be enabled on `main` server-side.

## Recently completed
- Initial repo scaffold (README, AGENTS.md, settings.json, instructions.md, LICENSE)
- Three Skills (api-scaffold, docker-review, spec-driven-dev)
- Two hooks (pre-tool-use-lint, post-tool-use-test) with working scripts
- Five pattern docs (four-pillars, context, plan-mode, externalization, verification)
- Three enterprise docs (restricted-environment, ghe-config, security-deny-rules)
- Reference docs (commands, model-selection-2026, hooks-format, agents-md-template, mcp-catalog-2026)
- Six course paths (foundations through enterprise hardening)
- Labs (context, plan-mode, externalization, verification, break-the-hook, capstone)
- Slides outline, instructor notes, warmup exercises, command quick card
- CI workflow (markdownlint + JSON validate + link check)
- gotchas-copilot-cli.md, CHANGELOG.md, CONTRIBUTING.md

## Next
- Record video walkthroughs for each path module
- Pilot the course with a small cohort and capture feedback
- Add more labs as gaps surface
- Refresh `model-selection-2026.md` and `mcp-catalog-2026.md` quarterly

## Tests / CI
GitHub Actions runs markdownlint, JSON validation, and link check on every push to `staging` and PR to `main`.

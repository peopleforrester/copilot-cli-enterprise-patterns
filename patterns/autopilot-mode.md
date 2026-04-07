# Autopilot Mode

> Autopilot exists. Here's how it works, why it's dangerous without enforced hooks, and when it's actually appropriate.

Autopilot is the third mode in the `Shift+Tab` cycle: **Standard → Plan → Autopilot**. In Autopilot, the agent stops asking for confirmation on tool calls that would normally prompt — edits, writes, and shell commands run straight through.

It is the single most dangerous switch in the product. It is also, used correctly, the single biggest productivity unlock.

## What Autopilot actually changes

- Tool calls that would normally trigger a permission prompt execute without prompting
- `preToolUse` hooks still fire and can still deny
- `--deny-tool` flags still apply
- Permission grants you previously approved are still honored
- The deny list is still the deny list

Autopilot removes **interactive friction**, not **policy**. If your only safety net is "the human will say no when they see the prompt," Autopilot is how you learn that the human was your safety net.

## Why this is dangerous without enforced hooks

In Standard mode, a badly-phrased prompt that makes the agent want to `rm -rf node_modules && git reset --hard` stops at the prompt. You see it. You say no.

In Autopilot, it runs. The agent does not have judgment about whether an action is reversible. It has a plan and it executes the plan.

The only thing that protects you in Autopilot is:

1. A `preToolUse` hook that denies dangerous patterns (via `{"deny": true}` on stdout)
2. `--deny-tool` flags for categorical blocks (`shell(rm -rf *)`, `shell(git reset --hard*)`, etc.)
3. A clean git working tree so you can `git reset` out of a bad session
4. Tests that run after edits and surface failures loudly

If you don't have all four, don't use Autopilot.

## When Autopilot is appropriate

- **Greenfield scaffolding in a throwaway directory.** You're generating a prototype, the worst case is `rm -rf` the directory and start over.
- **Bulk mechanical refactors with a strong test suite.** Rename a symbol across 200 files, let tests catch regressions, review the diff at the end.
- **Well-scoped tasks in a branch you're willing to throw away.** `git checkout -b autopilot-experiment`, let it run, cherry-pick what's good.
- **Following a plan you already reviewed in Plan mode.** The judgment happened when you approved the plan. Autopilot just executes it.

## When Autopilot is not appropriate

- Touching production config, infra, or secrets
- Any repo where you don't have the verification pillar fully wired
- Tasks where the agent's plan is uncertain or exploratory
- Shared branches, especially `main` or `staging`
- Anything involving `git push`, `gh pr merge`, `npm publish`, `terraform apply`, or similar externally-visible actions — these should be on the *ask list*, not auto-approved

## The enforcement floor for Autopilot

Before you turn it on in a repo, that repo must have:

1. `preToolUse` lint/security hook that denies on dangerous patterns
2. `postToolUse` test hook surfacing failures back to the agent
3. `--deny-tool` flags or hook equivalents for destructive shell and secret reads
4. Clean git working tree at session start
5. A branch you're comfortable throwing away

This is the same floor as `paths/05-verification/` — Autopilot just makes it non-negotiable instead of "strongly recommended."

## The honest framing for your team

Don't ban Autopilot. Don't celebrate it either. Teach it as: *the mode you earn by having the verification pillar in place*. If a team member asks "can I use Autopilot on this repo?", the answer is "show me the hooks."

→ See `paths/05-verification/` for the hook setup. See `enterprise/security-deny-rules.md` for deny patterns.

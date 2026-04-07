# Common Questions Playbook

The questions you will get every time you teach this. Pre-loaded answers so you're not improvising under time pressure.

## Tooling

**Q: Is Copilot CLI just GitHub Copilot in a terminal?**
No. The autocomplete Copilot is a tab-complete tool. Copilot CLI is an *agent* — it plans, takes multi-step actions, runs commands, observes results. Different product, different mental model.

**Q: How is it different from Claude Code?**
The pillars are identical. Day-to-day usage is nearly identical. The differences are: vendor relationship (GitHub vs Anthropic), built-in MCPs (GitHub MCP is native to Copilot CLI), how SSO and org policy work, pricing model. See `enterprise/copilot-vs-claude-code.md`.

**Q: Can I use both?**
Yes. Many teams do. Pick the one that matches your enterprise contract and stick with it as the team default — switching mid-task is a context tax.

## Models

**Q: Why is Sonnet 4.5 the default?**
~95% of Opus's coding ability at a fraction of the cost. For 90% of work, Sonnet is the right choice. Sonnet 4.6 is also 1× and worth A/B-testing on your workload. Opus earns the cost on multi-file refactors, security audits, and long autonomous runs.

**Q: When should I switch to GPT-5.3-Codex or Gemini 3 Pro?**
GPT-5.3-Codex if your team prefers it for tight inner-loop JS/TS work. Gemini 3 Pro for tasks involving PDFs or screenshots. Otherwise stay on Sonnet.

**Q: Can I switch mid-session?**
Technically yes. Practically: `/clear` first. The new model inherits a context shaped by the previous model's choices, which is rarely what you want.

## Context

**Q: Won't auto-compaction handle context for me?**
It will keep the session running. It will not preserve specifics. Plan as if compaction will happen.

**Q: How big is the context window?**
Large enough that you can be lazy and small enough that laziness will catch up with you. Don't budget against the number; budget against your behavior.

## Plan Mode

**Q: Plan Mode feels slow.**
For trivial tasks, yes — skip it. For non-trivial tasks, the plan time is paid back by the implementation time you don't waste on the wrong approach.

**Q: The agent's first plan is always wrong.**
Welcome to editing. The first plan being wrong is how Plan Mode pays for itself.

## Externalization

**Q: My team has a 1,400-line `AGENTS.md`. Is that bad?**
Yes. See Lab 03.

**Q: Should I write a Skill or just put it in `AGENTS.md`?**
Skill if it's a *workflow* triggered by a request shape. `AGENTS.md` if it's a *rule* that always applies.

**Q: How do I know if my Skill is triggering?**
Ask the agent: "Which Skill applies to this request?" If the answer is "none" or it picks the wrong one, sharpen the description.

## Hooks

**Q: Hooks feel scary. What if they break my workflow?**
Start with two: lint on `preToolUse` (the only event that can block — emits `{"deny": true}` on stdout), test on `postToolUse` (cannot block but its output is surfaced to the agent so failures get fixed). That's the minimum bar.

**Q: Can the agent disable hooks?**
Not at runtime. A user can edit `settings.json` to remove a deny rule, but that's a deliberate human action, not the agent talking itself out of a check.

**Q: Why blocking?**
A non-blocking hook is a notification. Notifications get ignored. Blocking is the only setting that converts a hook into a guardrail.

## Security

**Q: Is my code being used to train models?**
Check the current GitHub Copilot data handling docs — the answer is in Microsoft / GitHub's official policy and changes faster than slide decks. Do not quote from memory.

**Q: What about the GHEC data residency story?**
Same answer — verify against the live docs before quoting in a procurement conversation.

**Q: How do I prove to security that the agent isn't reading our `.env`?**
Show them the `--deny-tool` flags in your team's launch wrapper plus the `preToolUse` hook in `.github/hooks/` that denies reads of secret paths and emits `{"deny": true}`. (Note: there is no `permissions.deny` block in Copilot CLI's `settings.json` — that's a Claude Code idiom. Copilot CLI uses CLI flags + hooks + interactive grants.) Belt-and-suspenders: encrypt secrets at rest in a secret manager so even if a rule were missing, the file would be useless.

## Adoption

**Q: How do I get my team to adopt this?**
Run Lab 05 with them. Then run the capstone. Most resistance is "I don't trust the agent." The capstone shows them what *with hooks* looks like, which is a different conversation than *without hooks*.

**Q: Where do I start?**
1. Cookie-cutter `AGENTS.md` from `reference/agents-md-template.md`
2. The two minimum hooks
3. Deny rules from `enterprise/security-deny-rules.md`
4. One Skill for your team's most-repeated workflow
5. Run the capstone on a real feature

That's a week of incremental rollout. Don't try to do all of it at once.

## When to push back on a learner

If a learner says any of these, push back gently:

- "I'll just trust the agent to follow the rules." → Lab 05.
- "I don't need to plan, I know what I want." → Lab 02.
- "We don't need hooks, our linter runs in CI." → CI runs after the agent has already declared success and you've context-switched.
- "AGENTS.md has everything." → Show them the inherited 1,400-line example.
- "Auto-compaction handles context." → Lab 01.

# Facilitator Guide

How to teach this course in a single day, a half day, or a one-hour intro.

## Audience assumptions

- Mid-to-senior engineers
- Comfortable on the CLI
- Have used some AI coding tool before (Copilot autocomplete, ChatGPT, Claude, anything)
- Working in environments with real constraints — not greenfield hobby projects

## What you should *not* assume

- That they know what an MCP is
- That they have used Plan Mode before
- That they trust hooks
- That their team has any externalization beyond a stale README

## Pre-flight checklist (do this 30 minutes before)

- [ ] Each learner has Copilot CLI installed and authenticated
- [ ] Each learner can run `copilot --version`
- [ ] Each learner has cloned this repo
- [ ] Each learner has `pytest` and `ruff` (or your language equivalents) on their PATH
- [ ] Slide deck rendered or pre-loaded
- [ ] You have a sandbox repo prepared for live demos (do *not* demo in this course repo)

## Timing — full day (7 hours)

| Time | Module | Format |
|---|---|---|
| 00:00–00:15 | Welcome, expectations, Four Pillars overview | Talk |
| 00:15–01:00 | Module 01 — Foundations | Talk + warmup 1, 4 |
| 01:00–02:00 | Module 02 — Context + Lab 01 | Talk → lab → debrief |
| 02:00–02:15 | Break | |
| 02:15–03:15 | Module 03 — Plan Mode + Lab 02 | Talk → lab → debrief |
| 03:15–04:30 | Module 04 — Externalization + Lab 03 | Talk → lab → debrief |
| 04:30–05:00 | Lunch | |
| 05:00–06:15 | Module 05 — Verification + Labs 04 & 05 | Talk → lab → **debrief is the point** |
| 06:15–07:00 | Module 06 — Enterprise Hardening + capstone kickoff | Talk + start capstone |

The capstone is too long for the day — assign as homework, debrief next session.

## Timing — half day (3 hours)

Cover Modules 01, 02, 04, 05. Skip Plan Mode lab (cover the slides only). Skip enterprise. End with Lab 05 (break the hook) — it's the highest-impact 15 minutes in the course.

## Timing — one hour

- 10 min: Four Pillars
- 10 min: Plan Mode demo
- 25 min: Lab 05 (break the hook) live, full class
- 15 min: discussion of what to externalize and what to hook

## Common questions and answers

**"Can I just write everything in `AGENTS.md`?"**
You can. It will work ~80% of the time. The 20% is where you'll get hurt. See Lab 05.

**"Does this work for our [obscure language]?"**
The pillars are language-agnostic. The hook scripts in `scripts/copilot-hooks/` may need extending. Show them how.

**"What about Cursor / Windsurf / Aider?"**
The pillars apply. The mechanisms (specifically the hook format and Skill triggering) differ. This course teaches Copilot CLI specifically because that's what these teams have available; the principles transfer.

**"Will my code be used to train models?"**
Point them at the current GitHub Copilot data handling docs. Don't quote it from memory — it changes.

**"Sonnet vs Opus for daily use?"**
Sonnet, almost always. See `reference/model-selection-2026.md`. Opus for the specific situations that earn the cost.

**"Can the agent push to main?"**
Yes, technically. That's why your launch wrapper should include `--deny-tool='shell(git push --force origin main)'` (and the other variants in `enterprise/security-deny-rules.md`) and why server-side branch protection is non-negotiable. Belt + suspenders.

**"How do I convince my team to use hooks?"**
Run Lab 05 with them. It changes minds in 15 minutes.

## Demo script

Use the sandbox repo, not this one.

1. **Open Copilot CLI cold.** Show `/usage` (low). Show `/model` (Sonnet).
2. **Bad prompt.** Ask: "Add auth to this app." Watch it flail.
3. **Plan Mode.** `Shift+Tab`. Same prompt. Read the plan together. Push back on something specifically.
4. **Externalize.** Add a line to `AGENTS.md` mid-session and ask the agent to re-read.
5. **Hook fail.** Trigger the test hook to fail (have a known broken test ready). Watch the agent recover.
6. **Diff.** `/diff` and walk the changes.
7. **`/clear`.** Show `/usage` drop.

Total: ~15 minutes. Don't rehearse it to perfection — *some* friction is honest.

## Debrief discipline

After every lab:
- 2 minutes individual reflection (silent)
- 5 minutes small group share
- 5 minutes whole class

Resist the urge to skip debriefs to "save time". The debrief is where the lessons land.

## Things that will go wrong

- Someone's proxy will block Copilot CLI. Have them check `HTTPS_PROXY` and the corp CA.
- Someone's hook script won't be executable. `chmod +x` it.
- Someone will discover their team's `AGENTS.md` is worse than the lab example. Use it as a real-world warmup.
- Someone will refuse to believe Lab 05's outcome until they run it themselves. Make them run it themselves.

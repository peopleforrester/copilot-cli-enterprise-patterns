# Warm-up Exercises

Ten-minute drills to run before each session. They build the habits that make the rest of the course work.

## Warm-up 1 — Tour your context

1. Launch Copilot CLI in any repo.
2. Run `/usage`. Note current consumption.
3. Ask the agent: "What files have you read so far in this session?"
4. Run `/clear`.
5. Run `/usage` again. Confirm it dropped.

**Goal:** feel the difference between a fresh and a polluted context window.

## Warm-up 2 — Plan, don't code

1. In a sandbox repo, ask: "Add a `/health` endpoint to this service."
2. **Do not let it write code yet.** Hit `Shift+Tab` first if it tried.
3. Read the plan it produces. Identify one thing missing or wrong.
4. Push back specifically: "You didn't include a test case for the unhealthy state."
5. Wait for an updated plan. Approve.

**Goal:** practice critical reading of plans instead of rubber-stamping.

## Warm-up 3 — One Skill, one trigger

1. Open `.github/skills/api-scaffold/SKILL.md`. Read it.
2. In a Copilot CLI session, ask: "Add a POST /users endpoint."
3. Watch the agent's first response. Did the Skill activate? (It should reference the `api-scaffold` workflow.)
4. If it didn't, ask: "Which Skill applies to this request?" — and adjust the Skill description if needed.

**Goal:** see Skill triggering in action and learn to debug it.

## Warm-up 4 — Read your own deny rules

1. Open `.github/copilot/settings.json`.
2. Pick any rule in `permissions.deny`. Explain *why* it's there to a teammate (or to yourself out loud).
3. Find one rule you don't understand. Look it up in `enterprise/security-deny-rules.md`.

**Goal:** never run with deny rules you don't understand. Friction is a feature, but only if you know what it's protecting.

## Warm-up 5 — Break a hook on purpose

1. Edit `.github/hooks/post-tool-use-test.json` and change `blocking: true` to `blocking: false`.
2. Make the test suite fail (add `assert False` somewhere).
3. Ask the agent to make a small unrelated edit.
4. Watch what happens: the hook runs, fails, but does *not* block. The agent declares success on a broken codebase.
5. Revert both changes. This is why advisory hooks aren't safety hooks.

**Goal:** internalise "advisory works ~80%, deterministic works 100%".

## Warm-up 6 — Externalise something

1. Pick one thing you've told Copilot CLI more than once this week.
2. Decide where it belongs: `AGENTS.md`, user instructions, a Skill, or a hook.
3. Put it there.
4. Delete the chat note where you'd been repeating it.

**Goal:** stop repeating yourself. The repo should know.

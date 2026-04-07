# 04 — Externalization Exercises

## Exercise 4.1 — Decide where each rule lives (10 min)

For each rule below, decide: `AGENTS.md`, user `instructions.md`, Skill, memory, or hook.

1. "Use 4-space indent for Python."
2. "Never push to main."
3. "When the user asks for a new endpoint, scaffold the test first."
4. "Don't read `.env` files."
5. "I prefer terse responses."
6. "All commits must follow Conventional Commits."
7. "The DB connection string is in `config/db.yaml`."

Compare against the answer key at the end of this file.

## Exercise 4.2 — Write a Skill that triggers (25 min)

Pick a workflow you do repeatedly. Write a `SKILL.md` in `~/.config/copilot/skills/<name>/SKILL.md` with:
- A `name` and `description` specific enough to match
- Numbered steps
- Exit conditions
- At least one anti-pattern

Restart Copilot CLI. Make a request that should trigger the Skill. Check whether it does. If not, sharpen the description.

**Done when:** the Skill triggers on the first request.

## Exercise 4.3 — Slim your AGENTS.md (15 min)

Open the `AGENTS.md` of any project you actively work on. Cut anything that:
- Duplicates linter config
- Is historical narrative ("we used to...")
- Is personal preference (move to user instructions)
- Hasn't been true for six months

Aim to halve the line count without losing anything important.

## Exercise 4.4 — Memory probe (15 min)

Run `/memory` in a repo where you've worked for a while. Read what's there.

For each entry: still true? Still useful? Delete the dead ones.

**Lesson:** memory drifts. Audit it.

## Exercise 4.5 — Find the duplication (10 min)

Audit one project's externalization layer. Find a rule that exists in two places (e.g., in `AGENTS.md` *and* a Skill). Pick the right home and delete the other copy.

---

## Answer key for 4.1

1. Linter config (not a Copilot file at all). Copilot picks it up via lint output.
2. **Hook** — must hold every time.
3. **Skill** — workflow triggered by request shape.
4. **Hook** (`permissions.deny`) — must hold every time.
5. **User `instructions.md`** — personal, all repos.
6. **`AGENTS.md`** — project rule, advisory; *also* a commit-msg hook if you want enforcement.
7. **`AGENTS.md`** — project fact every session benefits from knowing.

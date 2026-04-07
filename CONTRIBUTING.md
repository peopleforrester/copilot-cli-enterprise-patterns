# Contributing

Course content drifts. Patterns get refined. Vendor docs change. Contributions are welcome — small fixes, new exercises, gotchas you've hit, lab scenarios from your real work.

## Ground rules

- **Open an issue first** for anything more than a typo, so we don't duplicate work.
- **Work on `staging`.** Open PRs from `staging` → `main`.
- **No AI attribution lines** in commit messages. Conventional Commits, imperative mood.
- **Practitioner tone.** No marketing. No "leveraging synergies". If you wouldn't say it to a colleague at a whiteboard, don't put it in this repo.
- **Cite when you can.** If you're claiming a Copilot CLI behavior, link to the docs or a reproducible example.

## What we want

- New labs (especially: real scenarios from real teams, anonymised)
- Gotchas as you find them — add to `docs/gotchas-copilot-cli.md`
- Translations of the slides
- Variants of the exercises for languages we don't currently cover (Rust, Go, JVM)
- Updates when Copilot CLI ships new features or changes existing ones
- Corrections to anything that turns out to be wrong

## What we don't want

- Brand-new pillars or competing methodologies (the Four Pillars are the spine of this course; alternatives belong in their own repo)
- Long historical narratives ("here is how this evolved over the years")
- Tool comparisons that are really vendor pitches
- Anything that requires the reader to install ten new things to follow along
- Contributions written by an agent without human review (this is a course about *using* agents well; the irony of unreviewed agent slop in the course material would be embarrassing)

## How to add a lab

1. Pick a real scenario you've seen (anonymise it).
2. Identify which pillar(s) it exercises.
3. Create `labs/lab-NN-name/README.md` following the structure of existing labs:
   - Scenario
   - Your task
   - Steps
   - Success criteria
   - Anti-patterns to avoid
   - Debrief questions
4. If the lab needs sample files, put them under `labs/lab-NN-name/`.
5. Reference the lab from the relevant `paths/NN-*/README.md`.
6. Update `labs/README.md` and `CHANGELOG.md`.

## How to add a gotcha

1. Open `docs/gotchas-copilot-cli.md`.
2. Add to the relevant section, or create a new section.
3. Be specific: what you tried, what you expected, what happened, the workaround.
4. If the gotcha is version-sensitive, note the version and date.

## CI

The CI workflow runs:
- `markdownlint` on all `.md` files
- JSON validation on all `.json` files
- Link check on all markdown links

Your PR will be blocked if any of these fail. Run them locally first:

```bash
markdownlint '**/*.md'
find . -name '*.json' -not -path '*/node_modules/*' -exec jq empty {} \;
```

## Code of conduct

Be useful. Be honest. Disagree on substance, not on style. If you wouldn't say it in a code review with a colleague you respect, don't say it here.

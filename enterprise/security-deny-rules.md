# Security Deny Rules

Copilot CLI's permission system uses **CLI flags and interactive grants**, not a `permissions.deny` block in `settings.json` (that's a Claude Code idiom that does not apply here). This doc explains the actual mechanics and the deny patterns worth standardising on.

## How Copilot CLI permissions actually work

1. **Tool kinds** are first-class: `shell(COMMAND)`, `shell(COMMAND:*)` (stem match), `read`, `write`, `url(PATTERN)`, `MCP_SERVER_NAME`, `MCP_SERVER_NAME(tool_name)`.
2. **Flags drive the policy** at session start: `--allow-tool=...`, `--deny-tool=...`, `--available-tools=...`, `--excluded-tools=...`.
3. **Deny always wins.** Even with `--allow-all` (`--yolo`), an explicit `--deny-tool` takes precedence.
4. **Interactive grants** persist to `~/.copilot/` when the user picks "approve permanently". These accumulate over a working session.
5. **Enterprise policy cascade** (Enterprise → Org → User) is administered through the GitHub admin console UI, not a file you edit. **Confirmed gap as of April 2026: MCP policies do not yet apply to CLI** at the org level — track this.

## Principles

1. **Deny destructive operations** unless an operator explicitly opts in.
2. **Deny secret reads** — the agent should never read `.env`, `secrets/`, private keys, or credential files.
3. **Deny CI/CD edits** — workflow files are how an attacker (or a confused agent) bypasses every other check.
4. **Deny IaC edits** — Terraform, CloudFormation, Kubernetes manifests change shared infrastructure.
5. **Approve interactively** for legitimate-but-high-impact operations like `git push` or `gh pr merge` — don't deny them, just don't auto-approve them.

## Recommended deny flags

Wrap `copilot` in a shell function or alias so these apply to every session for the team. Or set them via your enterprise admin console policy.

### Destructive shell

```bash
--deny-tool='shell(rm -rf /)' \
--deny-tool='shell(rm -rf ~)' \
--deny-tool='shell(rm -rf $HOME)' \
--deny-tool='shell(sudo:*)' \
--deny-tool='shell(chmod 777:*)' \
--deny-tool='shell(git clean -fdx)'
```

### Remote execution

```bash
--deny-tool='shell(curl:*|sh)' \
--deny-tool='shell(curl:*|bash)' \
--deny-tool='shell(wget:*|sh)' \
--deny-tool='shell(wget:*|bash)'
```

The canonical install-script pattern is also the canonical attack pattern. Block unconditionally; if you genuinely need to run a vendor install script, do it manually after reading it.

### Force-push and history rewrite to protected branches

```bash
--deny-tool='shell(git push --force origin main)' \
--deny-tool='shell(git push -f origin main)' \
--deny-tool='shell(git push --force origin master)' \
--deny-tool='shell(git reset --hard origin/main)'
```

Belt-and-suspenders with server-side branch protection on `main`.

### Global config mutation

```bash
--deny-tool='shell(git config --global:*)'
```

The agent should never mutate the user's global git identity, signing key, or remote helpers.

### Publishing

```bash
--deny-tool='shell(npm publish:*)' \
--deny-tool='shell(pnpm publish:*)' \
--deny-tool='shell(cargo publish:*)' \
--deny-tool='shell(twine upload:*)' \
--deny-tool='shell(docker push:*)'
```

Releases are a human decision.

### Cloud destruction

```bash
--deny-tool='shell(kubectl delete:*)' \
--deny-tool='shell(terraform destroy:*)' \
--deny-tool='shell(terraform apply -auto-approve:*)' \
--deny-tool='shell(aws:* delete:*)' \
--deny-tool='shell(gcloud:* delete:*)'
```

### Secret reads

The cleanest approach is a `preToolUse` hook that inspects the file path and denies reads under sensitive paths. Example pattern in `.github/hooks/`:

```json
{
  "version": 1,
  "hooks": {
    "preToolUse": [
      {
        "type": "command",
        "bash": "./scripts/copilot-hooks/block-secret-reads.sh",
        "timeoutSec": 5,
        "comment": "Deny reads of .env, .pem, .key, credentials files"
      }
    ]
  }
}
```

The hook script reads the JSON event from stdin and emits `{"deny": true, "reason": "..."}` on a match. See `scripts/copilot-hooks/lint-changed.sh` for the parsing pattern.

### Protected file edits

Same approach: a `preToolUse` hook that denies `edit_file` / `create_file` tool calls when the path matches `.github/workflows/**`, `infra/**`, `**/*.tf`, etc.

## Things to approve interactively, not deny

Some operations are legitimate but high-impact. They should prompt every time, not auto-approve:

- `git push *`
- `git merge *`
- `git rebase *`
- `gh pr merge *`
- `gh release *`

Don't `--allow-all`. Don't `--deny-tool` either. Let the prompt fire and approve in context. Operators who hate the friction will eventually understand the friction is the point.

## What to put in `.github/copilot/settings.json`

`settings.json` is for **workspace-level config that's safe to commit**: model preference, enabled plugins, company announcements. It is **not** the place for permission rules — those are runtime flags or interactive grants. The minimal, correct shape is:

```json
{
  "version": 1,
  "model": "claude-sonnet-4-5",
  "enabledPlugins": [],
  "telemetry": { "enabled": false }
}
```

## Local override

Per-developer overrides go in `.copilot/settings.local.json` (gitignored). Use this for personal preferences that shouldn't be committed.

## Maintenance

- Review the team's deny flags quarterly.
- Add a new rule when an incident reveals a gap. Don't add hypothetical rules — every rule is friction.
- Remove rules that are obsolete. Stale rules get bypassed and erode trust in the policy.
- Track the **MCP policy CLI gap** until GitHub closes it.

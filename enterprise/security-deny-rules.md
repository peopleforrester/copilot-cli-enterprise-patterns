# Security Deny Rules

The `permissions.deny` block in `.github/copilot/settings.json` is the primary client-side guardrail. This doc explains what's in it and why.

## Principles

1. **Deny destructive operations.** Anything that loses data, force-pushes, or removes infrastructure should be denied unless an operator explicitly opts in.
2. **Deny secret reads.** The agent should never read `.env`, `secrets/`, private keys, or credential files. If it needs a secret, the human supplies it out-of-band.
3. **Deny CI/CD edits.** Workflow files are an attractive target — modifying CI is how an attacker (or a confused agent) bypasses every other check.
4. **Deny IaC edits.** Terraform, CloudFormation, and Kubernetes manifests can change shared infrastructure. Require human authorship.
5. **Ask, don't deny, for ambiguous-but-legitimate operations** like `git push` or `gh pr merge`. The operator can approve in context.

## Categories in this repo's settings.json

### Destructive shell
```
Bash(rm -rf /*)
Bash(rm -rf ~)
Bash(rm -rf $HOME*)
Bash(sudo *)
Bash(chmod 777 *)
Bash(git clean -fdx)
```

### Remote execution
```
Bash(curl * | sh)
Bash(curl * | bash)
Bash(wget * | sh)
Bash(wget * | bash)
```
These are the canonical install-script pattern. They are also the canonical attack pattern. Block them unconditionally; if you genuinely need to run a vendor install script, do it manually after reading it.

### Force push and history rewrite to protected branches
```
Bash(git push --force origin main)
Bash(git push -f origin main)
Bash(git push --force origin master)
Bash(git reset --hard origin/main)
```
Belt-and-suspenders with server-side branch protection.

### Global config mutation
```
Bash(git config --global *)
```
The agent should never mutate the user's global git identity, signing key, or remote helpers.

### Publishing
```
Bash(npm publish*)
Bash(pnpm publish*)
Bash(cargo publish*)
Bash(twine upload*)
Bash(docker push *)
```
Releases are a human decision.

### Cloud destruction
```
Bash(kubectl delete *)
Bash(terraform destroy*)
Bash(terraform apply -auto-approve*)
Bash(aws * delete*)
Bash(gcloud * delete*)
```

### Secret reads
```
Read(./.env)
Read(./.env.*)
Read(./secrets/**)
Read(**/*.pem)
Read(**/*.key)
Read(**/id_rsa)
Read(**/credentials*)
```

### Protected file edits
```
Edit(./.github/workflows/**)
Edit(./infra/**)
Edit(**/*.tf)
Edit(**/*.tfvars)
```

## The `ask` list

Some operations are legitimate but high-impact. They're in `ask`, not `deny`:

```
Bash(git push *)
Bash(git merge *)
Bash(git rebase *)
Bash(gh pr merge *)
Bash(gh release *)
```

The agent will pause and request approval before running these. The operator approves once, in context, and the operation proceeds.

## What `permissions.deny` doesn't cover

- **Network egress.** Use your proxy and firewall to restrict where the machine can reach.
- **Server-side enforcement.** GitHub branch protection is the authoritative gate on `main`. `settings.json` is a local hint.
- **Determined misuse.** A user who *wants* to bypass these rules can edit their own `settings.json`. These rules protect against accidents and confused agents, not malicious operators.

## Maintenance

- Review the deny list quarterly.
- Add new rules when an incident reveals a gap. Don't add hypothetical rules — every rule is friction.
- Remove rules that are obsolete. Stale rules get bypassed and erode trust in the file.

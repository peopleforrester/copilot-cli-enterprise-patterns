# GitHub Enterprise Configuration for Copilot CLI

Copilot CLI works with both GitHub Enterprise Cloud (GHEC) and GitHub Enterprise Server (GHES). The configuration differs in a few important places.

## GHEC vs GHES — quick orientation

| | GHEC | GHES |
|---|---|---|
| Hosting | github.com infrastructure | Self-hosted on your servers |
| Copilot availability | Yes, with the right SKU | Requires GHES version that supports Copilot; check current support matrix |
| Auth | Same as github.com (OAuth, SAML SSO if configured) | Your GHES instance's auth (often SAML/SSO) |
| Hostname | `github.com` | Your `github.example.corp` |

Verify support before assuming. The Copilot product evolves quickly and the GHES support window changes.

## Org-level setup

Before any developer can use Copilot CLI, an org admin must:

1. **Enable Copilot for the organization** in org settings.
2. **Assign Copilot seats** to the relevant teams or users.
3. **Decide on policies**:
   - Public code matching: block / allow
   - Suggestions matching public code: block / allow
   - Telemetry sharing
   - Allowed models (some orgs restrict the available models)
4. **Configure SSO enforcement** so that personal access tokens used by Copilot CLI are SSO-authorized.

These are org-wide settings. They override anything in a user's local `settings.json`.

## Authenticating Copilot CLI to GHES

For GHES, point Copilot CLI at your enterprise host:

```bash
gh auth login --hostname github.example.corp
```

Then ensure Copilot CLI inherits the same auth context. Verify with:

```bash
gh auth status
```

If your GHES uses an internal certificate authority, the same `NODE_EXTRA_CA_CERTS` configuration from `restricted-environment.md` applies.

## SSO and short-lived tokens

If your org enforces SAML SSO with short-lived tokens, expect to re-authorize periodically. Document the re-auth flow for your team — the most common new-user friction is "my Copilot CLI suddenly can't reach GitHub" which is almost always an expired SSO authorization.

## Branch protection

The patterns in this repo assume:

- `main` is protected
- `staging` is the integration branch developers push to
- Merges to `main` happen via PR with passing CI

Configure on your GHEC/GHES:

- Require pull request reviews before merging to `main`
- Require status checks to pass before merging
- Require branches to be up to date before merging
- Restrict who can push to `main` (typically: nobody, only merges via PR)

The deny rule `Bash(git push --force origin main)` in `settings.json` is a *belt*. Branch protection on the server is the *suspenders*. Use both.

## Audit log

Treat the GHEC/GHES audit log as your authoritative record of who did what. Copilot CLI activity that touches the repo (commits, pushes, PRs, branch creation) shows up there.

## GitHub MCP

Copilot CLI ships with the GitHub MCP server built in — issues, PRs, and branches are addressable as native tools without extra configuration. For GHES, ensure the MCP is pointing at your enterprise host, not `github.com`.

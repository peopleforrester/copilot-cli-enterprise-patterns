# MCP Catalog — April 2026

Model Context Protocol servers extend Copilot CLI with new tools. The GitHub MCP is built in. This page lists the additional MCPs worth considering for an enterprise team and what each one buys you.

> Verify each MCP's current maintenance status before adoption. Abandoned MCPs become attack surface.

## Built in (no install required)

### GitHub MCP
Native access to issues, pull requests, branches, releases, and the API. Works with both GHEC and GHES (point it at your enterprise host).

**Use it for:** "show me open PRs", "create an issue from this bug", "what commits landed on staging this week".

## Recommended additions

### Filesystem MCP
Access to a sandboxed slice of the local filesystem outside the project root. Useful when you need to read shared configs, design docs, or notes without making them part of the repo.

**When to add:** if your team keeps specs or runbooks outside the code repo.

**Caveats:** scope it tightly. Never give it your home directory.

### Postgres MCP (or your DB of choice)
Read-only by default. Lets the agent inspect schemas, sample rows, and write queries against the actual database instead of guessing.

**When to add:** any project where the agent regularly writes data-layer code.

**Caveats:** point at a *non-prod* database. Even read-only access to prod is a compliance question.

### Sentry MCP
Pulls error reports, stack traces, and frequency data into the session.

**When to add:** when "fix this bug" means "the user is going to paste a Sentry link".

### Linear MCP (or Jira, Asana, etc.)
Issue tracker integration. Lets the agent open, comment on, and close tickets in your tracker.

**When to add:** when developers spend more time copy-pasting between Linear and the editor than coding.

**Caveats:** scope the API token. The agent should not be able to delete projects.

### Internal docs MCP
Custom MCP pointing at your internal docs site (Confluence, Notion, internal wiki). Lets the agent search company-specific knowledge instead of inventing it.

**When to add:** as soon as you have enough internal docs that the agent's hallucinations about your conventions become a problem.

**Caveats:** access control matters. The MCP inherits the perms of whatever token it's given.

## Not recommended (yet)

These exist but the trade-off isn't there for most teams as of April 2026:

- **General web-browsing MCPs** — too broad, too easy to lose context to noise. Use targeted fetch instead.
- **Email MCPs** — high blast radius, low hit rate for engineering work.
- **"Universal" enterprise hub MCPs** — single token, broad scope, large attack surface. Prefer narrow MCPs.

## Installing an MCP

Copilot CLI reads MCP config from `~/.config/copilot/mcp.json`:

```json
{
  "mcpServers": {
    "postgres": {
      "command": "mcp-server-postgres",
      "args": ["--connection-string", "postgresql://readonly@db.dev.corp/app"],
      "env": {}
    }
  }
}
```

Restart the CLI session for new MCPs to take effect. Confirm with `/mcp` or by asking "what tools do you have available?".

## Audit checklist before adopting an MCP

1. Who maintains it? Vendor, community, your own team?
2. What's the last commit date?
3. What permissions does the token need? Can you scope it down?
4. Does it phone home? Read its source if unclear.
5. What's the failure mode when the upstream service is down?
6. Is it on your security team's allowlist?

If you can't answer all six, don't install it.

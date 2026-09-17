# MCP Catalog — September 2026

Model Context Protocol servers extend Copilot CLI with new tools. The GitHub MCP is built in. This page lists the additional MCPs worth considering for an enterprise team and what each one buys you.

> Verify each MCP's current maintenance status before adoption. Abandoned MCPs become attack surface.

## Built in (no install required)

### GitHub MCP

Native access to repositories, issues, pull requests, branches, releases, and workflow runs. Works with both GHEC and GHES (point it at your enterprise host).

**Use it for:** "show me open PRs", "create an issue from this bug", "what commits landed on staging this week".

**Toggle:**

- `--enable-all-github-mcp-tools` — full toolset
- `--disable-mcp-server github` — disable
- `--disable-builtin-mcps` — disable all built-ins

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

Issue tracker integration.

**Caveats:** scope the API token. The agent should not be able to delete projects.

### Internal docs MCP

Custom MCP pointing at your internal docs site.

**Caveats:** access control matters — the MCP inherits the perms of whatever token it's given.

### Playwright MCP

Browser automation. Useful for end-to-end test authoring and scraping local dev servers.

## Not recommended (yet, as of September 2026)

- General web-browsing MCPs — too broad, too easy to lose context
- Email MCPs — high blast radius, low hit rate for engineering work
- "Universal" enterprise hub MCPs — single token, broad scope, large attack surface

## Configuration file

Copilot CLI reads MCP config from **`~/.copilot/mcp-config.json`** (user-level). Optional repo-level at `.copilot/mcp-config.json`.

```json
{
  "mcpServers": {
    "playwright": {
      "type": "local",
      "command": "npx",
      "args": ["@playwright/mcp@latest"],
      "env": {},
      "tools": ["*"]
    },
    "remote-api": {
      "type": "http",
      "url": "https://mcp.example.com/mcp",
      "headers": { "Authorization": "Bearer ${API_KEY}" },
      "tools": ["*"]
    }
  }
}
```

### Transport types

| Type | Description |
|---|---|
| `local` / `stdio` | Stdin/stdout child process |
| `http` | Streamable HTTP |
| `sse` | Server-Sent Events (legacy, deprecated but still supported) |

### Per-session override

```bash
copilot --additional-mcp-config /path/to/extra.json
```

## Management commands

| Command | Action |
|---|---|
| `/mcp add` | Interactive form to add an MCP |
| `/mcp show` | List configured MCPs and current state |
| `/mcp edit <server>` | Edit an existing entry |
| `/mcp delete <server>` | Remove |
| `/mcp enable\|disable <server>` | Toggle without removing |

## Tool-level access control

```bash
copilot --allow-tool='MyMCP(specific_tool)'
copilot --deny-tool='MyMCP(dangerous_tool)'
```

`deny` always wins, even with `--allow-all`.

## Restart matters

**MCPs load at session start.** Adding or modifying an MCP requires restarting the CLI for changes to take effect. The error message when you forget is unhelpful — see `docs/gotchas-copilot-cli.md`.

## Org and enterprise MCP policy

As of September 2026, **organisation- and enterprise-level MCP allowlists apply to Copilot CLI.** Administer them centrally two ways, both enforced at runtime on the CLI, the Copilot app, and VS Code:

- **Enterprise managed settings** (since August 2026): the `allowedMcpServers` and `deniedMcpServers` keys in your enterprise `managed-settings.json` (committed to the source org's `.github-private` repo at `copilot/managed-settings.json`). Built-in servers are always allowed; deny always wins; if `allowedMcpServers` is present, anything not on it is blocked.
- **Custom MCP registry (BYOR)** (since April 2026): point the org or enterprise Copilot policy at an internally managed MCP registry URL, and any server not defined there is blocked at runtime.

For defense-in-depth, or where central policy is not yet configured, also enforce locally through:

- The user-level `~/.copilot/mcp-config.json` shipped via your standard onboarding
- A `preToolUse` hook that denies calls to non-allowlisted MCPs
- A wrapper script that launches `copilot` with `--deny-tool` flags

Track the gap closing in the GitHub changelog.

## Audit checklist before adopting any MCP

1. Who maintains it? Vendor, community, your own team?
2. What's the last commit date?
3. What permissions does the token need? Can you scope it down?
4. Does it phone home? Read its source if unclear.
5. What's the failure mode when the upstream service is down?
6. Is it on your security team's allowlist?

If you can't answer all six, don't install it.

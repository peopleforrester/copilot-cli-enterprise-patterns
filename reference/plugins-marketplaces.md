# Plugins and Marketplaces

Copilot CLI has a plugin system. Plugins bundle Skills, hooks, custom agents, and MCP server configs into a single installable unit. The default marketplace is `awesome-copilot`.

## Install and manage

```bash
# List installed
copilot plugins list

# Search the default marketplace
copilot plugins search <query>

# Install
copilot plugins install <name>

# Enable / disable without uninstalling
copilot plugins enable <name>
copilot plugins disable <name>

# Remove
copilot plugins uninstall <name>
```

Enabled plugins are recorded in `~/.copilot/config.json` under `enabledPlugins`, or per-project in `.github/copilot/settings.json`.

## Marketplace structure

A marketplace is a git repo containing a `marketplace.json` index:

```json
{
  "version": 1,
  "plugins": [
    {
      "name": "security-pack",
      "description": "Gitleaks hook, secret-reviewer agent, OWASP skill",
      "repo": "https://github.com/org/security-pack",
      "tag": "v1.2.0",
      "sha256": "…"
    }
  ]
}
```

Point Copilot CLI at a different marketplace:

```bash
copilot plugins marketplace add internal https://github.internal/platform/copilot-marketplace
copilot plugins marketplace list
copilot plugins marketplace remove internal
```

Enterprises should run their own vetted marketplace internally rather than letting developers install from `awesome-copilot` directly.

## What a plugin can ship

- `skills/**/SKILL.md` — Skills registered automatically
- `hooks/*.json` — lifecycle hooks wired in when the plugin is enabled
- `agents/*.agent.md` — custom agents
- `mcp-servers.json` — MCP server definitions to merge into the user's config
- `deny-rules.json` — recommended `--deny-tool` additions

## Security audit checklist

Before installing a plugin — **especially** from a public marketplace:

- [ ] Read every hook script. Hooks run arbitrary shell.
- [ ] Check every agent's `tools` list for overly-broad shell patterns
- [ ] Check `mcp-servers.json` for servers that phone home
- [ ] Pin to a `sha256` in your internal marketplace, not a floating tag
- [ ] Run it in a throwaway project first

Plugin hooks are the same trust boundary as running a shell script someone emailed you. Treat them that way.

## Writing your own

A plugin is just a repo with the structure above and a top-level `plugin.json`:

```json
{
  "name": "my-team-pack",
  "version": "0.1.0",
  "description": "Our team's skills and hooks",
  "license": "MIT",
  "author": "platform-team"
}
```

Push it to a git host, add an entry to your internal `marketplace.json`, and your team can `copilot plugins install my-team-pack`.

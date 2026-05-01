# Running Copilot CLI in Restricted Environments

Most enterprise environments are not greenfield. They have proxies, allowlists, no general internet, IDS/IPS sniffing TLS, and security review boards that need answers before any new tool is approved. This doc covers what to expect and how to configure Copilot CLI for those environments.

## Network requirements

Copilot CLI needs outbound HTTPS to:

- The GitHub Copilot inference endpoint (`api.githubcopilot.com` and `*.githubusercontent.com`)
- `github.com` / your GitHub Enterprise host for git operations and the GitHub MCP
- Any package registry your project uses (npm, PyPI, etc.) — only when the agent installs deps

**What it does *not* need:**

- General internet browsing (Copilot CLI does not freely browse the web during a session unless you explicitly invoke a web tool)
- Inbound connections of any kind

## Air-gapped or heavily restricted environments

If your environment forbids all egress to public AI endpoints, Copilot CLI will not function. There is no on-prem inference path today. Discuss with your security team:

- Whether a dedicated egress allowlist for `api.githubcopilot.com` is feasible
- Whether GitHub Enterprise Cloud with data residency satisfies the data-handling requirements
- Whether the Copilot data-handling guarantees (no training on prompts, etc.) meet your compliance bar

If the answer is no on all three, do not deploy Copilot CLI.

## Proxy configuration

Copilot CLI honors standard proxy environment variables:

```bash
export HTTPS_PROXY=https://proxy.corp.example:3128
export HTTP_PROXY=https://proxy.corp.example:3128
export NO_PROXY=localhost,127.0.0.1,.corp.example,github.corp.example
```

If your proxy performs TLS interception, point Copilot CLI at your corporate root CA:

```bash
export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/corp-root-ca.pem
export SSL_CERT_FILE=/etc/ssl/certs/corp-root-ca.pem
```

Test with a simple Copilot CLI session before declaring it working.

## Package registries

If your team uses an internal mirror (Artifactory, Nexus, internal PyPI), configure those *before* letting the agent install dependencies. The agent will use whatever the project's package manager is configured to use; it does not bypass your `.npmrc` or `pip.conf`.

## What to deny

See `enterprise/security-deny-rules.md` for the canonical `--deny-tool` flag set and the `preToolUse` hook patterns. At minimum, deny:

- All shell patterns that egress to non-allowlisted destinations
- Reads of secret paths
- Edits to CI/CD configuration
- Edits to infrastructure-as-code

## Telemetry

Disable in `settings.json`:

```json
{
  "telemetry": { "enabled": false }
}
```

Confirm with your GitHub Enterprise admin what telemetry is collected at the org level — settings.json controls only client-side telemetry.

## Logs and audit

Copilot CLI session logs may contain snippets of source code. Treat them as source-code-sensitive:

- Store under the same access controls as the repo itself
- Do not ship to a third-party log aggregator without security review
- Set retention according to your code-retention policy, not your generic application-log policy

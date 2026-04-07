# OpenTelemetry for Copilot CLI

Copilot CLI emits OpenTelemetry traces following the **GenAI Semantic Conventions**. This is how you get real observability into agent runs — not "the agent said it worked," but a span tree showing every model call and tool execution.

## Enable it

```bash
export OTEL_EXPORTER_OTLP_ENDPOINT=https://otel.internal:4318
export OTEL_EXPORTER_OTLP_HEADERS="authorization=Bearer $OTEL_TOKEN"
export OTEL_SERVICE_NAME=copilot-cli
export COPILOT_OTEL_ENABLED=1
```

Spans export via OTLP/HTTP by default. Any OTel-compatible backend works: Honeycomb, Grafana Tempo, Datadog, Jaeger, an in-house collector.

## Span hierarchy

```
invoke_agent                  (one per user turn)
├── chat                      (one per model round-trip)
│   └── gen_ai.request.*      (model, tokens, temperature, reasoning_effort)
├── execute_tool: read        (one per tool call)
├── execute_tool: shell
│   └── attributes: command, exit_code, duration
└── execute_tool: mcp.github.create_pr
```

Attributes follow the GenAI Semantic Conventions: `gen_ai.system`, `gen_ai.request.model`, `gen_ai.response.model`, `gen_ai.usage.input_tokens`, `gen_ai.usage.output_tokens`, `gen_ai.operation.name`.

## Content capture

By default, prompt and response **content is not captured** in spans — only metadata. This is the correct default for compliance.

To capture content (useful in dev, dangerous in prod):

```bash
export OTEL_INSTRUMENTATION_GENAI_CAPTURE_MESSAGE_CONTENT=true
```

Never turn this on in an environment where session transcripts contain source code or secrets unless your backend is classified at the same sensitivity level as your repo.

> Feature request to make per-span content capture configurable at runtime: copilot-cli issue #1911.

## What to actually dashboard

- **p95 turn latency** — `invoke_agent` duration
- **Tool call count per turn** — count of `execute_tool` per `invoke_agent`
- **Tool failure rate** — `execute_tool` spans with error status
- **Token spend per user per day** — sum of `gen_ai.usage.*_tokens` grouped by user
- **Hook deny rate** — custom attribute from your `preToolUse` hooks (emit a log line the collector scrapes)
- **Model mix** — count by `gen_ai.request.model`

These six charts will tell you more about agent health than any "did the PR merge" metric.

## Correlation with GitHub audit log

Include the session ID as a span attribute and as a trailer in commit messages the agent creates. That gives you a join from "this commit in main" → "the agent session that produced it" → "the full span tree of tool calls for that session."

## When to skip OTel

- Solo developer, single laptop, no compliance obligations — skip it
- Small team, no central platform — skip it, revisit when you have one
- Enterprise rollout, >20 seats, any audit requirement — required, not optional

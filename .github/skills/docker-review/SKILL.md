---
name: docker-review
description: Review a Dockerfile against an enterprise best-practice checklist and report concrete issues with line references.
license: MIT
user-invocable: true
disable-model-invocation: false
---

# docker-review

Use when the user asks to review, audit, or improve a Dockerfile.

## Steps

1. Read the full Dockerfile. Note the base image, build stages, and final `CMD`/`ENTRYPOINT`.
2. Walk the checklist below. For each item, record PASS / FAIL / N/A with a `Dockerfile:<line>` reference.
3. Report findings grouped by severity: **Blocker → High → Medium → Low**.
4. Do not auto-edit. Propose changes; let the user decide.

## Checklist

### Blocker
- [ ] Pinned base image (digest preferred, tag minimum). No `:latest`.
- [ ] No secrets baked in (no `ARG`/`ENV` containing tokens, keys, passwords).
- [ ] Final stage runs as a non-root `USER`.
- [ ] No `curl ... | sh` style remote execution in build steps.

### High
- [ ] Multi-stage build separating build deps from runtime.
- [ ] `COPY` is scoped — no `COPY . .` without a `.dockerignore`.
- [ ] `.dockerignore` exists and excludes `.git`, `node_modules` (when rebuilt), `*.env`, `secrets/`.
- [ ] Package manager caches cleaned (`apt-get clean`, `--no-install-recommends`, `pip --no-cache-dir`).
- [ ] Pinned package versions where the ecosystem supports it.

### Medium
- [ ] `HEALTHCHECK` defined for long-running services.
- [ ] `EXPOSE` documents the runtime port.
- [ ] Layers ordered for cache efficiency (deps before source).
- [ ] Image labels (`org.opencontainers.image.*`) for source, revision, version.

### Low
- [ ] `WORKDIR` set explicitly, not relying on `/`.
- [ ] `ENTRYPOINT` uses exec form (`["bin", "arg"]`), not shell form.
- [ ] No trailing commented-out junk.

## Output format

```
docker-review: <path/to/Dockerfile>

BLOCKER (n)
  - Dockerfile:3 — base image is `python:latest`, no pin
  - ...

HIGH (n)
  - ...

MEDIUM (n)
  - ...

LOW (n)
  - ...

Summary: n blockers, n high, n medium, n low.
Recommended next action: <one sentence>.
```

## Exit conditions

- Every checklist item has a verdict
- Findings reference exact line numbers
- No files modified

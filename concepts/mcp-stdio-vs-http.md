# MCP Stdio Transport vs HTTP Transport

> **Protocols & WebMCP** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Comparing local subprocess IPC pipes (stdio) against distributed networked endpoints (HTTP/SSE) for tool execution.

## Architecture, minus the theatre

Stdio transport launches the tool server as a child subprocess, communicating over standard input/output streams. It has zero network latency and maximum security on local machines. HTTP/SSE transport connects to remote shared tool microservices over the network.

## Anti-pattern

Exposing local sensitive filesystem stdio tools over public unauthenticated HTTP endpoints.

## Production tip

Use stdio for local development tools (filesystem, git, terminal) and authenticated HTTP/SSE for shared enterprise databases.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

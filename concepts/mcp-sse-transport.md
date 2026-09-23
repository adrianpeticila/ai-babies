# Server-Sent Events (SSE) for MCP

> **Protocols & WebMCP** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** HTTP streaming transport enabling remote MCP servers to push events and tool execution streams over standard web ports.

## Architecture, minus the theatre

While local desktop agents use stdio pipes, remote web-based MCP deployments use Server-Sent Events (SSE) for server-to-client streaming and standard HTTP POST requests for client-to-server messaging. This works seamlessly through standard HTTP firewalls and proxies.

## Anti-pattern

Using raw WebSockets where simpler unidirectional SSE streams over standard HTTPS provide better reconnectivity and firewall traversal.

## Production tip

Use SSE transport for cloud-hosted MCP tool servers running in serverless or Kubernetes environments.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

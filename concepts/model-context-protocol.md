# Model Context Protocol (MCP)

> **Protocols & WebMCP** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Anthropic's open protocol standardizing how LLMs discover, inspect, and execute external tools and data sources.

## Architecture, minus the theatre

MCP decouples LLM applications from tool implementations using a client-server architecture. An MCP server exposes Prompts, Resources (read-only data streams), and Tools (executable functions) over stdio or SSE transports with JSON-RPC 2.0.

## Anti-pattern

Hardcoding custom proprietary tool integrations for every new LLM provider instead of implementing the standard MCP specification.

## Production tip

Build your internal company APIs as standard MCP servers once; use them across Claude Desktop, Cursor, and custom agent runtimes.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

# window.modelContext Interface

> **Protocols & WebMCP** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** The standardized JavaScript object on the global browser window object hosting WebMCP tools and metadata.

## Architecture, minus the theatre

WebMCP standard specifies that compliant web apps register tools on window.modelContext.tools. Each tool provides a name, description, JSON schema for input parameters, and an async execute(params) handler returning structured results.

## Anti-pattern

Polluting the global window object with unstandardized helper functions that agents cannot discover programmatically.

## Production tip

Expose window.modelContext alongside <meta name="webmcp" content="/.well-known/webmcp.json"> for auto-discovery.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

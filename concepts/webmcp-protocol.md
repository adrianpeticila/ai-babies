# WebMCP Protocol

> **Protocols & WebMCP** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Open lightweight protocol standard for exposing client-side browser tools directly to AI web agents.

## Architecture, minus the theatre

WebMCP bridges web applications and AI agents by exposing structured tool schemas via /.well-known/webmcp.json and a standard window.modelContext browser API. Any visiting AI agent can discover and invoke client-side functions deterministically.

## Anti-pattern

Forcing AI web agents to scrape noisy DOM nodes and guess button selectors when structured tools can be called directly.

## Production tip

Declare /.well-known/webmcp.json on your domain so web agents like Claude, ChatGPT Operator, and open-source crawlers interact via fast, lossless JSON APIs.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

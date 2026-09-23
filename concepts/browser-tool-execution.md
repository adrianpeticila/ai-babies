# Browser-Side Tool Execution

> **Protocols & WebMCP** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Executing agent tool functions directly within the client browser runtime using JavaScript and Web APIs.

## Architecture, minus the theatre

Rather than routing every tool call through a remote cloud backend, browser-side tools run in the user's browser tab. They can query indexedDB, interact with Canvas/WebGL, perform local cryptographic operations, and mutate local UI state with zero backend latency.

## Anti-pattern

Sending sensitive user browser state to external servers for operations that can be computed locally in JavaScript.

## Production tip

Expose client-side calculators, search indices, and form auto-fillers directly via window.modelContext.tools.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

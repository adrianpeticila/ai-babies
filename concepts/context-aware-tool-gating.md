# Context-Aware Tool Gating

> **Protocols & WebMCP** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Dynamically enabling or masking available tools based on current workflow state, user permissions, and security tier.

## Architecture, minus the theatre

Tool gating dynamically filters the tools array passed to the LLM at each turn. For example, during the 'planning' phase only read-only search tools are exposed; write tools (git push, db update) are gated until an explicit human confirmation is received.

## Anti-pattern

Exposing destructive write tools during preliminary exploratory research phases.

## Production tip

Implement a state machine that gates available tools based on conversation phase and user authorization level.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

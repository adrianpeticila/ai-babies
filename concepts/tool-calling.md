# Tool Calling & Function Calling

> **Agents & Multi-Agent** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Mechanisms allowing LLMs to emit structured JSON arguments matching developer-defined API specifications.

## Architecture, minus the theatre

The model is provided JSON schemas for available functions. When user intent requires external computation, the model pauses generation and emits a structured payload containing function name and arguments. The host application executes the code and returns the result as a tool turn.

## Anti-pattern

Passing 50 mega-schemas in every prompt, which overwhelms context window and degrades parameter accuracy.

## Production tip

Use lazy tool loading or skill paging to load schemas into context only when relevant to the current user objective.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

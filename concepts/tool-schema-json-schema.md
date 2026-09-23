# Tool Schema & JSON Schema Validation

> **Protocols & WebMCP** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Strict mathematical validation of tool argument parameters against Draft-07 JSON Schema specifications.

## Architecture, minus the theatre

Tool schemas must declare parameter types, required fields, enum constraints, and clear property descriptions. Inference engines compile these schemas into grammar logits or validate payloads with Ajv/Pydantic before executing the underlying function.

## Anti-pattern

Leaving parameter descriptions blank or using vague types like object without specifying exact properties.

## Production tip

Write explicit descriptions for every parameter field. The LLM uses parameter descriptions to decide what arguments to construct.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

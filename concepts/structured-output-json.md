# Structured Output & JSON Mode

> **Prompting & Inference** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Constrained decoding enforcing that the model outputs valid JSON conforming strictly to a provided JSON Schema.

## Architecture, minus the theatre

Modern inference engines enforce structured outputs at the logit level via Context-Free Grammars (CFGs). At each step, tokens that violate the JSON Schema are assigned a logit of -infinity, mathematically guaranteeing 100% syntactically valid JSON.

## Anti-pattern

Parsing free-form markdown text with messy regex and praying the model did not add conversational preamble.

## Production tip

Always pass explicit JSON Schemas via native API parameters (response_format / tools) rather than pleading in the system prompt.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

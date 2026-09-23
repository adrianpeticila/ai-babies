# Negative Constraints & Stop Sequences

> **Prompting & Inference** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Tokens or strings that immediately halt generation when emitted by the model during inference.

## Architecture, minus the theatre

Stop sequences allow developers to truncate generation at specific delimiters (e.g. newline Observation:, ```json, </thought>). This prevents rambling, keeps agent turns bounded, and saves token billing costs.

## Anti-pattern

Allowing the model to hallucinate simulated environment responses by forgetting to set tool call stop sequences.

## Production tip

Always register stop sequences for custom XML tags or turn markers when building autonomous agent loops.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

# Zero-Shot & Few-Shot Prompting

> **Prompting & Inference** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Guiding LLM behavior with zero examples versus providing 2-5 explicit input-output demonstration pairs in context.

## Architecture, minus the theatre

Few-shot prompting leverages the transformer's in-context learning capability. By providing 3-5 high-quality examples demonstrating exact formatting, edge cases, and reasoning steps, the model conditions its attention heads to match the desired output distribution without fine-tuning.

## Anti-pattern

Writing 500 words of ambiguous explanatory text when 3 concrete input/output examples would resolve the ambiguity instantly.

## Production tip

Ensure few-shot examples cover negative cases and edge conditions, not just happy-path scenarios.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

# Hallucination & Grounding

> **Foundations** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Generation of factually false or ungrounded assertions presented with high linguistic confidence.

## Architecture, minus the theatre

Hallucination occurs because LLMs optimize for syntactic plausibility rather than empirical truth. When the model lacks sufficient parametric knowledge or faces ambiguous prompts, it generates the most statistically probable continuation regardless of factual accuracy.

## Anti-pattern

Prompting an LLM 'Are you sure?' and expecting factual self-correction without supplying external reference documents.

## Production tip

Ground outputs using strict RAG contexts with explicit negative constraints: 'Answer only using the provided facts. If unknown, state UNKNOWN.'

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

# Retrieval Noise & Distraction

> **RAG & Search** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Irrelevant or conflicting facts in retrieved context that confuse the LLM and induce hallucinated or contradictory outputs.

## Architecture, minus the theatre

When retrieved chunks contain outdated policies, conflicting documentation, or tangential mentions, the model's self-attention heads can attend to incorrect tokens, overriding parametric knowledge with plausible-sounding junk.

## Anti-pattern

Assuming that retrieving 'more data' always improves output quality without aggressive threshold filtering.

## Production tip

Implement a relevance score cut-off (e.g. reranker score >= 0.75). If no chunks pass the threshold, fallback gracefully.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

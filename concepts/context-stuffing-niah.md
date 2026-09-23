# Context Stuffing vs Needle-in-Haystack

> **RAG & Search** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** The failure mode where excessive retrieved context degrades model attention and retrieval recall across long prompts.

## Architecture, minus the theatre

Needle-in-a-Haystack (NIAH) benchmarks measure whether a model can locate a specific fact placed at various depths in a large context. Research proves models suffer from 'Lost in the Middle' degradation when bombarded with 50+ irrelevant chunks.

## Anti-pattern

Dumping 100 pages of raw unranked documentation into the context window and assuming the model will extract the right detail.

## Production tip

Keep final RAG injection contexts under 4,000 tokens of high-relevance, deduplicated, reranked chunks.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

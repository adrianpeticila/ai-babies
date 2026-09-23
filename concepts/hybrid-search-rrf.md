# Hybrid Search & Reciprocal Rank Fusion

> **RAG & Search** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Algorithmic combination of dense vector and lexical search rankings using rank-based reciprocal score aggregation.

## Architecture, minus the theatre

Reciprocal Rank Fusion (RRF) calculates score = sum(1 / (k + rank_i)) across dense and sparse result sets. Because it relies on relative positions rather than uncalibrated raw similarity scores, it produces stable, robust document rankings.

## Anti-pattern

Manually weighting raw cosine scores (0.0-1.0) and BM25 scores (0.0-50.0) with arbitrary multipliers.

## Production tip

Use standard RRF with k=60 as your baseline hybrid search aggregator in all production retrieval pipelines.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

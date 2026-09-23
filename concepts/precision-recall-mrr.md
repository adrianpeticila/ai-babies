# Precision, Recall & MRR for RAG

> **Evals & Benchmarks** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Classical information retrieval metrics measuring search ranking quality: Mean Reciprocal Rank and NDCG.

## Architecture, minus the theatre

MRR (Mean Reciprocal Rank) evaluates how high the first relevant chunk appears in search results: MRR = (1/|Q|) * sum(1/rank_i). NDCG (Normalized Discounted Cumulative Gain) accounts for multi-level relevance across top-K results.

## Anti-pattern

Tuning chunking strategies and embedding models based on visual spot-checks of 3 sample queries.

## Production tip

Build a gold-standard dataset of 100 queries and run automated MRR/NDCG evaluations on every search algorithm change.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

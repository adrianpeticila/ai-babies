# Rerankers (Cross-Encoders)

> **RAG & Search** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Full cross-attention neural models scoring query-document relevance to filter top candidate chunks with high precision.

## Architecture, minus the theatre

While bi-encoders compute embeddings separately, cross-encoders pass the query and candidate chunk together into attention layers, computing full token-to-token cross-attention. This yields vastly superior relevance scoring at the cost of compute latency.

## Anti-pattern

Passing 50 raw vector search results directly to your LLM without a reranking stage, flooding the prompt with irrelevant noise.

## Production tip

Retrieve top-50 chunks via fast hybrid search, then use Cohere Rerank or BGE-Reranker to pass only the top-5 cleanest chunks to the LLM.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

# Vector Databases & HNSW Indexing

> **RAG & Search** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Specialized indexing structures (Hierarchical Navigable Small World) for fast approximate nearest neighbor (ANN) search.

## Architecture, minus the theatre

Exhaustive exact vector comparison is O(N*D), unusable for millions of vectors. HNSW constructs a multi-layer graph where top layers perform long-distance routing and lower layers refine local neighbors, achieving logarithmic O(log N) search speed.

## Anti-pattern

Deploying an external dedicated vector DB cluster for 2,000 documents when SQLite with sqlite-vec or in-memory arrays suffices.

## Production tip

Start simple with embedded vector storage (sqlite-vec / pgvector). Graduate to distributed Qdrant or Milvus only at scale (>1M vectors).

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

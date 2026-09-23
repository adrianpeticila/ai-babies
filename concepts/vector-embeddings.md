# Vector Embeddings

> **RAG & Search** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** High-dimensional dense vector representations capturing semantic meaning and conceptual proximity of text chunks.

## Architecture, minus the theatre

Embedding models (e.g. text-embedding-3-large, voyage-3, bge-large) map variable-length text into fixed-dimension vector spaces (e.g. 1536 or 3072 dims). Proximity is measured via cosine similarity or dot product.

## Anti-pattern

Expecting vector embeddings to excel at exact keyword matches (e.g. SKU codes, error IDs, timestamps).

## Production tip

Normalize embedding vectors to unit length so dot product computation equals cosine similarity at much higher GPU speed.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

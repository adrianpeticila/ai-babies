# Dense vs Sparse Retrieval (BM25)

> **RAG & Search** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Dense retrieval finds conceptual synonyms; sparse retrieval (BM25/SPLADE) matches exact keywords and specialized identifiers.

## Architecture, minus the theatre

Dense vectors understand that 'automobile' equals 'car' but often miss exact part numbers like 'PX-9042'. Sparse retrieval like BM25 scores exact term frequency and inverse document frequency, guaranteeing precision for exact terms.

## Anti-pattern

Building an enterprise search system using purely dense vector embeddings and wondering why users cannot find exact part numbers.

## Production tip

Always combine dense and sparse search into a hybrid pipeline to get the best of both semantic and lexical retrieval.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

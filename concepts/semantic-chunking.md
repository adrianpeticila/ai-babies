# Semantic Chunking vs Sliding Window

> **RAG & Search** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Strategies for breaking long documents into coherent text segments based on semantic boundaries or token lengths.

## Architecture, minus the theatre

Fixed sliding window splitting risks cutting paragraphs mid-thought. Semantic chunking evaluates embedding similarity between adjacent sentences, splitting only when the semantic distance between consecutive thoughts exceeds a threshold.

## Anti-pattern

Arbitrary fixed-character chunking (e.g. split every 500 characters) that cuts code blocks and tables in half.

## Production tip

Use markdown/AST-aware chunking for technical docs and semantic boundary splitting for long-form prose.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

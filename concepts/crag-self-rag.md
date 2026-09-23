# Corrective RAG (CRAG) & Self-RAG

> **RAG & Search** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Dynamic retrieval architectures where the model self-evaluates retrieved chunk quality and triggers fallbacks or web searches.

## Architecture, minus the theatre

CRAG inserts a lightweight evaluator model between retrieval and generation. If retrieved chunks are deemed poor or contradictory, the system triggers web search query generation or refines the query automatically before generating the response.

## Anti-pattern

Blindly trusting the primary retrieval step and generating answers on empty or low-confidence chunks.

## Production tip

Implement a binary confidence check on retrieved context. If low, invoke a web search tool or return an honest 'Data unavailable'.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

# Query Expansion & HyDE

> **RAG & Search** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Generating hypothetical document embeddings (HyDE) or sub-queries to bridge semantic vocabulary gaps between queries and docs.

## Architecture, minus the theatre

Users often ask brief, ambiguous questions ('how do i fix error 504?'). HyDE prompts an LLM to generate a hypothetical answer first, then embeds that synthetic document to search the corpus, aligning query embedding space with document embedding space.

## Anti-pattern

Running HyDE on every single simple query, doubling API latency and cost unnecessarily.

## Production tip

Use HyDE selectively for abstract or short conceptual questions where raw query embeddings perform poorly.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

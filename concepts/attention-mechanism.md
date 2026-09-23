# Attention Mechanism (Q, K, V)

> **Foundations** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Mathematical projection of input vectors into Queries, Keys, and Values to calculate dynamic weighted relevance across all tokens.

## Architecture, minus the theatre

Given input matrix X, projections W_Q, W_K, W_V produce Queries (Q), Keys (K), and Values (V). Attention weights are computed via softmax(Q * K^T / sqrt(d_k)). Multiplying these weights by V yields a contextualized representation where each token aggregates information from all related tokens in the context window.

## Anti-pattern

Failing to realize that attention weights degrade over massive token distances if position embeddings (RoPE/ALiBi) are poorly calibrated.

## Production tip

Keep critical prompt instructions near the beginning or end of the prompt (the 'Lost in the Middle' effect) to maximize attention score allocation.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

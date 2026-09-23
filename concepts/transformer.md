# Transformer Architecture

> **Foundations** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Neural network architecture relying entirely on self-attention mechanisms to compute representations of input sequences in parallel.

## Architecture, minus the theatre

Introduced in 2017 ('Attention Is All You Need'), the transformer eliminated recurrence (RNNs/LSTMs) in favor of stacked Multi-Head Attention and Feed-Forward layers. By computing all token-to-token interactions concurrently during training, transformers unlocked unprecedented scaling laws across GPU clusters.

## Anti-pattern

Assuming self-attention scales linearly with sequence length. Standard self-attention has O(N^2) memory and compute complexity.

## Production tip

In production, use FlashAttention-3 or PagedAttention to eliminate memory-bandwidth bottlenecks in quadratic self-attention matrices.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

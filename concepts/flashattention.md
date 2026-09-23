# FlashAttention (v1/v2/v3)

> **Performance & Speed** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** IO-aware exact attention algorithm tiling computation to minimize high-bandwidth GPU memory (HBM) reads and writes.

## Architecture, minus the theatre

Standard attention reads and writes intermediate N x N attention matrices to slow GPU HBM. FlashAttention tiles the softmax computation in fast on-chip SRAM using online softmax, reducing memory accesses from O(N^2) to O(N) and accelerating attention by 2-4x.

## Anti-pattern

Running vanilla PyTorch attention implementations on long-context models without FlashAttention or SDPA enabled.

## Production tip

Ensure FlashAttention-2 or FlashAttention-3 is installed in your serving environment for instant 2x speedup on Ampere/Hopper GPUs.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

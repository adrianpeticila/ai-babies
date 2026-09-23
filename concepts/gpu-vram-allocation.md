# GPU VRAM Allocation & Overhead

> **Performance & Speed** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Budgeting GPU video memory across model weights, KV cache allocations, activation buffers, and CUDA runtime overhead.

## Architecture, minus the theatre

Total VRAM required = (Model Parameters * Precision Bytes) + KV Cache per Token * Context * Concurrency + Activation Overhead (1-2GB) + CUDA context (0.5-1GB). Running out of VRAM causes fatal CUDA Out-of-Memory (OOM) crashes.

## Anti-pattern

Allocating 99% of VRAM to static model weights without leaving buffer space for the dynamic KV cache of 100 concurrent requests.

## Production tip

Set gpu_memory_utilization=0.90 in vLLM to reserve headroom for transient activations and prevent unexpected OOMs.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

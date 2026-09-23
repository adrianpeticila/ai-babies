# Continuous Batching & PagedAttention

> **Performance & Speed** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Dynamic iteration-level request batching and virtual memory management for KV caches in high-concurrency serving.

## Architecture, minus the theatre

Traditional batching waited for all sequences in a batch to finish. Continuous batching inserts new requests as soon as earlier ones complete. PagedAttention (vLLM) allocates non-contiguous physical memory blocks for KV caches, eliminating 96% of memory fragmentation.

## Anti-pattern

Static batching in production APIs, causing GPUs to idle while waiting for the longest request to finish generating.

## Production tip

Always serve multi-tenant LLM APIs using vLLM, SGLang, or TGI with PagedAttention and continuous batching enabled.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

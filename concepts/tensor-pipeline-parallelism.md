# Tensor & Pipeline Parallelism

> **Performance & Speed** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Distributed computing paradigms splitting individual weight matrices (Tensor) or sequential layers (Pipeline) across multiple GPUs.

## Architecture, minus the theatre

Tensor Parallelism (TP) shards linear projection matrices across GPUs via Megatron-LM (all-reduce communication over NVLink). Pipeline Parallelism (PP) partitions sequential transformer layers across GPUs, using micro-batching to minimize bubble pipeline stalls.

## Anti-pattern

Running Pipeline Parallelism across high-latency ethernet nodes for real-time low-latency chat inference.

## Production tip

Keep Tensor Parallelism within a single NVLink-connected node (e.g. 8x H100s); use Pipeline Parallelism across multi-node clusters for massive models.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

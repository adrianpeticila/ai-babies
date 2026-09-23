# Inter-Token Latency (ITL) & TPS

> **Prompting & Inference** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Core throughput metrics: ITL measures time between consecutive tokens; TPS measures generated tokens per second.

## Architecture, minus the theatre

The decode phase is memory-bandwidth bound: generating each single token requires streaming the entire model weights from GPU DRAM to SRAM. TPS per user equals 1000 / ITL(ms). High TPS requires fast memory bandwidth (HBM3e) or speculative decoding.

## Anti-pattern

Benchmarking single-stream TPS without measuring batch throughput under production concurrency loads.

## Production tip

For human reading interfaces, target 40-80 TPS (25-12ms ITL). Faster rates exceed human reading speed but accelerate agent tool execution.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

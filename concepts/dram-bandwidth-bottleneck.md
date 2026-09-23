# DRAM Memory Bandwidth Bottleneck

> **Performance & Speed** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** The physical hardware limitation where inference speed is constrained by the speed of transferring weights from DRAM to compute cores.

## Architecture, minus the theatre

During autoregressive decoding with batch_size=1, the arithmetic intensity is extremely low (~1 FLOP/byte). A 70B FP16 model requires transferring 140 GB of weights per single token. Even on an H100 with 3.35 TB/s memory bandwidth, theoretical maximum speed is capped at ~24 TPS per single stream.

## Anti-pattern

Assuming adding more compute FLOPS will speed up single-stream autoregressive generation without increasing memory bandwidth.

## Production tip

Use quantization (4-bit/8-bit) and speculative decoding to bypass memory bandwidth bottlenecks.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

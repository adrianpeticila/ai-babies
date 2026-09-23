# Speculative Decoding

> **Performance & Speed** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Inference optimization using a fast draft model to generate candidate tokens verified in parallel by a target model in a single forward pass.

## Architecture, minus the theatre

Autoregressive generation is bottlenecked by GPU DRAM memory bandwidth (reading 140GB of weights per token for a 70B FP16 model). Speculative decoding uses a small draft model (e.g. 1B-3B) to propose K tokens cheaply. The large target model evaluates all K tokens in parallel in one forward pass. Accepted tokens are mathematically lossless.

## Anti-pattern

Using a draft model with low acceptance rate (<50%), which adds drafting overhead without accelerating net throughput.

## Production tip

Ensure draft and target models share the exact same tokenizer and vocabulary to maintain 100% mathematical output parity.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

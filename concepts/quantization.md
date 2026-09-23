# Quantization (GGUF, AWQ, GPTQ)

> **Foundations** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Precision reduction of model weights from FP16 (16-bit) to INT8 or INT4 to slash memory bandwidth and VRAM requirements.

## Architecture, minus the theatre

Quantization maps continuous 16-bit floating point weights to discrete 4-bit or 8-bit integers. AWQ (Activation-aware Weight Quantization) protects critical salient weights; GPTQ performs layer-by-layer second-order error minimization; GGUF standardizes CPU/GPU quantized inference in llama.cpp.

## Anti-pattern

Running unquantized FP16 models on edge devices or consumer GPUs when a 4-bit AWQ model achieves 99% parity at 1/4 the VRAM.

## Production tip

For local and edge serving, 4-bit or 5-bit GGUF/AWQ represents the optimal sweet spot between perceptual perplexity and tokens-per-second throughput.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

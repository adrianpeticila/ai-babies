# Medusa & Multi-Head Speculation

> **Performance & Speed** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Speculative decoding without a separate draft model, using multiple parallel prediction heads added to the main model.

## Architecture, minus the theatre

Medusa adds lightweight multi-head layers on top of the base transformer. Each head predicts tokens at offsets t+1, t+2, t+3 concurrently. A tree-based attention verification step checks candidates in a single forward pass, removing the need to host a secondary draft model in VRAM.

## Anti-pattern

Maintaining two separate model deployments when a single model with Medusa heads achieves equivalent speedups.

## Production tip

Medusa heads are ideal for on-device and single-GPU deployments where VRAM cannot accommodate a secondary draft model.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

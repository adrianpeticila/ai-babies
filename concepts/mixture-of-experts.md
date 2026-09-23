# Mixture of Experts (MoE)

> **Performance & Speed** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Architecture activating only a sparse subset of expert feed-forward networks per token, slashing inference compute.

## Architecture, minus the theatre

In an MoE model (e.g. Mixtral 8x7B, DeepSeek-V3), dense feed-forward layers are replaced with N separate expert networks. A gating router directs each token to top-K experts (e.g. 2 of 8, or 8 of 256). A 671B model can thus execute with only 37B active parameters per token.

## Anti-pattern

Assuming MoE reduces VRAM requirements. All expert weights must remain loaded in VRAM even though only a fraction are active per token.

## Production tip

MoE is the ultimate architecture for high-speed frontier inference: massive parameter capacity with low FLOPS per token.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

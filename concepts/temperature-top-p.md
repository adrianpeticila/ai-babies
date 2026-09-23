# Temperature & Top-p Sampling

> **Foundations** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Hyperparameters controlling randomness and diversity during token probability distribution sampling.

## Architecture, minus the theatre

Temperature divides logits before softmax: low temperature (<0.2) sharpens probabilities toward greedy selection; high temperature (>0.8) flattens distribution for creativity. Top-p (nucleus sampling) truncates the distribution to the smallest set of tokens whose cumulative probability exceeds p.

## Anti-pattern

Setting temperature=0.7 for JSON extraction or deterministic code generation, leading to inconsistent syntax errors.

## Production tip

Use temperature=0.0 and top_p=1.0 for structured data extraction, classification, and code generation. Use temperature=0.7 for marketing copy.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

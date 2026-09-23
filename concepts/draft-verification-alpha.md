# Draft Verification & Acceptance Rate (Alpha)

> **Performance & Speed** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** The statistical metric alpha measuring the average percentage of draft tokens accepted by the target model.

## Architecture, minus the theatre

Expected speedup in speculative decoding is given by S = (1 - alpha^(gamma + 1)) / ((1 - alpha) * (1 + gamma * c)), where gamma is draft length and c is relative cost of draft step. When alpha > 0.8, speculative speedups reach 2.5x-3.5x with zero loss in output quality.

## Anti-pattern

Setting draft length gamma too high (e.g. gamma=10) when alpha is low (0.5), causing wasteful verification passes.

## Production tip

Tune draft speculative length gamma dynamically based on running empirical acceptance rate alpha.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

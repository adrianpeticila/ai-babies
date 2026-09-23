# Large Language Model (LLM)

> **Foundations** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Statistical next-token prediction engine trained on internet-scale text to model probability distributions over token sequences.

## Architecture, minus the theatre

An LLM is fundamentally a conditional probability function P(w_t | w_1, ..., w_{t-1}) parameterized by billions of transformer weights. It does not think, believe, or reason in the human sense; it performs matrix multiplications to minimize cross-entropy loss over vast corpora. Everything from coding to philosophical debate emerges as a byproduct of compression and next-token prediction.

## Anti-pattern

Treating the LLM as an infallible database with intentionality or emotional depth rather than a probabilistic token sequence sampler.

## Production tip

Always treat raw LLM output as untrusted user input. Constrain generation with schemas, grammars, or deterministic verification.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

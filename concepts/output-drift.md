# Output Drift & Non-Determinism

> **Prompting & Inference** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Variability in LLM completions across identical prompts caused by GPU floating-point non-associativity and dynamic routing.

## Architecture, minus the theatre

Even with temperature=0, floating-point addition in parallel GPU kernels (like atomicAdd in CUDA) is non-associative: varying thread scheduling orders introduce minuscule numerical shifts that can flip argmax token selections over long sequences.

## Anti-pattern

Writing unit tests that assert exact character-for-character string equality on non-trivial LLM outputs.

## Production tip

Validate outputs using deterministic schema checkers, semantic assertions, or LLM-as-a-judge rubrics rather than string matching.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

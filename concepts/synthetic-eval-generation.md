# Synthetic Eval Generation

> **Evals & Benchmarks** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Using frontier LLMs to generate high-coverage test suites, edge cases, and golden Q&A pairs from raw documentation.

## Architecture, minus the theatre

Curating manual test cases is expensive and slow. Synthetic eval generation extracts key facts, entities, and scenarios from source documents, then generates diverse user queries, adversarial perturbations, and reference ground truths automatically.

## Anti-pattern

Generating synthetic evals without human expert review of the generated ground-truth answers.

## Production tip

Generate 1,000 synthetic test cases, filter out low-confidence samples with an ensemble of judge models, and verify a 10% random sample with human experts.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

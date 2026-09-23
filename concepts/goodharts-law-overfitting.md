# Overfitting to Benchmarks (Goodhart's Law)

> **Evals & Benchmarks** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** 'When a measure becomes a target, it ceases to be a good measure.' The phenomenon of benchmark contamination in LLM training.

## Architecture, minus the theatre

As benchmark datasets leak into web crawl pre-training corpora or synthetic fine-tuning datasets, model scores skyrocket without translating to real-world performance gains. This creates an illusion of capability that collapses on out-of-distribution tasks.

## Anti-pattern

Selecting an LLM vendor based purely on a marketing radar chart showing high scores on public 2023 benchmarks.

## Production tip

Always test models on internal private evaluation suites containing your company's actual proprietary workflows.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

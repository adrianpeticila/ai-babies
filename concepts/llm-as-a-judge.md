# LLM-as-a-Judge

> **Evals & Benchmarks** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Using a frontier model to evaluate and score open-ended responses from other models based on structured rubrics.

## Architecture, minus the theatre

Pioneered in MT-Bench, LLM-as-a-judge correlates strongly (>80%) with human expert evaluations for open-ended generation. It evaluates criteria like accuracy, helpfulness, tone, and schema compliance. Pairwise comparisons with position swapping mitigate position bias.

## Anti-pattern

Running pairwise LLM judges without swapping output order (A/B vs B/A) to eliminate positional bias.

## Production tip

Use clear 1-5 scoring rubrics with concrete few-shot examples and require the judge model to output its reasoning before assigning a score.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

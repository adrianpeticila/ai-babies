# HumanEval & Code Generation Evals

> **Evals & Benchmarks** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** OpenAI benchmark measuring Python functional correctness via unit tests (pass@k metric).

## Architecture, minus the theatre

HumanEval contains 164 hand-crafted programming problems with docstrings and unit tests. Pass@1 measures the probability that a single sample passes all unit tests. Modern frontier models have saturated this benchmark (>90%).

## Anti-pattern

Using HumanEval as your sole coding metric in 2026; modern models have likely contaminated on its test set.

## Production tip

Graduate to SWE-bench, LiveCodeBench, or internal proprietary test suites for evaluating coding LLMs.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

# SWE-bench & SWE-bench Verified

> **Evals & Benchmarks** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Gold-standard software engineering benchmark evaluating an agent's ability to resolve real GitHub issues from open-source repos.

## Architecture, minus the theatre

SWE-bench tests agents on real-world bug fixes and feature requests from repositories like django, sympy, and scikit-learn. The agent must inspect the repo, locate the bug, write the fix, and pass the hidden repository test suite.

## Anti-pattern

Evaluating coding agents on LeetCode-style synthetic snippets rather than repository-level multi-file benchmarks.

## Production tip

SWE-bench Verified (500 human-validated tasks) is the single best predictor of real-world coding agent effectiveness.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

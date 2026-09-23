# Harbour & Environment Evals

> **Evals & Benchmarks** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Standardized execution environments evaluating agents on interactive multi-step tasks across real software stacks.

## Architecture, minus the theatre

Unlike static text evals, environment evals test agents in real stateful systems (Docker containers, bash shells, browsers, databases). Tasks specify a World Spec (setup code, dependencies) and Task Spec (instructions, pass/fail verification assertions).

## Anti-pattern

Testing autonomous agent capabilities with mock static responses instead of live stateful sandboxes.

## Production tip

Package your real integration tests into reproducible Docker environment specs to evaluate agents on your actual stack.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

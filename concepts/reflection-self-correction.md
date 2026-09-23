# Reflection & Self-Correction Loops

> **Agents & Multi-Agent** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Mechanisms where an agent inspects its own execution traces, terminal errors, or test failures to self-correct.

## Architecture, minus the theatre

When a tool fails (e.g. a Python syntax error or pytest failure), the error trace is fed back into the context. The agent reflects on the root cause, modifies its code, and re-executes tests iteratively until all assertions pass.

## Anti-pattern

Repeating the exact same failed command in an infinite loop without reading the stderr output.

## Production tip

Limit self-correction loops to 3 attempts. If failing continuously, prompt the agent to change strategy or ask for human guidance.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

# Autonomous Agent

> **Agents & Multi-Agent** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** An LLM-driven loop equipped with planning, tools, and memory to execute multi-step objectives autonomously.

## Architecture, minus the theatre

An autonomous agent operates via an iterative control loop: perceive environment state -> reason about next action -> execute tool call -> observe result -> update memory. Autonomy terminates when the goal condition is met or maximum steps are reached.

## Anti-pattern

Giving an unconstrained agent write access to production databases or unrestricted bash shells without sandboxing.

## Production tip

Enforce strict step limits, circuit breakers, deterministic guardrails, and human-in-the-loop approvals on destructive actions.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

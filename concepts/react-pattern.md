# ReAct Pattern (Reason + Act)

> **Agents & Multi-Agent** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Agent architecture interleaving step-by-step verbal reasoning (Thought) with tool executions (Action) and feedback (Observation).

## Architecture, minus the theatre

Proposed by Yao et al. (2022), ReAct alternates between: Thought: [analyze current state], Action: [invoke tool with args], and Observation: [tool output returned from environment]. This interleaving dramatically reduces hallucination and improves tool parameter accuracy.

## Anti-pattern

Executing tool calls blindly without giving the model a reasoning step to plan parameter values.

## Production tip

Use native tool calling APIs with XML thought tags to maintain clean separation between reasoning and structured tool payloads.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

# Proactive Agent Traps & Infinite Loops

> **Agents & Multi-Agent** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Common failure modes where background tasks, recurring crons, or ambiguous exit conditions trap agents in infinite execution.

## Architecture, minus the theatre

Agents with cron or sleep capabilities often launch background polling loops that never terminate. Without strict timeout conditions, thread depth limits, or reactive wakeup hooks, agent processes consume infinite API tokens.

## Anti-pattern

Running while True: sleep(5) inside an agent bash tool instead of reactive event-driven scheduling.

## Production tip

Enforce maximum step limits (e.g. 25 steps per thread) and use event-based reactive triggers instead of polling loops.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

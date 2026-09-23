# Human-in-the-Loop (HITL) & Gatekeeping

> **Agents & Multi-Agent** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Security and workflow checkpoints where autonomous agents pause execution to await explicit human approval.

## Architecture, minus the theatre

HITL gates critical operational boundaries: git pushes, database writes, financial transactions, email sends, or cloud deployments. The agent generates a structured proposal with a diff or action summary, pausing state until an authorized human signs off.

## Anti-pattern

Full unconstrained autonomy on irreversible actions, resulting in accidental data drops or unauthorized emails.

## Production tip

Categorize actions into 3 buckets: Autonomous (read/test/lint), Conditional (build/format), and Gatekept (deploy/delete/publish).

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

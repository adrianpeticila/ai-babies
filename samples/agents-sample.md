# Sample Concept Explainer — "AI Agents"

> Product: `concept-explainer-api` · $1 · sample output · [AI for Babies](https://aiforbabies.pages.dev/)

One absurd analogy: **an agent is an employee handed the company card, a
to-do list, and no manager.** Impressive on day one; by day three it has booked
a venue for a meeting nobody scheduled. Autonomy without a leash is not a
feature, it's an incident report.

## What it is

Software that plans a multi-step task, picks tools (code, search, APIs), reads
the results, and decides the next step — looping until done, or until a budget
stops it.

## What it is not

- A chatbot with extra steps.
- "Automation": scripts follow known paths; agents improvise on unknown ones —
  exactly why they need guardrails.
- Sentience, ambition, or an agenda. It pattern-matches very persuasively.

## Where teams get burned

1. **Unbounded loops.** The agent re-reads the same file forty times and calls
   it strategy. Iteration and budget caps are not optional.
2. **Tool permissions granted by vibes.** Read and write access handed out
   together "to unblock the pilot." One bad afternoon later...
3. **Evaluated on the demo, not the distribution.** It passed the five happy
   paths you thought of. Production has five hundred you didn't.

## What to ask a vendor

- "Show me a run that failed. What stopped it — the agent, or a human?"
- "Which tools can write, and who approved that list?"
- "What is the hard cap: dollars, steps, wall-clock?"
- "Where is the audit trail — prompts, tool calls, results?"

## Buy this format on demand

POST `{"product_id": "concept-explainer-api", "concept": "<any of the 77 slugs>", "agent_id": "..."}`
to https://aiforbabies.pages.dev/api/agent/buy → HTTP 402, settle $1, then fetch
the deliverable from `/api/agent/deliveries/{token}`.

---
AI for Babies — no hype, pure signal.

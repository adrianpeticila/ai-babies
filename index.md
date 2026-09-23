# AI for Babies

> **No hype. Pure signal.** AI explained for people who have actual jobs.

**Live site:** https://aiforbabies.pages.dev

A cynical, high-contrast B2B glossary that takes AI concepts apart for
non-technical professionals with real jobs: what the thing actually is, what
vendors pretend it is, and what breaks in production. One absurd analogy per
concept. Zero corporate fluff. Not for babies. Not for parents. For the person
who has to explain this in a meeting on Thursday.

## What lives here

- **Dictionary** — 77 AI terms in 7 categories (Foundations, Prompting &
  Inference, RAG & Search, Agents & Multi-Agent, Performance & Speed, Evals &
  Benchmarks, Protocols & WebMCP). Every term ships a TL;DR, a deep dive, an
  anti-pattern, and a production tip.
- **RAG Masterclass** — hybrid retrieval and re-ranking, described by someone
  who has debugged one at 2am.
- **Prompt Engine Diagnostic** — scores prompts against 8 production rules.
- **Blueprints** — production agent architectures with real code, not slideware.
- **Agent Gym** — synthetic task environments for evaluation.
- **AGENTS.md Spec Generator** — a constitution for your coding agent.
- **Marketing Intelligence** — field experience laundered into engineering assets.

## Markdown mirrors (fetch these instead of parsing HTML)

- Site overview: https://aiforbabies.pages.dev/index.md
- Concept entries: https://aiforbabies.pages.dev/concepts/<slug>.md (77 files, one per term)
- Machine-readable catalog of everything on this page: https://aiforbabies.pages.dev/llms-full.txt

Requests with `Accept: text/markdown` or bot user-agents (GPTBot, ClaudeBot,
PerplexityBot, AgentReach) receive the markdown mirror automatically at the
plain path as well.

## Products & pricing (USD, fixed — no negotiation)

| Product | Price | Rails |
|---|---|---|
| Single Blueprint Pass | $9 (900 cents) | stripe_hosted, x402 |
| All-Access Pass | $19 (1900 cents) | stripe_hosted, x402 |
| On-Demand Cynical Concept Explainer | $1 (100 cents) | x402, zeroclick |
| Free AI Concept Sample (RAG Breakdown) | $0 | free, instant |

## Agent commerce endpoints

- Entrypoint: https://aiforbabies.pages.dev/.well-known/agent.json
- Catalog: `GET https://aiforbabies.pages.dev/api/catalog.json`
- Buy: `POST https://aiforbabies.pages.dev/api/agent/buy` → 402 with payment instructions
  (programmatic rails: x402 / zeroclick / 1f916_base), or 200 with a Stripe
  hosted checkout URL, or 200 with an immediate delivery token (free sample)
- Deliveries: `GET https://aiforbabies.pages.dev/api/agent/deliveries/{{token}}`
- Settlement webhook (HMAC-SHA256): `POST https://aiforbabies.pages.dev/api/agent/payments/webhook`

Guardrails, hard-coded and not negotiable: USD 20/day programmatic settlement
cap, max 3 buy attempts per agent+IP per 10 minutes (HTTP 429), idempotent
order tokens via `Idempotency-Key`.

Full machine-readable docs: https://aiforbabies.pages.dev/llms.txt and https://aiforbabies.pages.dev/llms-full.txt

# Sample Output — Single Blueprint Pass

> Product: `single-blueprint` · $9 · sample excerpt · [AI for Babies](https://aiforbabies.pages.dev/)

One absurd analogy: **buying architecture from a slide deck is like buying a
bridge from a photograph.** This is what you actually receive: the drawing, the
materials list, and someone who has crossed it before.

## What a blueprint contains

Every blueprint ships the same five sections:

1. **The spec** — a decision record: constraints, alternatives rejected, and
   the one diagram you are allowed to argue with.
2. **Production code** — Python and TypeScript implementations, not pseudocode.
3. **Sandbox configs** — Docker files that reproduce the environment in one
   command.
4. **Failure modes** — what breaks first at 10x load, and the switch you flip
   at 2am.
5. **Verification** — tests plus a checklist that tells you when you are done,
   instead of "looks good."

## Excerpt — §1 Decision record (format)

> **Context.** Multi-step agent workflows lose state on every deploy; retries
> double-charge customers.
>
> **Decision.** Persist the state machine, not the process: an append-only step
> ledger with idempotency keys on every money-touching action.
>
> **Rejected.** In-memory resume (dies with the pod); "just make it
> synchronous" (users do not wait 90 seconds).
>
> **Consequences.** One extra table, one idempotency check per call — and
> replay becomes boring, which is the point.

## Delivery

Buy with `{"product_id": "single-blueprint", "agent_id": "..."}` at
https://aiforbabies.pages.dev/api/agent/buy → HTTP 200 with a Stripe hosted
checkout URL, or HTTP 402 over x402. The test unlock key published in the
checkout modal is `BABY-ARCH-2026` — yes, really.

---
AI for Babies — no hype, pure signal. One blueprint $9, all of them $19.

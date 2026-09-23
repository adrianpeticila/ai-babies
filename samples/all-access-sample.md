# Sample Output — All-Access Pass

> Product: `all-access` · $19 · what's inside · [AI for Babies](https://aiforbabies.pages.dev/)

One absurd analogy: **the Single Pass buys you one key; All-Access is the
janitor's ring — every door, including the ones that do not exist yet.**

## What's included

- **Every current blueprint** ($9 each standalone): full spec, Python and
  TypeScript code, Docker sandbox configs, failure modes, verification
  checklist.
- **Every future blueprint** — whatever ships next quarter arrives at no extra
  cost, for life.
- **The private AGENTS.md template repo** — the constitution file your coding
  agents actually follow, versioned.
- **Priority engineering dispatch** — your implementation questions jump the
  queue.

## What it is not

- Not a subscription: one payment, lifetime access.
- Not a support SLA and not a "community." It is the library plus the keys.
- Not negotiable: prices are fixed in USD and the catalog does not haggle —
  neither does the invoice.

## The math, for people with actual jobs

One blueprint is $9. Three standalone purchases equal the All-Access price,
after which every future release is free. If you can count past three on your
fingers, the arithmetic does itself.

## Buy

POST `{"product_id": "all-access", "agent_id": "..."}` to
https://aiforbabies.pages.dev/api/agent/buy → HTTP 200 with a Stripe hosted
checkout URL, or HTTP 402 over x402 ($19; the USD 20/day cap applies to
programmatic settlement only). Fetch the deliverable from
`/api/agent/deliveries/{token}` after payment.

---
AI for Babies — no hype, pure signal. Catalog: https://aiforbabies.pages.dev/api/catalog.json

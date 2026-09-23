![AI for Babies Suite](assets/ai-babies-banner.svg)

# AI for Babies

> **No hype. Pure signal.**
> High-contrast developer-first engineering suite explaining LLMs, RAG architectures, Agent workflows, inference optimization, and marketing intelligence without corporate fluff.

Live Platform: [https://aiforbabies.pages.dev](https://aiforbabies.pages.dev)
Full LLM Documentation: [https://aiforbabies.pages.dev/llms-full.txt](https://aiforbabies.pages.dev/llms-full.txt)
WebMCP Tool Spec: [https://aiforbabies.pages.dev/.well-known/webmcp.json](https://aiforbabies.pages.dev/.well-known/webmcp.json)

---

## Official Products

- **AI for Babies: Early Cognitive & Soundscapes Pack 0-12M** ($38 / $68)
  Get it on Gumroad: [https://aiforbabies.gumroad.com/l/cognitive-pack](https://aiforbabies.gumroad.com/l/cognitive-pack)
- **Web Developer Blueprints** ($9 / $19 on Stripe)

---

## Core Capabilities

1. **77 Essential AI Terms**: Complete reference dictionary across 7 engineering categories (11 terms each) with deep architecture breakdowns, anti-patterns, and production tips.
2. **Prompt Engine Diagnostic**: Automated tool scoring prompts against 8 strict production rules (negative constraints, schemas, few-shots, token boundaries).
3. **RAG Masterclass**: Foundations to production: Hybrid BM25+Dense retrieval, Reciprocal Rank Fusion, and Cross-Encoder reranking simulator.
4. **AGENTS.md Linux Foundation Standard**: Specification generator creating standardized constitutions for autonomous coding agents.
5. **100k Tool Scaling & RAM Paging**: Dynamic skill paging pattern preventing context bloat across massive tool libraries.
6. **Speculative Decoding Speed Lab**: Mathematical latency simulator computing speedup factors bypassing GPU DRAM bandwidth bottlenecks.
7. **Agent Gym & Environment Simulator**: Synthetic task generation and Harbour evaluation frameworks.
8. **WebMCP Protocol Integration**: Browser-side tool exposure via `window.modelContext` and `/.well-known/webmcp.json`.
9. **Marketing Intelligence Layer**: 4-stage pipeline distilling proprietary field experience into sanitized engineering assets.
10. **AI Spec PRD Framework**: 6-pillar specification builder bridging product vision and autonomous execution.

---

## WebMCP Tools Implemented

The platform natively implements 4 client-side WebMCP tools:
- `search_dictionary`: Query all 77 categorized AI concepts.
- `diagnose_prompt`: Audit prompts against 8 production rules.
- `generate_agent_spec`: Build standardized AGENTS.md configurations.
- `calculate_speculative_speed`: Compute speculative decoding speedups.

---

## Design Philosophy

- **Strict 2-Color Monochrome**: #FFFFFF background, #F9FAFB panels, #111827 high-contrast slate text and borders.
- **Zero Third-Party Tracking**: No telemetry, no external ad scripts, no bloat.
- **Agent First**: High-density semantic view for LLM web crawlers (`?agent=1` or `[Agent Mode]`).

---

## Operations — production activation checklist (agent commerce)

The agent commerce endpoints — `/api/catalog.json`, `/api/agent/buy`,
`/api/agent/deliveries/{token}`, `/api/agent/payments/webhook` — run as
Cloudflare Pages Functions on the `aiforbabies` project (edge-native, no
external Node daemon). Before they work in production, the operator must:

- [ ] Create a KV namespace and bind it to the Pages project as **`AGENT_STORE`**
      (Dashboard → Workers & Pages → `aiforbabies` → Settings → Functions → KV
      namespace bindings). Without it every commerce endpoint answers
      **503 `storage_unavailable`** — fail-closed by design, never silent memory.
- [ ] Set the secret **`PAYMENT_WEBHOOK_SECRET`** (Settings → Environment
      variables → Production). Without it the webhook answers
      **503 `secret_not_configured`** (fail-closed). Signatures are
      `X-Signature: sha256=<hex HMAC-SHA256 of the raw request body>`.
- [ ] Optional: set **`X402_PAYTO_ADDRESS`** so 402 responses carry a real
      settlement address. Until then the 402 body says so explicitly and
      recommends the `stripe_hosted` rail.
- [ ] Deploy: `npx wrangler pages deploy site --project-name=aiforbabies`.
      The `aiforbabies` project **is** git-connected to this repo (branch
      `main`), but its last production deployment is commit `4e82239` — six
      commits behind `main` as of 2026-09-23 — so `git push` alone has not been
      publishing. The direct upload above is deterministic; if you prefer the
      git integration, repair/confirm it in the dashboard first. Deploying also
      publishes the current `site/` content, which is newer than what live
      serves today.
- [ ] Verify the deployment actually landed. Pages answers missing paths with a
      `200 text/html` fallback, so status codes alone prove nothing:
      `curl -s https://aiforbabies.pages.dev/api/catalog.json | head -c 40`
      must print JSON, not `<!DOCTYPE html>`, and
      `curl -sI https://aiforbabies.pages.dev/index.md` must say
      `content-type: text/markdown`. Then run
      `bash tests/verify_agent_flow.sh` (84 checks, boots its own isolated
      instance).

Local development and the verification harness need none of the above:
`wrangler pages dev` with `--kv AGENT_STORE` and
`--binding PAYMENT_WEBHOOK_SECRET=...` is sufficient.


---

## License

MIT License. Open engineering standard.

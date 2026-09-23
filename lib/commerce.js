/**
 * AI for Babies — shared core for the agent commerce Pages Functions.
 *
 * This module is intentionally public (it is served as a static asset): it
 * contains product data and protocol helpers, no secrets. Secrets come from
 * environment bindings — PAYMENT_WEBHOOK_SECRET, X402_PAYTO_ADDRESS — and all
 * mutable state (orders, idempotency records, rate windows, daily ledger)
 * lives in the KV binding AGENT_STORE. Missing store => fail-closed 503.
 */

export const HOST = "https://aiforbabies.pages.dev";

// Option A guardrails — hard-coded, not configurable at runtime.
export const CAP_USD_CENTS = 2000; // USD 20/day programmatic settlement cap
export const RATE_LIMIT = 3;
export const RATE_WINDOW_MS = 10 * 60 * 1000; // 10 minutes
export const MAX_BODY_BYTES = 64 * 1024;

// The programmatic family all answers HTTP 402 (Option A).
export const PROGRAMMATIC_RAILS = ["x402", "zeroclick", "1f916_base"];
export const ALL_RAILS = [...PROGRAMMATIC_RAILS, "stripe_hosted", "free"];

// Live Stripe Payment Links (verified against index.html checkout modal).
const STRIPE_URLS = {
  "single-blueprint": "https://buy.stripe.com/9B6bJ175S2z3gv62I39k400",
  "all-access": "https://buy.stripe.com/aFa4gz89WddHemY82n9k401",
};

export const PRODUCTS = [
  {
    id: "single-blueprint",
    name: "Single Blueprint Pass",
    price_cents: 900,
    currency: "USD",
    description:
      "One production blueprint of your choice: full deep-dive specification, Python and TypeScript implementation, Docker sandbox configs, and lifetime updates for the blueprint you pick. Delivered after checkout.",
    sample_output_url: `${HOST}/samples/blueprint-sample.md`,
    checkout_type: "stripe_hosted",
    rails: ["stripe_hosted", ...PROGRAMMATIC_RAILS],
  },
  {
    id: "all-access",
    name: "All-Access Pass",
    price_cents: 1900,
    currency: "USD",
    description:
      "Every current blueprint plus all future ones, the private AGENTS.md template repo, and priority engineering dispatch. One payment, lifetime access.",
    sample_output_url: `${HOST}/samples/all-access-sample.md`,
    checkout_type: "stripe_hosted",
    rails: ["stripe_hosted", ...PROGRAMMATIC_RAILS],
  },
  {
    id: "concept-explainer-api",
    name: "On-Demand Cynical Concept Explainer",
    price_cents: 100,
    currency: "USD",
    description:
      "One AI concept of your choice, delivered as a cynical no-jargon explainer: what it is, what it is not, where teams get burned, and what to ask the vendor. Machine-readable over the deliveries endpoint.",
    sample_output_url: `${HOST}/samples/agents-sample.md`,
    checkout_type: "x402",
    rails: [...PROGRAMMATIC_RAILS],
  },
  {
    id: "sample-concept",
    name: "Free AI Concept Sample (RAG Breakdown)",
    price_cents: 0,
    currency: "USD",
    description:
      "Free RAG breakdown sample: how retrieval-augmented generation actually works, the three places it silently fails, and the questions that expose a demo disguised as a product. No checkout, delivered immediately.",
    sample_output_url: `${HOST}/samples/rag-sample.md`,
    checkout_type: "free",
    rails: ["free"],
  },
];

export function productById(id) {
  return PRODUCTS.find((p) => p.id === id) || null;
}

/** The catalog contract: exactly these 7 keys, no more, no less. */
export function catalogItem(p) {
  return {
    id: p.id,
    name: p.name,
    price_cents: p.price_cents,
    currency: p.currency,
    description: p.description,
    sample_output_url: p.sample_output_url,
    checkout_type: p.checkout_type,
  };
}

export function stripeUrl(product) {
  return STRIPE_URLS[product.id] || null;
}

export function isProgrammatic(rail) {
  return PROGRAMMATIC_RAILS.includes(rail);
}

// ---------------------------------------------------------------------------
// HTTP helpers
// ---------------------------------------------------------------------------
export function json(data, status = 200, extraHeaders = {}) {
  return new Response(JSON.stringify(data, null, 2) + "\n", {
    status,
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Access-Control-Allow-Origin": "*",
      ...extraHeaders,
    },
  });
}

export function markdown(body, status = 200, extraHeaders = {}) {
  return new Response(body.endsWith("\n") ? body : body + "\n", {
    status,
    headers: {
      "Content-Type": "text/markdown; charset=utf-8",
      "Access-Control-Allow-Origin": "*",
      ...extraHeaders,
    },
  });
}

export function clientIp(request) {
  return request.headers.get("CF-Connecting-IP") || "unknown";
}

// ---------------------------------------------------------------------------
// State (KV binding AGENT_STORE) — fail-closed when absent.
// AGENT_STATE_NS prefixes every key so test runs stay isolated; production
// leaves it unset. The prefix isolates storage, never limits it.
// ---------------------------------------------------------------------------
export function store(env) {
  return env.AGENT_STORE || null;
}

function stateKey(env, k) {
  const pfx = env.AGENT_STATE_NS ? `${env.AGENT_STATE_NS}:` : "";
  return pfx + k;
}

export function newOrderToken() {
  return `ord_${crypto.randomUUID()}`;
}

export async function getOrder(env, token) {
  const s = store(env);
  if (!s || !token || typeof token !== "string") return null;
  return s.get(stateKey(env, `ord:${token}`), "json");
}

export async function putOrder(env, order) {
  const s = store(env);
  if (!s) throw new Error("AGENT_STORE not bound");
  await s.put(stateKey(env, `ord:${order.token}`), JSON.stringify(order), {
    expirationTtl: 90 * 24 * 3600,
  });
}

export async function getIdem(env, hash) {
  const s = store(env);
  if (!s) return null;
  return s.get(stateKey(env, `idem:${hash}`), "json");
}

export async function putIdem(env, hash, token) {
  const s = store(env);
  if (!s) throw new Error("AGENT_STORE not bound");
  await s.put(stateKey(env, `idem:${hash}`), JSON.stringify({ token }), {
    expirationTtl: 24 * 3600,
  });
}

/** True when this attempt fits the 3/10min window; false => caller answers 429. */
export async function registerAttempt(env, ip, identity) {
  const s = store(env);
  if (!s) throw new Error("AGENT_STORE not bound");
  const k = stateKey(env, `rl:${ip}|${identity}`);
  const now = Date.now();
  let attempts = (await s.get(k, "json")) || [];
  attempts = attempts.filter((t) => now - t < RATE_WINDOW_MS);
  if (attempts.length >= RATE_LIMIT) return false;
  attempts.push(now);
  await s.put(k, JSON.stringify(attempts), { expirationTtl: 600 });
  return true;
}

export function utcDay() {
  return new Date().toISOString().slice(0, 10);
}

/** Cents settled today over programmatic rails (UTC day). */
export async function ledgerCents(env) {
  const s = store(env);
  if (!s) throw new Error("AGENT_STORE not bound");
  const rec = await s.get(stateKey(env, `ledger:${utcDay()}`), "json");
  return rec ? rec.usd_cents : 0;
}

export async function ledgerAdd(env, cents) {
  const total = (await ledgerCents(env)) + cents;
  const s = store(env);
  await s.put(
    stateKey(env, `ledger:${utcDay()}`),
    JSON.stringify({ usd_cents: total }),
    { expirationTtl: 2 * 24 * 3600 }
  );
  return total;
}

// ---------------------------------------------------------------------------
// Crypto helpers (WebCrypto — edge-native, no Node imports)
// ---------------------------------------------------------------------------
function toHex(buf) {
  return [...new Uint8Array(buf)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

export async function sha256Hex(text) {
  const buf = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(text));
  return toHex(buf);
}

export async function hmacSha256Hex(secret, text) {
  const key = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"]
  );
  const sig = await crypto.subtle.sign("HMAC", key, new TextEncoder().encode(text));
  return toHex(sig);
}

/** Accepts `sha256=<hex>` or bare hex; returns canonical lowercase hex or null. */
export function normalizeSignature(headerValue) {
  if (!headerValue || typeof headerValue !== "string") return null;
  let v = headerValue.trim();
  if (v.toLowerCase().startsWith("sha256=")) v = v.slice(7);
  v = v.trim().toLowerCase();
  return /^[0-9a-f]{64}$/.test(v) ? v : null;
}

export function timingSafeEqualHex(a, b) {
  if (typeof a !== "string" || typeof b !== "string" || a.length !== b.length) {
    return false;
  }
  let diff = 0;
  for (let i = 0; i < a.length; i += 1) diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return diff === 0;
}


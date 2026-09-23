/**
 * POST /api/agent/buy — Option A purchase entrypoint.
 *
 *  - programmatic rails (x402 / zeroclick / 1f916_base) -> HTTP 402 with payment
 *    instructions, subject to the USD 20/day settlement cap at webhook time
 *  - stripe_hosted -> HTTP 200 with the real hosted checkout URL (unlimited)
 *  - free sample   -> HTTP 200 with an immediate paid delivery token
 *
 * Guardrails: 400 malformed body / missing identity / bad rail, 404 unknown
 * product, 429 more than 3 attempts per agent+IP per 10 minutes, idempotent
 * replays via Idempotency-Key, 503 fail-closed when KV is not bound.
 */
import {
  HOST,
  ALL_RAILS,
  MAX_BODY_BYTES,
  json,
  clientIp,
  store,
  productById,
  stripeUrl,
  isProgrammatic,
  registerAttempt,
  getIdem,
  putIdem,
  putOrder,
  getOrder,
  sha256Hex,
  newOrderToken,
} from "../../../lib/commerce.js";
import { SLUGS } from "../../../lib/concepts-data.js";

const CORS_EXTRA = { "Access-Control-Allow-Origin": "*" };

function deliveryUrl(token) {
  return `${HOST}/api/agent/deliveries/${token}`;
}

/** Deterministic response for an order — used by create AND idempotent replay. */
function buildBuyResponse(order, product, env) {
  if (order.rail === "free") {
    return {
      status: 200,
      payload: {
        checkout_type: "free",
        product_id: order.product_id,
        order_token: order.token,
        rail: "free",
        status: "paid",
        price_cents: order.price_cents,
        currency: "USD",
        delivery_url: deliveryUrl(order.token),
      },
    };
  }
  if (order.rail === "stripe_hosted") {
    return {
      status: 200,
      payload: {
        checkout_type: "stripe_hosted",
        product_id: order.product_id,
        order_token: order.token,
        rail: "stripe_hosted",
        status: "awaiting_payment",
        price_cents: order.price_cents,
        currency: "USD",
        checkout_url: stripeUrl(product),
        delivery_url: deliveryUrl(order.token),
      },
    };
  }
  const payTo = env.X402_PAYTO_ADDRESS || null;
  return {
    status: 402,
    payload: {
      error: "payment_required",
      product_id: order.product_id,
      order_token: order.token,
      status: "awaiting_payment",
      price_cents: order.price_cents,
      usd_cents: order.price_cents,
      currency: "USD",
      rail: order.rail,
      settlement: {
        cap_usd_daily: 20,
        currency: "USD",
        webhook: `${HOST}/api/agent/payments/webhook`,
        signature_header: "X-Signature",
        algorithm: "hmac-sha256",
      },
      payment: {
        protocol: order.rail,
        asset: "USDC",
        pay_to: payTo,
        note: payTo
          ? "Settle USDC to pay_to, then POST the settlement webhook above."
          : "No x402 settlement address configured on this deployment; use rail stripe_hosted (single-blueprint, all-access) until X402_PAYTO_ADDRESS is set.",
      },
      delivery_url: deliveryUrl(order.token),
    },
  };
}

export function onRequestOptions() {
  return new Response(null, {
    status: 204,
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type, Idempotency-Key",
    },
  });
}

export async function onRequestPost(context) {
  const { request, env } = context;

  // Fail-closed when the state store is not bound (misconfigured deploy).
  if (!store(env)) {
    return json(
      { error: "storage_unavailable", detail: "AGENT_STORE KV binding missing" },
      503,
      CORS_EXTRA
    );
  }

  const raw = await request.text();
  if (raw.length > MAX_BODY_BYTES) {
    return json(
      { error: "malformed_body", detail: "payload exceeds 64KB" },
      400,
      CORS_EXTRA
    );
  }
  let body;
  try {
    body = JSON.parse(raw);
  } catch {
    return json(
      { error: "malformed_body", detail: "invalid JSON" },
      400,
      CORS_EXTRA
    );
  }
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return json(
      { error: "malformed_body", detail: "JSON object expected" },
      400,
      CORS_EXTRA
    );
  }

  const productId =
    typeof body.product_id === "string" ? body.product_id.trim() : "";
  if (!productId) {
    return json(
      { error: "invalid_request", detail: "product_id is required" },
      400,
      CORS_EXTRA
    );
  }

  const agentId = typeof body.agent_id === "string" ? body.agent_id.trim() : "";
  const email = typeof body.email === "string" ? body.email.trim() : "";
  const identity = agentId || email;
  if (!identity) {
    return json(
      { error: "identity_required", detail: "agent_id or email is required" },
      400,
      CORS_EXTRA
    );
  }

  const ip = clientIp(request);

  // An idempotent replay short-circuits BEFORE the rate window: replaying a
  // recorded intent is not a new attempt.
  const idemRaw = request.headers.get("Idempotency-Key");
  if (idemRaw && idemRaw.length <= 200) {
    const idemHash = await sha256Hex(`${ip}|${identity}|${idemRaw}`);
    const rec = await getIdem(env, idemHash);
    if (rec) {
      const order = await getOrder(env, rec.token);
      if (order) {
        const product = productById(order.product_id);
        const built = buildBuyResponse(order, product, env);
        return json(built.payload, built.status, {
          ...CORS_EXTRA,
          "Idempotency-Replayed": "true",
        });
      }
    }
  }

  const allowed = await registerAttempt(env, ip, identity);
  if (!allowed) {
    return json(
      {
        error: "rate_limited",
        detail: "max 3 buy attempts per agent+IP per 10 minutes",
        retry_after_seconds: 600,
      },
      429,
      { ...CORS_EXTRA, "Retry-After": "600" }
    );
  }

  const product = productById(productId);
  if (!product) {
    return json({ error: "unknown_product", product_id: productId }, 404, CORS_EXTRA);
  }

  const rail = body.rail === undefined ? product.rails[0] : body.rail;
  if (typeof rail !== "string" || !ALL_RAILS.includes(rail)) {
    return json(
      { error: "unknown_rail", rail, allowed: ALL_RAILS },
      400,
      CORS_EXTRA
    );
  }
  if (!product.rails.includes(rail)) {
    return json(
      {
        error: "rail_not_available",
        product_id: product.id,
        rail,
        available: product.rails,
      },
      400,
      CORS_EXTRA
    );
  }

  let concept = null;
  if (product.id === "concept-explainer-api") {
    concept = typeof body.concept === "string" ? body.concept.trim() : "";
    if (!concept) {
      return json(
        {
          error: "concept_required",
          detail: "concept-explainer-api requires a concept slug",
        },
        400,
        CORS_EXTRA
      );
    }
    if (!/^[a-z0-9-]{1,60}$/.test(concept) || !SLUGS.includes(concept)) {
      return json(
        {
          error: "unknown_concept",
          concept,
          detail: "slug must exist in the 77-term dictionary",
        },
        400,
        CORS_EXTRA
      );
    }
  }

  const nowIso = new Date().toISOString();
  const order = {
    token: newOrderToken(),
    product_id: product.id,
    price_cents: product.price_cents,
    currency: "USD",
    rail,
    concept,
    agent_id: agentId || null,
    email: email || null,
    ip,
    status: rail === "free" ? "paid" : "awaiting_payment",
    created_at: nowIso,
    paid_at: rail === "free" ? nowIso : null,
    held_reason: null,
    settled_by: null,
    reference: null,
  };
  await putOrder(env, order);

  if (idemRaw && idemRaw.length <= 200) {
    const idemHash = await sha256Hex(`${ip}|${identity}|${idemRaw}`);
    await putIdem(env, idemHash, order.token);
  }

  const built = buildBuyResponse(order, product, env);
  return json(built.payload, built.status, CORS_EXTRA);
}


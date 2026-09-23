/**
 * GET /api/agent/deliveries/:token — machine-readable paid deliverables.
 *
 *  - 404 unknown token
 *  - 402 awaiting_payment (settle first)
 *  - 403 held_for_review (over the USD 20/day programmatic cap, manual release)
 *  - 200 paid: JSON by default; `Accept: text/markdown` (or a bot user-agent)
 *    returns the deliverable as clean markdown.
 *  - 503 fail-closed when the AGENT_STORE KV binding is missing.
 */
import {
  HOST,
  json,
  markdown,
  store,
  getOrder,
  productById,
} from "../../../../lib/commerce.js";
import { CONCEPTS } from "../../../../lib/concepts-data.js";

const BOT_UA = /GPTBot|ClaudeBot|PerplexityBot|AgentReach/i;

function wantsMarkdown(request) {
  const accept = request.headers.get("accept") || "";
  if (accept.includes("text/markdown")) return true;
  return BOT_UA.test(request.headers.get("user-agent") || "");
}

function deliverableFor(order, product) {
  if (order.product_id === "sample-concept") {
    return { type: "sample_markdown", url: product.sample_output_url };
  }
  if (order.product_id === "concept-explainer-api") {
    const concept = CONCEPTS.find((c) => c.slug === order.concept) || null;
    return {
      type: "concept_explainer",
      concept: order.concept,
      explainer: concept
        ? {
            slug: concept.slug,
            title: concept.title,
            category: concept.category,
            tldr: concept.tldr,
            deep_dive: concept.deep_dive,
            anti_pattern: concept.anti_pattern,
            production_tip: concept.production_tip,
          }
        : null,
    };
  }
  if (order.product_id === "single-blueprint") {
    return {
      type: "blueprint_redemption",
      unlock_key: "BABY-ARCH-2026",
      sample_url: product.sample_output_url,
      instructions:
        "Present the order token and the unlock key on the blueprints section of the site to redeem the blueprint of your choice.",
    };
  }
  return {
    type: "all_access_redemption",
    unlock_key: "BABY-ARCH-2026",
    sample_url: product.sample_output_url,
    access:
      "all current and future blueprints + AGENTS.md template repo + priority dispatch",
    instructions:
      "Present the order token and the unlock key to activate All-Access.",
  };
}

function toMarkdown(order, product, deliverable) {
  const lines = [
    `# Delivery — ${product.name}`,
    "",
    `- **Order:** ${order.token}`,
    `- **Product:** ${order.product_id} (${order.price_cents} ${order.currency})`,
    "- **Status:** paid",
    `- **Rail:** ${order.rail}`,
    `- **Paid at:** ${order.paid_at}`,
    "",
    "## Deliverable",
    "",
  ];
  if (deliverable.type === "concept_explainer" && deliverable.explainer) {
    const c = deliverable.explainer;
    lines.push(
      `### ${c.title} [${c.category}]`,
      "",
      `**TL;DR:** ${c.tldr}`,
      "",
      "### Architecture, minus the theatre",
      "",
      c.deep_dive,
      "",
      "### Anti-pattern",
      "",
      c.anti_pattern,
      "",
      "### Production tip",
      "",
      c.production_tip,
      ""
    );
  } else if (deliverable.type === "sample_markdown") {
    lines.push(
      `Sample file: ${deliverable.url}`,
      "",
      "<!-- SAMPLE_BODY -->",
      ""
    );
  } else {
    lines.push(
      `Type: ${deliverable.type}`,
      "",
      `Unlock key: \`${deliverable.unlock_key}\``,
      "",
      deliverable.instructions || "",
      ""
    );
  }
  lines.push(
    "---",
    "AI for Babies — no hype, pure signal. https://aiforbabies.pages.dev/"
  );
  return lines.join("\n");
}

export async function onRequestGet(context) {
  const { request, env, params } = context;

  if (!store(env)) {
    return json(
      { error: "storage_unavailable", detail: "AGENT_STORE KV binding missing" },
      503
    );
  }

  const order = await getOrder(env, params.token);
  if (!order) {
    return json({ error: "unknown_order", order_token: params.token }, 404);
  }

  if (order.status === "awaiting_payment") {
    return json(
      {
        error: "payment_required",
        order_token: order.token,
        product_id: order.product_id,
        price_cents: order.price_cents,
        currency: order.currency,
        rail: order.rail,
        status: "awaiting_payment",
      },
      402
    );
  }

  if (order.status === "held_for_review") {
    return json(
      {
        error: "held_for_review",
        order_token: order.token,
        status: "held_for_review",
        reason: order.held_reason || "daily_programmatic_cap_exceeded",
        detail:
          "programmatic settlement exceeded the USD 20/day cap — manual review required",
      },
      403
    );
  }

  // paid
  const product = productById(order.product_id);
  const deliverable = deliverableFor(order, product);

  if (wantsMarkdown(request)) {
    let body = toMarkdown(order, product, deliverable);
    if (deliverable.type === "sample_markdown") {
      try {
        const assetUrl = new URL(new URL(deliverable.url).pathname, request.url);
        const res = await env.ASSETS.fetch(new Request(assetUrl));
        if (res.status === 200) {
          body = body.replace("<!-- SAMPLE_BODY -->", await res.text());
        } else {
          body = body.replace(
            "<!-- SAMPLE_BODY -->",
            `Sample file unavailable (${res.status}); fetch it directly at ${deliverable.url}`
          );
        }
      } catch {
        body = body.replace(
          "<!-- SAMPLE_BODY -->",
          `Fetch the sample directly at ${deliverable.url}`
        );
      }
    }
    return markdown(body);
  }

  return json({
    status: "paid",
    order_token: order.token,
    product_id: order.product_id,
    product_name: product.name,
    price_cents: order.price_cents,
    currency: order.currency,
    rail: order.rail,
    paid_at: order.paid_at,
    settled_by: order.settled_by,
    deliverable,
  });
}


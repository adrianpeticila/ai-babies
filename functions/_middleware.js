/**
 * AI for Babies — content negotiation middleware (Cloudflare Pages Functions).
 *
 * A mirror of every core page exists as clean markdown at the same path with a
 * `.md` extension. Requests that explicitly prefer markdown (`Accept:
 * text/markdown`) or come from known agent crawlers (GPTBot, ClaudeBot,
 * PerplexityBot, AgentReach) receive that mirror instead of the HTML.
 *
 * Everything else — including all `/api/` routes and any path without a
 * markdown mirror — falls through untouched to Functions/static assets.
 */

const BOT_UA = /GPTBot|ClaudeBot|PerplexityBot|AgentReach/i;

function wantsMarkdown(request) {
  const accept = request.headers.get("accept") || "";
  if (accept.includes("text/markdown")) return true;
  return BOT_UA.test(request.headers.get("user-agent") || "");
}

function mirrorPath(pathname) {
  if (pathname === "/" || pathname === "") return "/index.md";
  if (pathname.endsWith("/")) return pathname + "index.md";
  return pathname + ".md";
}

export async function onRequest(context) {
  const { request, env, next } = context;

  if (request.method !== "GET" && request.method !== "HEAD") return next();

  const url = new URL(request.url);
  // Dynamic endpoints negotiate for themselves; never intercept them here.
  if (url.pathname.startsWith("/api/")) return next();
  if (!wantsMarkdown(request)) return next();

  const mdRequest = new Request(new URL(mirrorPath(url.pathname), url.origin), {
    method: "GET",
    headers: { accept: "text/markdown" },
  });
  const mirror = await env.ASSETS.fetch(mdRequest);
  if (mirror.status !== 200) return next(); // no mirror — serve the original
  // Pages may answer unknown paths with an HTML fallback (status 200). Only a
  // genuine markdown asset — identified by its native content type — counts as
  // a mirror; never relabel fallback HTML as markdown.
  const mirrorType = mirror.headers.get("Content-Type") || "";
  if (!mirrorType.includes("text/markdown")) return next();

  const headers = new Headers(mirror.headers);
  headers.set("Content-Type", "text/markdown; charset=utf-8");
  headers.set("Vary", "Accept, User-Agent");
  return new Response(request.method === "HEAD" ? null : mirror.body, {
    status: 200,
    headers,
  });
}

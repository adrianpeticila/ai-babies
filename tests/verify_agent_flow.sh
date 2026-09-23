#!/usr/bin/env bash
# tests/verify_agent_flow.sh — AI for Babies agent commerce verification harness.
#
# Self-contained: boots its own isolated `wrangler pages dev` instance (unique
# AGENT_STATE_NS per run => fresh rate windows, ledger and orders) unless
# BASE_URL points to an already-running instance. Exits 0 only when every
# check passes. The five mandatory canaries are part of the suite: if a
# guardrail regresses (unknown product accepted, malformed body accepted, rate
# limit gone, HMAC not verified, unknown token served), this script MUST turn
# red and exit non-zero.
#
# Usage:
#   bash tests/verify_agent_flow.sh                 # boot an isolated instance
#   BASE_URL=http://127.0.0.1:8795 bash tests/...   # target an existing one
#
# With BASE_URL the target must use PAYMENT_WEBHOOK_SECRET=aib-dev-secret-123
# (the secret used to sign below), a KV binding AGENT_STORE, and ideally its
# own AGENT_STATE_NS so rate windows do not bleed between runs.

set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SECRET="${PAYMENT_WEBHOOK_SECRET:-aib-dev-secret-123}"
PORT="${PORT:-8794}"
STARTED=0
PASS=0
FAILS=0
T=/tmp/aib_h

if [ -z "${BASE_URL:-}" ]; then
  BASE_URL="http://127.0.0.1:${PORT}"
  W="${WRANGLER:-/Users/pc/.npm/_npx/32026684e21afda6/node_modules/.bin/wrangler}"
  NS="run_$(date +%s)_$$"
  LOG="/tmp/aib-harness-${NS}.log"
  SRVPID=""
  # Curata orice instanta parasita de o rulare anterioara pe acelasi port:
  # fara asta, readiness-ul ar confirma VECHIUL server (cu stare veche).
  pkill -f "pages dev .*--port $PORT" >/dev/null 2>&1 || true
  sleep 1
  cd "$ROOT" || exit 2
  CI=1 "$W" pages dev . --port "$PORT" --kv AGENT_STORE \
    --binding PAYMENT_WEBHOOK_SECRET="$SECRET" \
    --binding X402_PAYTO_ADDRESS=0x1111111111111111111111111111111111111111 \
    --binding AGENT_STATE_NS="$NS" \
    --show-interactive-dev-session=false > "$LOG" 2>&1 &
  SRVPID=$!
  cd - >/dev/null || true
  STARTED=1
  code=""
  for i in $(seq 1 45); do
    if ! kill -0 "$SRVPID" 2>/dev/null; then
      echo "[FATAL] pages dev a murit (bind esuat pe $PORT?) — vezi $LOG"
      tail -25 "$LOG" 2>/dev/null
      exit 2
    fi
    code=$(curl -s -m 2 -o /dev/null -w '%{http_code}' "$BASE_URL/" 2>/dev/null || true)
    [ "$code" = "200" ] && break
    sleep 1
  done
  if [ "$code" != "200" ]; then
    echo "[FATAL] pages dev nu a pornit pe $PORT — vezi $LOG"
    tail -25 "$LOG" 2>/dev/null
    exit 2
  fi
  echo "instance: $BASE_URL (ns=$NS, pid=$SRVPID, ready ${i}s)"
  cleanup() {
    [ -n "$SRVPID" ] && kill "$SRVPID" >/dev/null 2>&1 || true
    pkill -f "pages dev .*--port $PORT" >/dev/null 2>&1 || true
    sleep 0.3
    return 0
  }
  trap cleanup EXIT
fi
echo "target: $BASE_URL (STARTED=$STARTED)"

ok()   { PASS=$((PASS+1)); echo "[PASS] $1"; }
bad()  { FAILS=$((FAILS+1)); echo "[FAIL] $1"; }
eq()   { if [ "$1" = "$2" ]; then ok "$3"; else bad "$3 (got: ${2:-<empty>}, want: $1)"; fi; }

# pyassert <file> <python expr over d> <label>
pyassert() {
  if python3 - "$1" "$2" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
assert eval(sys.argv[2]), f"false: {sys.argv[2]} -> {d}"
PY
  then ok "$3"; else bad "$3"; fi
}

# xmllocs <file> — parseable urlset, canonical host; prints count
xmllocs() {
  python3 - "$1" <<'PY'
import sys
from xml.etree import ElementTree as ET
root = ET.parse(sys.argv[1]).getroot()
locs = [e.text for e in root.iter("{http://www.sitemaps.org/schemas/sitemap/0.9}loc")]
assert locs, "fara <loc>"
assert all(l.startswith("https://aiforbabies.pages.dev/") for l in locs), locs[:3]
print(len(locs))
PY
}

# sign <raw-body> — X-Signature value for PAYMENT_WEBHOOK_SECRET
sign() {
  python3 -c "import hmac,hashlib,sys;print('sha256='+hmac.new(sys.argv[2].encode(),sys.argv[1].encode(),hashlib.sha256).hexdigest())" "$1" "$SECRET"
}

# === S1 ===
echo "=== 1. CONTENT NEGOTIATION (Accept: text/markdown + bot UA) ==="
ct=$(curl -s -o "${T}_root.md" -w '%{content_type}' -H 'Accept: text/markdown' "$BASE_URL/")
eq "text/markdown; charset=utf-8" "$ct" "GET / + Accept: text/markdown -> markdown"
if grep -q '^# AI for Babies' "${T}_root.md" 2>/dev/null; then ok "corp / = oglinda index.md"; else bad "corp / nu e index.md"; fi

ct=$(curl -s -o /dev/null -w '%{content_type}' -A 'Mozilla/5.0; compatible; GPTBot/1.0' "$BASE_URL/concepts/graphrag")
eq "text/markdown; charset=utf-8" "$ct" "GPTBot pe /concepts/graphrag (fara sufix) -> markdown"

ct=$(curl -s -o /dev/null -w '%{content_type}' -A 'ClaudeBot/1.0' "$BASE_URL/concepts/transformer")
eq "text/markdown; charset=utf-8" "$ct" "ClaudeBot pe concept -> markdown"

ct=$(curl -s -o /dev/null -w '%{content_type}' -A 'PerplexityBot/1.0' -H 'Accept: text/html' "$BASE_URL/")
eq "text/markdown; charset=utf-8" "$ct" "PerplexityBot (bot UA) -> markdown chiar cu Accept: text/html (regula OR)"

ct=$(curl -s -o /dev/null -w '%{content_type}' -A 'Mozilla/5.0 (Macintosh)' -H 'Accept: text/html,*/*' "$BASE_URL/")
eq "text/html; charset=utf-8" "$ct" "browser clasic -> HTML (negocierea nu fura pagina)"

st=$(curl -s -o "${T}_ghost" -w '%{http_code}' -H 'Accept: text/markdown' "$BASE_URL/concepts/does-not-exist")
gh=$(head -c 1 "${T}_ghost" 2>/dev/null || echo '?')
if [ "$st" = "200" ] && [ "$gh" = "#" ]; then
  bad "cale .md fantoma livrata ca oglinda markdown"
else
  ok "cale .md fantoma -> nu e relabel-ata markdown (status=$st)"
fi

# === S2 ===
echo "=== 2. DISCOVERY (llms.txt, agent.json, robots, sitemaps) ==="
code=$(curl -s -o "${T}_llms.txt" -w '%{http_code}' "$BASE_URL/llms.txt")
eq 200 "$code" "GET /llms.txt"
miss=0
for p in '/api/agent/buy' '/api/catalog.json' 'USD 20/day' 'Idempotency-Key' 'HTTP 429' 'held_for_review' '900 cents' '1900 cents' 'GPTBot' 'sitemap-markdown.xml'; do
  grep -qF "$p" "${T}_llms.txt" || { miss=$((miss+1)); echo "   lipsa in llms.txt: $p"; }
done
eq 0 "$miss" "llms.txt: 10 fraze obligatorii (endpointuri, guardrails, preturi, boti, sitemap)"

code=$(curl -s -o "${T}_agent.json" -w '%{http_code}' "$BASE_URL/.well-known/agent.json")
eq 200 "$code" "GET /.well-known/agent.json"
pyassert "${T}_agent.json" "d['payment_rails']==['stripe_hosted','zeroclick','1f916_base']" "agent.json: rails exacti"
pyassert "${T}_agent.json" "d['guardrails']['daily_programmatic_cap_usd']==20" "agent.json: daily cap 20 USD"
pyassert "${T}_agent.json" "'3 buy attempts' in d['guardrails']['rate_limit']" "agent.json: rate limit 3/10min"
pyassert "${T}_agent.json" "set(d['schemas'])=={'catalog_item','buy_request','webhook_payload'}" "agent.json: schemas (3)"
pyassert "${T}_agent.json" "d['endpoints']['buy'].endswith('/api/agent/buy') and '{token}' in d['endpoints']['deliveries']" "agent.json: endpointuri buy+deliveries"
pyassert "${T}_agent.json" "d['checkout']['idempotency_header']=='Idempotency-Key' and len(d['content_negotiation']['bot_user_agents'])==4" "agent.json: idempotency + 4 bot UA"

code=$(curl -s -o "${T}_robots.txt" -w '%{http_code}' "$BASE_URL/robots.txt")
eq 200 "$code" "GET /robots.txt"
r=$(grep -c '^Sitemap: https://aiforbabies.pages.dev/' "${T}_robots.txt")
eq 2 "$r" "robots: 2 sitemaps pe gazda canonica"

code=$(curl -s -o "${T}_sitemap.xml" -w '%{http_code}' "$BASE_URL/sitemap.xml")
eq 200 "$code" "GET /sitemap.xml"
locs=$(xmllocs "${T}_sitemap.xml" 2>/dev/null || echo 0)
eq 2 "$locs" "sitemap.xml: 2 loci pe gazda canonica"

code=$(curl -s -o "${T}_sitemap-md.xml" -w '%{http_code}' "$BASE_URL/sitemap-markdown.xml")
eq 200 "$code" "GET /sitemap-markdown.xml"
locs=$(xmllocs "${T}_sitemap-md.xml" 2>/dev/null || echo 0)
eq 82 "$locs" "sitemap-markdown.xml: 82 loci (index + 77 concepte + 4 samples)"

code=$(curl -s -o "${T}_llmsfull.txt" -w '%{http_code}' "$BASE_URL/llms-full.txt")
eq 200 "$code" "GET /llms-full.txt"
if grep -q '## Agent commerce protocol' "${T}_llmsfull.txt" && grep -q 'HMAC-SHA256(PAYMENT_WEBHOOK_SECRET' "${T}_llmsfull.txt"; then
  ok "llms-full: sectiunea commerce + reteta HMAC"
else
  bad "llms-full: sectiune commerce / reteta HMAC"
fi

# === S3 ===
echo "=== 3. CATALOG (schema exacta de 7 chei, USD) ==="
code=$(curl -s -o "${T}_cat.json" -w '%{http_code}' "$BASE_URL/api/catalog.json")
eq 200 "$code" "GET /api/catalog.json"
pyassert "${T}_cat.json" "isinstance(d,list) and len(d)==4" "catalog: array de 4 produse"
pyassert "${T}_cat.json" "all(set(p)=={'checkout_type','currency','description','id','name','price_cents','sample_output_url'} for p in d)" "catalog: exact 7 chei per produs"
pyassert "${T}_cat.json" "{p['id']:p['price_cents'] for p in d}=={'single-blueprint':900,'all-access':1900,'concept-explainer-api':100,'sample-concept':0}" "catalog: preturi 900/1900/100/0"
pyassert "${T}_cat.json" "all(p['currency']=='USD' for p in d)" "catalog: USD peste tot"
pyassert "${T}_cat.json" "all(p['sample_output_url'].startswith('https://aiforbabies.pages.dev/samples/') for p in d)" "catalog: sample_output_url absolut"
pyassert "${T}_cat.json" "{p['checkout_type'] for p in d}=={'stripe_hosted','x402','free'}" "catalog: checkout_type = tipuri reale"

sam=0
for s in rag-sample agents-sample blueprint-sample all-access-sample; do
  [ -f "$ROOT/samples/$s.md" ] || { sam=$((sam+1)); echo "   lipsa local: samples/$s.md"; }
  code=$(curl -s -o /dev/null -w '%{http_code}' "$BASE_URL/samples/$s.md")
  [ "$code" = "200" ] || { sam=$((sam+1)); echo "   HTTP $code: samples/$s.md"; }
done
eq 0 "$sam" "samples: 4 fisiere existente local + servite 200"

mc=$(ls "$ROOT/concepts/"*.md 2>/dev/null | wc -l | tr -d ' ')
eq 77 "$mc" "oglinzi locale: 77 fisiere concepts/*.md"
if [ -f "$ROOT/index.md" ]; then ok "oglinda locala index.md"; else bad "index.md lipseste"; fi

# === S4 ===
echo "=== 4. FLOW: buy -> 402/200 -> webhook -> deliveries (json + markdown) ==="
buy() { # product_id agent_id outfile [extra-json]
  local prod="$1" agent="$2" out="$3" extra="${4:-}"
  curl -s -o "$out" -w '%{http_code}' -X POST "$BASE_URL/api/agent/buy" \
    -H 'Content-Type: application/json' \
    -d "{\"product_id\":\"$prod\",\"agent_id\":\"$agent\"$extra}"
}
settle() { # token provider outfile — semneaza corpul cu SECRET
  local body="{\"order_token\":\"$1\",\"status\":\"succeeded\",\"provider\":\"$2\"}"
  local sig; sig=$(sign "$body")
  curl -s -o "$3" -w '%{http_code}' -X POST "$BASE_URL/api/agent/payments/webhook" \
    -H 'Content-Type: application/json' -H "X-Signature: $sig" -d "$body"
}
tok() { python3 -c "import json;print(json.load(open('$1'))['order_token'])" 2>/dev/null; }

# 4.1 mosta gratuita — 200 imediat + livrare markdown cu corp inlinat
c=$(buy sample-concept flow-free "${T}_free.json")
eq 200 "$c" "buy: sample-concept (free) -> 200 imediat"
pyassert "${T}_free.json" "d['status']=='paid' and d['checkout_type']=='free' and d['order_token'].startswith('ord_')" "free: status paid + order_token"
TF=$(tok "${T}_free.json")
r=$(curl -s -o "${T}_free.md" -w '%{http_code} %{content_type}' -H 'Accept: text/markdown' "$BASE_URL/api/agent/deliveries/$TF")
eq "200 text/markdown; charset=utf-8" "$r" "deliveries free: markdown"
if grep -q "$TF" "${T}_free.md" 2>/dev/null && grep -q 'Free AI Concept Sample' "${T}_free.md"; then
  ok "deliveries free: token + corp rag-sample inlinat"
else
  bad "deliveries free: corp incomplet"
fi

# 4.2 Stripe hosted — linkul real de 9 dolari + idempotenta
c=$(curl -s -o "${T}_stripe1.json" -w '%{http_code}' -X POST "$BASE_URL/api/agent/buy" \
  -H 'Content-Type: application/json' -H 'Idempotency-Key: harness-K1' \
  -d '{"product_id":"single-blueprint","agent_id":"flow-stripe","email":"buyer@example.com"}')
eq 200 "$c" "buy: single-blueprint (default) -> 200 stripe_hosted"
pyassert "${T}_stripe1.json" "d['checkout_url']=='https://buy.stripe.com/9B6bJ175S2z3gv62I39k400'" "buy: link Stripe \$9 REAL din checkout modal"
TS=$(tok "${T}_stripe1.json")
c=$(curl -s -o "${T}_stripe2.json" -D "${T}_stripe2.h" -w '%{http_code}' -X POST "$BASE_URL/api/agent/buy" \
  -H 'Content-Type: application/json' -H 'Idempotency-Key: harness-K1' \
  -d '{"product_id":"single-blueprint","agent_id":"flow-stripe","email":"buyer@example.com"}')
eq 200 "$c" "buy: replay cu acelasi Idempotency-Key"
pyassert "${T}_stripe2.json" "d['order_token']=='$TS'" "idempotency: acelasi order_token"
if grep -qi '^Idempotency-Replayed: true' "${T}_stripe2.h"; then ok "idempotency: header Idempotency-Replayed"; else bad "idempotency: header lipseste"; fi

# 4.3 blueprint x402 — 402 cu cap, unpaid 402, settle paid, livrare JSON+md, replay
c=$(buy single-blueprint flow-bp "${T}_bp.json" ',"rail":"x402"')
eq 402 "$c" "buy: single-blueprint rail=x402 -> 402"
pyassert "${T}_bp.json" "d['error']=='payment_required' and d['price_cents']==900 and d['usd_cents']==900 and d['currency']=='USD'" "402: pret 900 USD exact"
pyassert "${T}_bp.json" "d['settlement']['cap_usd_daily']==20 and d['settlement']['signature_header']=='X-Signature' and d['settlement']['algorithm']=='hmac-sha256'" "402: cap 20 USD + reteta webhook"
if [ "$STARTED" = "1" ]; then
  pyassert "${T}_bp.json" "d['payment']['pay_to']=='0x1111111111111111111111111111111111111111'" "402: pay_to din env X402_PAYTO_ADDRESS (plumbing)"
else
  pyassert "${T}_bp.json" "'pay_to' in d['payment']" "402: pay_to prezent in payment"
fi
TB=$(tok "${T}_bp.json")
c=$(curl -s -o "${T}_bp_d1.json" -w '%{http_code}' "$BASE_URL/api/agent/deliveries/$TB")
eq 402 "$c" "deliveries: neplatit -> 402"
pyassert "${T}_bp_d1.json" "d['error']=='payment_required' and d['price_cents']==900 and d['currency']=='USD'" "deliveries 402: error + pret"
c=$(settle "$TB" x402 "${T}_w1.json")
eq 200 "$c" "webhook: settle 900 cu HMAC valid"
pyassert "${T}_w1.json" "d['status']=='paid' and d['ledger_usd_cents']==900 and d['cap_usd_daily']==20" "settle: paid, ledger=900, cap=20"
c=$(settle "$TB" x402 "${T}_w2.json")
eq 200 "$c" "webhook: replay idempotent"
pyassert "${T}_w2.json" "d.get('replayed') is True and d['status']=='paid'" "replay: aceeasi stare, nicio rescriere"
c=$(curl -s -o "${T}_bp_d2.json" -w '%{http_code}' "$BASE_URL/api/agent/deliveries/$TB")
eq 200 "$c" "deliveries: platit -> 200 JSON"
pyassert "${T}_bp_d2.json" "d['status']=='paid' and d['order_token']=='$TB' and d['deliverable']['type']=='blueprint_redemption' and d['deliverable']['unlock_key']=='BABY-ARCH-2026' and d['settled_by']=='x402'" "deliveries JSON: paid + deliverable + unlock_key + settled_by"
r=$(curl -s -o "${T}_bp_d2.md" -w '%{http_code} %{content_type}' -H 'Accept: text/markdown' "$BASE_URL/api/agent/deliveries/$TB")
eq "200 text/markdown; charset=utf-8" "$r" "deliveries: markdown (negociere)"
if grep -q "$TB" "${T}_bp_d2.md" 2>/dev/null && grep -q 'BABY-ARCH-2026' "${T}_bp_d2.md"; then
  ok "deliveries md: token + unlock key"
else
  bad "deliveries md: campuri lipsa"
fi

# 4.4 all-access x402 — depaseste capul -> held_for_review -> livrare 403
c=$(buy all-access flow-aa "${T}_aa.json" ',"rail":"x402"')
eq 402 "$c" "buy: all-access rail=x402 -> 402"
pyassert "${T}_aa.json" "d['price_cents']==1900 and d['error']=='payment_required'" "402: pret 1900"
TA=$(tok "${T}_aa.json")
c=$(settle "$TA" x402 "${T}_w3.json")
eq 200 "$c" "webhook: settle 1900 (peste cap)"
pyassert "${T}_w3.json" "d['status']=='held_for_review' and d['reason']=='daily_programmatic_cap_exceeded' and d['ledger_usd_cents']==900 and d['attempted_usd_cents']==2800" "cap: held, ledger neatins (900), tentativa 2800>2000"
c=$(curl -s -o "${T}_aa_d.json" -w '%{http_code}' "$BASE_URL/api/agent/deliveries/$TA")
eq 403 "$c" "deliveries: held_for_review -> 403"
pyassert "${T}_aa_d.json" "d['error']=='held_for_review' and d['reason']=='daily_programmatic_cap_exceeded' and 'USD 20/day' in d['detail']" "403: motivul capului explicit"

# 4.5 explainer — sub cap (900+100=1000), livrat ca JSON si markdown
c=$(buy concept-explainer-api flow-ex "${T}_ex.json" ',"concept":"graphrag"')
eq 402 "$c" "buy: explainer (concept graphrag) -> 402"
pyassert "${T}_ex.json" "d['price_cents']==100 and d['rail']=='x402'" "402: pret 100, rail x402"
TE=$(tok "${T}_ex.json")
c=$(settle "$TE" zeroclick "${T}_w4.json")
eq 200 "$c" "webhook: settle explainer 100"
pyassert "${T}_w4.json" "d['status']=='paid' and d['ledger_usd_cents']==1000" "ledger: 900+100=1000 <= 2000 -> paid"
c=$(curl -s -o "${T}_ex_d.json" -w '%{http_code}' "$BASE_URL/api/agent/deliveries/$TE")
eq 200 "$c" "deliveries: explainer -> 200"
pyassert "${T}_ex_d.json" "d['deliverable']['type']=='concept_explainer' and d['deliverable']['explainer']['slug']=='graphrag' and len(d['deliverable']['explainer']['deep_dive'])>50 and d['deliverable']['explainer']['anti_pattern']" "livrare: explainer complet (slug/tldr/deep_dive/anti/tip)"
r=$(curl -s -o "${T}_ex_d.md" -w '%{http_code} %{content_type}' -H 'Accept: text/markdown' "$BASE_URL/api/agent/deliveries/$TE")
eq "200 text/markdown; charset=utf-8" "$r" "explainer: markdown"
if grep -q 'GraphRAG' "${T}_ex_d.md" 2>/dev/null && grep -q "$TE" "${T}_ex_d.md"; then
  ok "explainer md: conceptul livrat + token"
else
  bad "explainer md: incomplet"
fi

# 4.6 Stripe hosted settle — platit, NEcontabilizat in cap (unlimited)
c=$(settle "$TS" stripe "${T}_w5.json")
eq 200 "$c" "webhook: settle stripe_hosted"
pyassert "${T}_w5.json" "d['status']=='paid' and 'ledger_usd_cents' not in d" "stripe: paid fara contabilitate cap (unlimited)"
c=$(curl -s -o /dev/null -w '%{http_code}' "$BASE_URL/api/agent/deliveries/$TS")
eq 200 "$c" "deliveries: stripe platit -> 200"

c=$(curl -s -o /dev/null -w '%{http_code}' -X OPTIONS "$BASE_URL/api/agent/buy")
eq 204 "$c" "OPTIONS /api/agent/buy -> 204 (CORS preflight)"

# === S5 ===
echo "=== 5. MANDATORY CANARY PROBES (verifierul TREBUIE sa poata pica) ==="
# Canary A — produs necunoscut -> 404: nicio comanda fantoma nu trece
c=$(buy does-not-exist canary-unknown-product "${T}_cA.json")
eq 404 "$c" "canary A: produs necunoscut -> 404"

# Canary B — corp malformed -> 400 (si bonus: identitate lipsa)
c=$(curl -s -o /dev/null -w '%{http_code}' -X POST "$BASE_URL/api/agent/buy" \
  -H 'Content-Type: application/json' -d '{{{not json')
eq 400 "$c" "canary B: corp malformed -> 400"
c=$(curl -s -o /dev/null -w '%{http_code}' -X POST "$BASE_URL/api/agent/buy" \
  -H 'Content-Type: application/json' -d '{"product_id":"sample-concept"}')
eq 400 "$c" "bonus B: identitate lipsa -> 400"

# Canary C — rate limit 3 / 10 min / IP+agent: 1-3 trec, a 4-a -> 429
codes=""
for n in 1 2 3 4; do
  c=$(curl -s -o /dev/null -w '%{http_code}' -X POST "$BASE_URL/api/agent/buy" \
    -H 'Content-Type: application/json' \
    -d '{"product_id":"sample-concept","agent_id":"canary-rate-limit"}')
  codes="${codes:+$codes }$n:$c"
done
eq "1:200 2:200 3:200 4:429" "$codes" "canary C: rate limit -> 429 la a 4-a incercare"

# Canary D — semnatura HMAC valida => 401 (fail-closed, constant-time)
BAD=$(python3 -c "print('0'*64)")
c=$(curl -s -o /dev/null -w '%{http_code}' -X POST "$BASE_URL/api/agent/payments/webhook" \
  -H 'Content-Type: application/json' -H "X-Signature: sha256=$BAD" \
  -d '{"order_token":"ord_x","status":"succeeded"}')
eq 401 "$c" "canary D: HMAC invalid -> 401"
c=$(curl -s -o /dev/null -w '%{http_code}' -X POST "$BASE_URL/api/agent/payments/webhook" \
  -H 'Content-Type: application/json' -H 'X-Signature: banana' \
  -d '{"order_token":"ord_x","status":"succeeded"}')
eq 401 "$c" "bonus D: semnatura malformata -> 401"

# Canary E — token de livrare necunoscut -> 404 (fara stearsa spre 402/200)
c=$(curl -s -o /dev/null -w '%{http_code}' "$BASE_URL/api/agent/deliveries/ord_canary_nonexistent")
eq 404 "$c" "canary E: token livrare necunoscut -> 404"

# Bonus: gardieni aditionali de intrare
c=$(buy concept-explainer-api canary-concept "${T}_cF.json" ',"concept":"no-such-slug"')
eq 400 "$c" "bonus F: concept necunoscut -> 400"
c=$(buy single-blueprint canary-rail "${T}_cG.json" ',"rail":"paypal"')
eq 400 "$c" "bonus G: rail necunoscut -> 400"

echo
echo "================ SUMMARY ================"
echo "PASS: $PASS   FAIL: $FAILS   TOTAL: $((PASS + FAILS))"
if [ "$FAILS" -eq 0 ] && [ "$PASS" -gt 0 ]; then
  echo "RESULT: 100% PASS — exit 0"
  exit 0
fi
echo "RESULT: $FAILS checks failed — exit 1"
exit 1






# Free AI Concept Sample — RAG Breakdown

> Part of [AI for Babies](https://aiforbabies.pages.dev/) · product: `sample-concept` · $0 · delivered instantly over `/api/agent/buy`

One absurd analogy: **RAG is an intern who is never allowed to answer from
memory.** You ask a question, the intern pulls three folders from the archive,
tapes them to the question, and only then is allowed to open their mouth. If
the folders are wrong, the answer is wrong *and* confident — which is middle
management with a citation.

## How it actually works

1. **Retrieve.** Your question becomes numbers ("embeddings") and is run
   against a search index — keyword matching (BM25), vectors, usually both.
2. **Augment.** The top passages are glued into the prompt: "answer using only
   this."
3. **Generate.** The model writes an answer grounded in those passages and, in
   decent systems, cites them.

## The three places it silently fails

1. **Garbage retrieval, fluent answer.** The model will happily synthesise a
   confident lie from three irrelevant chunks. Confidence is free; grounding is
   not.
2. **Chunking nobody reviewed.** Splitting documents by fixed character counts
   cuts tables in half and definitions away from their context. The index then
   answers with orphaned fragments — technically retrieved, semantically null.
3. **No freshness story.** Index updated nightly, answer presented as live.
   Yesterday's price with today's certainty.

## Questions that expose a demo disguised as a product

- "What happens when retrieval returns nothing relevant — refuse, or guess?"
- "Show me a failed query from last week and how you flagged it."
- "How does a document leave the index — deletions, tombstones, re-rank lag?"
- "Which step can I audit: retrieval scores, chunks used, or only the prose?"

## What this sample is

A free excerpt of the format used by the paid **On-Demand Cynical Concept
Explainer** ($1) and the blueprint library ($9 / $19). Same structure, same
tone, zero jargon. Buy over HTTP 402 at
https://aiforbabies.pages.dev/api/agent/buy.

---
AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

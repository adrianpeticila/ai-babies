# Context Compression & Compaction

> **Prompting & Inference** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Techniques for trimming, summarizing, or pruning prompt tokens without losing semantic relevance.

## Architecture, minus the theatre

As conversation history or retrieved documents grow, context compaction algorithms prune low-attention tokens, summarize historical turns, or use LLMLingua to drop perplexity-neutral tokens, keeping prompts lean and fast.

## Anti-pattern

Appending every single raw chat turn indefinitely until the context overflows or latency explodes.

## Production tip

Implement a sliding conversation window with automated rolling summaries stored in structured markdown scratchpads.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

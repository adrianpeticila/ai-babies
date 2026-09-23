# Context Window

> **Foundations** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Maximum number of tokens an LLM can process simultaneously in a single forward pass.

## Architecture, minus the theatre

The context window encompasses both the input prompt and the output generation budget. While modern models boast 128k to 2M+ token windows, effective recall across long contexts depends on architecture, positional encoding scaling, and KV cache memory constraints.

## Anti-pattern

Stuffing 100k tokens into the context just because the window allows it, causing quadratic cost inflation and severe retrieval degradation.

## Production tip

Profile your latency and retrieval accuracy at varying context depths. Prefer surgical chunk retrieval over massive context dumping.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

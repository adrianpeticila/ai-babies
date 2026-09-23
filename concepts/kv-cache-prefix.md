# KV Cache & Prefix Caching

> **Prompting & Inference** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** In-memory caching of computed Key and Value attention tensors across shared prompt prefixes to avoid recomputation.

## Architecture, minus the theatre

During autoregressive generation, past token Key/Value vectors are cached in GPU VRAM so new tokens only compute attention against the cache. Prefix caching stores shared system prompts and few-shot examples across requests, reducing TTFT and inference compute by up to 80%.

## Anti-pattern

Dynamically inserting timestamps or random request IDs at the very top of your system prompt, which invalidates the prefix cache on every call.

## Production tip

Place all static instructions, schemas, and few-shots at the beginning of the prompt; append dynamic user messages at the very end.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

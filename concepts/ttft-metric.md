# Time to First Token (TTFT)

> **Prompting & Inference** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Latency metric measuring the duration from sending a request until the first token is generated and streamed back.

## Architecture, minus the theatre

TTFT is dominated by the prefill phase where the model computes attention across the entire input prompt in parallel. High TTFT is caused by long prompts, cold caches, queueing delays, and low GPU compute parallelism.

## Anti-pattern

Optimizing only tokens-per-second while ignoring a 4-second TTFT that makes interactive chat feel sluggish and unresponsive.

## Production tip

Leverage prompt caching and speculative prefill to slash TTFT below 300ms for conversational user experiences.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

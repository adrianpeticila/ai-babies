# Agent Memory (Short-Term vs Epistemic)

> **Agents & Multi-Agent** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Memory architecture dividing working scratchpad context from persistent long-term knowledge on a filesystem.

## Architecture, minus the theatre

Short-term working memory exists within the immediate context window. Epistemic long-term memory is stored as structured markdown files (MEMORY.md, rules/, chronicle/) on a local filesystem, retrieved surgically via file tools or semantic search.

## Anti-pattern

Storing all agent memories in a complex opaque vector DB when plain human-readable markdown files in git are easier to inspect and edit.

## Production tip

Use plain markdown files on a shared filesystem for persistent agent memory. Keep working memory lean by checkpointing to disk.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

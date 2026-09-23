# System Prompt & Developer Message

> **Foundations** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Top-level instructions establishing model persona, behavioral boundaries, output format, and operational constraints.

## Architecture, minus the theatre

In chat APIs, the system message sets the persistent framing for the assistant before user turns are evaluated. Modern frontier models treat developer system messages with higher priority in attention layers to resist prompt injection and enforce safety protocols.

## Anti-pattern

Writing novel-length system prompts filled with redundant fluff that burns token budget and causes instruction diluting.

## Production tip

Structure system prompts with modular sections: Role, Core Directives, Output Schema, and Strict Boundary Rules (Always / Ask / Never).

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

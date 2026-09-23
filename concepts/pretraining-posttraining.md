# Pre-training vs Post-training

> **Foundations** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Pre-training learns general language distributions; post-training aligns the base model to follow instructions and safety guidelines.

## Architecture, minus the theatre

Pre-training consumes 95%+ of compute budget via self-supervised next-token prediction on trillions of tokens (yielding a 'Base Model'). Post-training refines this via Supervised Fine-Tuning (SFT) on curated instruction-response pairs and preference optimization (RLHF, DPO, KTO) to create an 'Instruct' or 'Chat' model.

## Anti-pattern

Using a raw Base Model for conversational APIs and wondering why it continues your text instead of answering your questions.

## Production tip

Base models are superior for pure few-shot task completion or custom fine-tuning; Instruct models are mandatory for tool calling and multi-turn chat.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

# Chain-of-Thought (CoT) & Reasoning

> **Prompting & Inference** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Prompting strategy that forces the model to generate intermediate reasoning tokens before emitting the final answer.

## Architecture, minus the theatre

Because transformers compute a fixed amount of computation per token, generating intermediate reasoning tokens expands the computational budget allocated to complex problem solving. Frontier reasoning models (o1, o3-mini, DeepSeek-R1) internalize this process at inference time.

## Anti-pattern

Demanding immediate one-token answers for multi-step logical, mathematical, or architectural problems.

## Production tip

For complex workflows, use structured CoT blocks: <thought>...</thought> followed by <final_answer> with strict JSON.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

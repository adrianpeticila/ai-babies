# Tokenization & BPE

> **Foundations** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Process of segmenting raw text into sub-word numerical token IDs using algorithms like Byte-Pair Encoding.

## Architecture, minus the theatre

LLMs do not see characters or words; they see discrete integer indices from a fixed vocabulary (typically 32k to 128k tokens). Byte-Pair Encoding iteratively merges the most frequent byte pairs in training text. Numbers, code whitespace, and non-English scripts often fragment into multiple tokens.

## Anti-pattern

Assuming character count equals token count. In multilingual or code contexts, 1 word can easily expand to 3-5 tokens.

## Production tip

Always measure cost and context limits in tokens using the exact tokenizer of your target model (e.g. tiktoken for OpenAI, tokenizers for HuggingFace).

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

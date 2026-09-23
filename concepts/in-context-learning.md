# In-Context Learning (ICL)

> **Prompting & Inference** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** The ability of frozen language models to learn new tasks at inference time solely from context examples.

## Architecture, minus the theatre

ICL operates without updating weight matrices. Attention layers dynamically construct functional task mappings across the prompt examples, effectively performing an implicit gradient descent in the activation space during the forward pass.

## Anti-pattern

Assuming ICL persists across independent API calls without passing the context demonstrations in each request.

## Production tip

Use ICL to prototype new domain tasks in minutes before committing expensive GPU resources to fine-tuning.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

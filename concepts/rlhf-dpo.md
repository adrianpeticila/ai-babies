# RLHF & DPO (Alignment Optimization)

> **Foundations** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Post-training alignment algorithms optimizing model parameters against human preference data.

## Architecture, minus the theatre

RLHF (Reinforcement Learning from Human Feedback) trains a separate reward model to guide PPO reinforcement learning. DPO (Direct Preference Optimization) bypasses the reward model by mathematically optimizing policy weights directly on pairs of chosen and rejected completions via implicit reward formulation.

## Anti-pattern

Over-optimizing alignment until the model suffers from 'refusal mode collapse', declining harmless benign prompts.

## Production tip

DPO is faster, more stable to train, and requires far less GPU memory than multi-stage PPO-based RLHF.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

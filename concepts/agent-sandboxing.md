# Agent Sandboxing & Subprocess Isolation

> **Agents & Multi-Agent** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Isolating agent code execution inside ephemeral Docker containers, Firecracker microVMs, or gVisor sandboxes.

## Architecture, minus the theatre

Agents executing arbitrary terminal commands must never run directly on host developer machines or unprotected bare metal. Sandboxed runtimes enforce strict memory limits, CPU caps, read-only root filesystems, and scoped networking.

## Anti-pattern

Running agent-generated bash scripts as root on your production server.

## Production tip

Use Docker or WebAssembly (Wasm) sandboxes with strict resource quotas and network egress firewalls for tool execution.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

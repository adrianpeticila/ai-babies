# Skill Paging & Lazy Tool RAM Loading

> **Protocols & WebMCP** · [AI for Babies](https://aiforbabies.pages.dev/index.md) · markdown mirror of the
> dictionary entry at https://aiforbabies.pages.dev/#dictionary

**TL;DR:** Architecture pattern scaling agent toolsets to 100,000+ tools by paging tool definitions from disk into context on demand.

## Architecture, minus the theatre

Injecting thousands of tool schemas into a single prompt blows through context windows and degrades tool selection accuracy. Skill paging keeps an index of tools on disk/filesystem, retrieves only top-3 relevant tool schemas for the current step, and unloads them after execution.

## Anti-pattern

Loading 500 tool definitions statically into the system prompt of every single agent turn.

## Production tip

Store tool skills as isolated markdown/YAML files on disk. Let the agent use a search_tools meta-tool to page schemas dynamically.

---

AI for Babies — no hype, pure signal. Full glossary: https://aiforbabies.pages.dev/index.md

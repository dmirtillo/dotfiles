---
name: spike-findings-dotfiles
description: Implementation blueprint from spike experiments. Requirements, proven patterns, and verified knowledge for building dotfiles. Auto-loaded during implementation work.
---

<context>
## Project: dotfiles

Rework the `officecli` implementation to use `markitdown` as the read engine, while preserving `officecli`'s write/DOM capabilities. Also clean up redundant tools, complex bash wrappers, and dead code throughout the repository.

Spike sessions wrapped: 2026-07-06
</context>

<requirements>
## Requirements

- The client MUST explicitly request the MCP tools in its API call using LiteLLM's custom `{"type": "mcp", "server_url": "litellm_proxy"}` syntax.
- Clients like OpenCode and Gemini CLI cannot "implicitly" inherit tools configured on the LiteLLM proxy without code modifications.
- **Markitdown+OfficeCLI:** Must explicitly call `officecli close <file>` to flush edits to disk before passing the file to `markitdown` for reading, due to `officecli`'s resident mode.
- Rely on modern tools (mise, antidote, eza, bottom) rather than duplicating with older defaults (node, go, nvm, tree, htop).
- Rely on Zsh native features and core aliases instead of reinventing standard tools. Optimize line count and functionality with a `ponytail` mindset.

</requirements>

<findings_index>
## Feature Areas

| Area | Reference | Key Finding |
|------|-----------|-------------|
| cleanup | references/cleanup.md | Strip redundant dependencies and dead scripts since `mise` and modern tools cover the functionality. |
| shell | references/shell.md | Replace complex bash wrappers with simple aliases and native Zsh modifiers (`:t:r`). |

## Source Files

Original spike source files are preserved in `sources/` for complete reference.
</findings_index>

<metadata>
## Processed Spikes

- 025-remove-redundant-deps
- 026-simplify-bash-wrappers
- 027-cleanup-dead-code
</metadata>

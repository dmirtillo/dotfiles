---
name: spike-findings-dotfiles
description: Implementation blueprint from spike experiments. Requirements, proven patterns, and verified knowledge for building dotfiles. Auto-loaded during implementation work.
---

<context>
## Project: dotfiles

Rework the `officecli` implementation to use `markitdown` as the read engine, while preserving `officecli`'s write/DOM capabilities.

Spike sessions wrapped: Mon Jul 06 2026
</context>

<requirements>
## Requirements

- The client MUST explicitly request the MCP tools in its API call using LiteLLM's custom `{"type": "mcp", "server_url": "litellm_proxy"}` syntax.
- Clients like OpenCode and Gemini CLI cannot "implicitly" inherit tools configured on the LiteLLM proxy without code modifications.
- **Markitdown+OfficeCLI:** Must explicitly call `officecli close <file>` to flush edits to disk before passing the file to `markitdown` for reading, due to `officecli`'s resident mode.
</requirements>

<findings_index>
## Feature Areas

| Area | Reference | Key Finding |
|------|-----------|-------------|
| Ponytail Configuration | references/ponytail-configuration.md | OpenCode uses `opencode.json` plugin array; Gemini CLI uses `gemini extensions install` |

## Source Files

Original spike source files are preserved in `sources/` for complete reference.
</findings_index>

<metadata>
## Processed Spikes

- 015-ponytail-opencode-config
- 016-ponytail-gemini-config
</metadata>

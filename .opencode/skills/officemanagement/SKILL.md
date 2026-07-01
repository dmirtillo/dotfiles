---
name: officemanagement
description: Implementation blueprint from spike experiments. Requirements, proven patterns, and verified knowledge for building dotfiles. Auto-loaded during implementation work.
---

<context>
## Project: dotfiles

Rework the `officecli` implementation to use `markitdown` as the read engine, while preserving `officecli`'s write/DOM capabilities.

Spike sessions wrapped: 2026-07-01
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
| Hybrid OfficeCLI+MarkItDown Workflow | references/hybrid-officecli-markitdown.md | Use markitdown[all] for blazing-fast reading, officecli for writing via DOM/text, support local LLMs for OCR, and flush changes with `officecli close` |

## Source Files

Original spike source files are preserved in `sources/` for complete reference.
</findings_index>

<metadata>
## Processed Spikes

- 007-hybrid-targeting
- 008-markitdown-baseline
- 009-markitdown-multimodal
- 010-chezmoi-officecli-setup
- 011-pptx-hybrid-integration
- 012-dom-targeting-sync
- 013-markitdown-performance
- 014-markitdown-images-local
</metadata>

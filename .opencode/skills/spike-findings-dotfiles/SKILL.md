---
name: spike-findings-dotfiles
description: Implementation blueprint from spike experiments. Requirements, proven patterns, and verified knowledge for building dotfiles. Auto-loaded during implementation work.
---

<context>
## Project: dotfiles

Explorations into Litellm MCP proxy integration with CLI clients (like OpenCode and Gemini CLI) and safe automation of Homebrew state syncing (`Brewfile`) without destroying structural annotations.

Spike sessions wrapped: 2026-05-27
</context>

<requirements>
## Requirements

- The client MUST explicitly request the MCP tools in its API call using LiteLLM's custom `{"type": "mcp", "server_url": "litellm_proxy"}` syntax.
- Clients like OpenCode and Gemini CLI cannot "implicitly" inherit tools configured on the LiteLLM proxy without code modifications.
</requirements>

<findings_index>
## Feature Areas

| Area | Reference | Key Finding |
|------|-----------|-------------|
| LiteLLM MCP Integration | references/litellm-mcp-integration.md | CLI tools require explicit payload definitions to use Litellm's proxy MCP servers; implicit inheritance fails. |
| Brewfile Syncing | references/brewfile-sync.md | Use merge scripts over `brew bundle dump --force` to prevent destruction of Brewfile comments and structure. |

## Source Files

Original spike source files are preserved in `sources/` for complete reference.
</findings_index>

<metadata>
## Processed Spikes

- 001-litellm-mcp-integration
- 002-opencode-litellm-connection
- 003-gemini-cli-litellm-connection
- 004-brew-list-parsing
- 005-brewfile-sync
- 006-brewfile-sync-preserve-comments
</metadata>

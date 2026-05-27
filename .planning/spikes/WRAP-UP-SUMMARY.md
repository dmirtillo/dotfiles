# Spike Wrap-Up Summary

**Date:** 2026-05-27
**Spikes processed:** 6
**Feature areas:** LiteLLM MCP Integration, Brewfile Syncing
**Skill output:** `./.opencode/skills/spike-findings-dotfiles/`

## Processed Spikes
| # | Name | Type | Verdict | Feature Area |
|---|------|------|---------|--------------|
| 001 | litellm-mcp-integration | standard | ✓ VALIDATED | LiteLLM MCP Integration |
| 002 | opencode-litellm-connection | standard | ✗ INVALIDATED | LiteLLM MCP Integration |
| 003 | gemini-cli-litellm-connection | standard | ✗ INVALIDATED | LiteLLM MCP Integration |
| 004 | brew-list-parsing | standard | ✓ VALIDATED | Brewfile Syncing |
| 005 | brewfile-sync | standard | ✓ VALIDATED | Brewfile Syncing |
| 006 | brewfile-sync-preserve-comments | standard | ✓ VALIDATED | Brewfile Syncing |

## Key Findings
- **LiteLLM MCP:** Standard AI CLI tools (OpenCode, Gemini CLI) cannot automatically discover or inherit MCP tools hosted on a LiteLLM proxy. The client *must* be modified to inject LiteLLM's custom `{"type": "mcp", "server_url": "litellm_proxy"}` syntax into the outgoing request's tools array.
- **Brewfile Syncing:** `brew bundle dump --force` is a destructive operation that completely wipes out inline comments and manual structural grouping in a `Brewfile`. To safely auto-append missing local dependencies, a bash merge script reading from `brew bundle dump --file=-` should be used to isolate and append new lines without touching existing formatting.

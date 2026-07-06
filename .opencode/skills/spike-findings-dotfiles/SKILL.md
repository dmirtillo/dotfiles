---
name: spike-findings-dotfiles
description: Implementation blueprint from spike experiments. Requirements, proven patterns, and verified knowledge for building dotfiles. Auto-loaded during implementation work.
---

<context>
## Project: dotfiles

Rework the `officecli` implementation to use `markitdown` as the read engine, while preserving `officecli`'s write/DOM capabilities. Also tracks the migration to `@opengsd/gsd-core` and the orchestration of `chezmoi` templates.

Spike sessions wrapped: 2026-07-06
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
| litellm-mcp | references/litellm-mcp.md | Standard clients need custom payloads to reach MCP servers |
| brew-sync | references/brew-sync.md | Safe merging of Brewfiles preserves user comments |
| officecli-hybrid | references/officecli-hybrid.md | Markitdown for reads, officecli+close for writes |
| orchestration-chezmoi | references/orchestration-chezmoi.md | Chezmoi run_onchange scripts can hydrate binary docx files using officecli |
| opencode-gsd | references/opencode-gsd.md | gsd-core safely replaces legacy tools without skill loss |
| toolchain | references/toolchain.md | mise for JS globals, uv for python extras |
| performance-audit | references/performance-audit.md | Sequential OCR triggers timeouts; Ponytail keeps Zsh fast |
| gemini-extensions | references/gemini-extensions.md | Automated installs of Gemini CLI extensions require `--consent` |
| agent-workflow | references/agent-workflow.md | Agent edits must be sequential; text-replace is preferred over DOM mapping |

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
- 007-hybrid-targeting
- 008-markitdown-baseline
- 009-markitdown-multimodal
- 010-chezmoi-officecli-setup
- 011-pptx-hybrid-integration
- 012-dom-targeting-sync
- 013-markitdown-performance
- 014-markitdown-images-local
- 015-ponytail-opencode-config
- 016-ponytail-gemini-config
- 017-opencode-update-method
- 018-sync-brewfile-review
- 019-orchestrated-update-flow
- 020-workflow-docs-generation
- 021-uninstall-old-gsd
- 022-install-new-gsd-core
- 023-gsd-core-compatibility
- 024-chezmoi-orchestration-update
- 025-remove-redundant-deps
- 026-simplify-bash-wrappers
- 027-cleanup-dead-code
- 028-ponytail-audit-validation
- 029-officecli-skill-hybrid-test
- 030-mise-global-tools
- 031-zsh-startup-profiling
- 032-gsd-core-skill-collision
- 033-uv-mise-path-integration
- 034-officecli-hybrid-skill-prompting
- 035-officecli-read-commands-cleanup
- 036-full-skill-replacement-e2e
- 037-concurrent-officecli-resident-mode
- 038-markdown-to-dom-translation
- 039-markitdown-cost-profiling
- 040-officecli-template-hydration
- 041-gemini-ponytail-install
- 042-gemini-ponytail-debug
</metadata>

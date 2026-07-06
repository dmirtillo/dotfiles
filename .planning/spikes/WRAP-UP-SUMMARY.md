# Spike Wrap-Up Summary

**Date:** 2026-07-06
**Spikes processed:** 37
**Feature areas:** litellm-mcp, brew-sync, officecli-hybrid, orchestration-chezmoi, opencode-gsd, toolchain, performance-audit
**Skill output:** `./.opencode/skills/spike-findings-dotfiles/`

## Processed Spikes
| # | Name | Type | Verdict | Feature Area |
|---|------|------|---------|--------------|
| 001 | litellm-mcp-integration | standard | ✓ VALIDATED | litellm-mcp |
| 002 | opencode-litellm-connection | standard | ✗ INVALIDATED | litellm-mcp |
| 003 | gemini-cli-litellm-connection | standard | ✗ INVALIDATED | litellm-mcp |
| 004 | brew-list-parsing | standard | ✓ VALIDATED | brew-sync |
| 005 | brewfile-sync | standard | ✓ VALIDATED | brew-sync |
| 006 | brewfile-sync-preserve-comments | standard | ✓ VALIDATED | brew-sync |
| 007 | hybrid-targeting | standard | ✓ VALIDATED | officecli-hybrid |
| 008 | markitdown-baseline | standard | ✓ VALIDATED | officecli-hybrid |
| 009 | markitdown-multimodal | standard | ✓ VALIDATED | officecli-hybrid |
| 010 | chezmoi-officecli-setup | standard | ✓ VALIDATED | orchestration-chezmoi |
| 011 | pptx-hybrid-integration | standard | ✓ VALIDATED | officecli-hybrid |
| 012 | dom-targeting-sync | standard | ✓ VALIDATED | officecli-hybrid |
| 013 | markitdown-performance | standard | ✓ VALIDATED | officecli-hybrid |
| 014 | markitdown-images-local | comparison | ✓ VALIDATED | officecli-hybrid |
| 015 | ponytail-opencode-config | standard | ✓ VALIDATED | opencode-gsd |
| 016 | ponytail-gemini-config | standard | ✓ VALIDATED | opencode-gsd |
| 017 | opencode-update-method | standard | ✓ VALIDATED | opencode-gsd |
| 018 | sync-brewfile-review | standard | ✓ VALIDATED | brew-sync |
| 019 | orchestrated-update-flow | standard | ✓ VALIDATED | orchestration-chezmoi |
| 020 | workflow-docs-generation | standard | ✓ VALIDATED | orchestration-chezmoi |
| 021 | uninstall-old-gsd | standard | ✓ VALIDATED | opencode-gsd |
| 022 | install-new-gsd-core | standard | ✓ VALIDATED | opencode-gsd |
| 023 | gsd-core-compatibility | standard | ✓ VALIDATED | opencode-gsd |
| 024 | chezmoi-orchestration-update | standard | ✓ VALIDATED | orchestration-chezmoi |
| 028 | ponytail-audit-validation | standard | ✓ VALIDATED | performance-audit |
| 029 | officecli-skill-hybrid-test | standard | ⚠ PARTIAL | officecli-hybrid |
| 030 | mise-global-tools | standard | ✓ VALIDATED | toolchain |
| 031 | zsh-startup-profiling | standard | ✓ VALIDATED | performance-audit |
| 032 | gsd-core-skill-collision | standard | ✓ VALIDATED | opencode-gsd |
| 033 | uv-mise-path-integration | standard | ✓ VALIDATED | toolchain |
| 034 | officecli-hybrid-skill-prompting | standard | ✓ VALIDATED | officecli-hybrid |
| 035 | officecli-read-commands-cleanup | standard | ✓ VALIDATED | officecli-hybrid |
| 036 | full-skill-replacement-e2e | standard | ✓ VALIDATED | officecli-hybrid |
| 037 | concurrent-officecli-resident-mode | standard | ✓ VALIDATED | officecli-hybrid |
| 038 | markdown-to-dom-translation | standard | ✗ INVALIDATED | officecli-hybrid |
| 039 | markitdown-cost-profiling | standard | ✓ VALIDATED | performance-audit |
| 040 | officecli-template-hydration | standard | ✓ VALIDATED | orchestration-chezmoi |

## Key Findings
- **LiteLLM MCP Integration:** Custom payloads are required for standard clients like OpenCode/Gemini to access LiteLLM-hosted MCP tools.
- **Brewfile Syncing:** Parsing dumps and merging with existing `Brewfile` protects comments while capturing unrecorded dependencies.
- **OfficeCLI Hybrid:** Fully decoupling reading (`markitdown[all]`) from writing (`officecli`) is performant and reliable, provided `officecli close` explicitly flushes resident state.
- **Chezmoi Orchestration:** Unifying Homebrew, opencode plugin, and binary updates inside `run_onchange_*.sh` via tracked `package.json` hashing prevents configuration drift.
- **GSD Updates:** The shift to `@opengsd/gsd-core` acts as a perfect drop-in replacement that respects and avoids clobbering user-defined skills.
- **Toolchain Reliability:** `mise` is highly effective for `npm` managed globals, but Python utilities depending on bracketed extras (`markitdown[all]`) strictly necessitate `uv tool install` to prevent missing dependencies.
- **Shell Startup:** Utilizing `_cache_eval` allows for `<50ms` initialization. Combined with `ponytail-audit` checks, the environment remains exceptionally lightweight.
- **Hybrid E2E:** LLMs correctly utilize the `markitdown` read / `officecli` write / `officecli close` loop when explicit instructions are provided in the skill payload.
- **Concurrency & Hydration:** `officecli` safely handles concurrent writes via its resident daemon without XML corruption, and proves effective for template hydration of binary artifacts via Chezmoi `run_onchange` hooks.
- **MarkItDown Limits:** Multimodal OCR runs sequentially. Do NOT default to passing `--with-ocr` for large graphical decks or the agent will exceed the 120s execution timeout boundary.
- **Markdown parsing limits:** Attempting to build an intermediary parser that translates LLM markdown diffs back to DOM commands is an anti-pattern. Continue to use explicit `officecli set --find --replace`.

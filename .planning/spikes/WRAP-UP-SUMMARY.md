# Spike Wrap-Up Summary

**Date:** 2026-07-01
**Spikes processed:** 8
**Feature areas:** Hybrid OfficeCLI+MarkItDown Workflow
**Skill output:** `./.opencode/skills/spike-findings-dotfiles/`

## Processed Spikes
| # | Name | Type | Verdict | Feature Area |
|---|------|------|---------|--------------|
| 007 | hybrid-targeting | standard | ✓ VALIDATED | Hybrid OfficeCLI+MarkItDown Workflow |
| 008 | markitdown-baseline | standard | ✓ VALIDATED | Hybrid OfficeCLI+MarkItDown Workflow |
| 009 | markitdown-multimodal | standard | ✓ VALIDATED | Hybrid OfficeCLI+MarkItDown Workflow |
| 010 | chezmoi-officecli-setup | standard | ✓ VALIDATED | Hybrid OfficeCLI+MarkItDown Workflow |
| 011 | pptx-hybrid-integration | standard | ✓ VALIDATED | Hybrid OfficeCLI+MarkItDown Workflow |
| 012 | dom-targeting-sync | standard | ✓ VALIDATED | Hybrid OfficeCLI+MarkItDown Workflow |
| 013 | markitdown-performance | standard | ✓ VALIDATED | Hybrid OfficeCLI+MarkItDown Workflow |
| 014 | markitdown-images-local | comparison | ✓ VALIDATED | Hybrid OfficeCLI+MarkItDown Workflow |

## Key Findings
Combining `officecli` (for write operations via DOM/text matching) with `markitdown` (for high-fidelity read operations) is highly viable and extremely performant (~150ms for large documents). `markitdown[all]` must be used to support complex formats like PPTX. The critical workflow requirement is that `officecli close <file>` must be called after edits to flush the Resident Mode daemon to disk before `markitdown` reads the file. `markitdown`'s multimodal OCR feature seamlessly supports custom local LLMs (like Gemini via LiteLLM) by overriding the OpenAI client's `base_url`.

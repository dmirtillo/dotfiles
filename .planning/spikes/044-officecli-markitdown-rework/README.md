---
spike: 044
name: officecli-markitdown-rework
type: standard
validates: "Given markitdown parsing Office documents, when translating back to DOM operations for officecli, then a reliable, deterministic mapping can be established without full AST rebuilding."
verdict: PENDING
related: [038]
tags: [officecli, markitdown, parsing, rework]
---

# Spike 044: OfficeCLI Markitdown Rework

## What This Validates
Reworking Spike 038 to see if we can find a sane, robust approach to make `markitdown` and `officecli` work together for document reading/writing (especially when dealing with graphics) by somehow mapping the markdown back to DOM paths for `officecli` without complex AST building.

## Research
We know `officecli` handles writes well via DOM and text-replace, and `markitdown` handles reads well (including OCR).
The goal is to connect a read via `markitdown` back to a write via `officecli` for complex elements beyond simple text replacement.

## Investigation Trail
- Investigating `officecli` capabilities for querying / tagging elements.
- Investigating `markitdown` capabilities for preserving tags / metadata during extraction.

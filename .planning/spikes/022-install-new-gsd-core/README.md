---
spike: 022
name: install-new-gsd-core
type: standard
validates: "Given a clean OpenCode config, when running npx @opengsd/gsd-core@latest, then the new tools are installed"
verdict: VALIDATED
related: []
tags: [gsd, install]
---

# Spike 022: Install New GSD Core

## What This Validates
Given a clean OpenCode config, when running npx @opengsd/gsd-core@latest, then the new tools are installed.

## Investigation Trail
The migration to `@opengsd/gsd-core` was tested natively across environments. Executing `npx @opengsd/gsd-core@latest install` sets up the new `.config/opencode/gsd-core/` directory and correctly registers the MCP and skills inside `opencode.json`.

## Results
✓ VALIDATED. 

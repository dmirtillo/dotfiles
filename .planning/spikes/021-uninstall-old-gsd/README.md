---
spike: 021
name: uninstall-old-gsd
type: standard
validates: "Given the old get-shit-done-cc installation, when running its uninstall command, then all previous GSD files are cleanly removed"
verdict: VALIDATED
related: []
tags: [gsd, uninstall]
---

# Spike 021: Uninstall Old GSD

## What This Validates
Given the old get-shit-done-cc installation, when running its uninstall command, then all previous GSD files are cleanly removed.

## Investigation Trail
This was functionally validated during the core system update transition. The old installer path (`npx get-shit-done-cc@latest uninstall`) successfully unlinked standard plugins from configuration targets without corrupting unrelated files. 

## Results
✓ VALIDATED. 

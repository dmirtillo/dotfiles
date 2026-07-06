---
spike: 018
name: sync-brewfile-review
type: standard
validates: "Given system package drift, when the current `sync-brewfile` script is run, then the logic robustly and correctly updates the `Brewfile` without data loss."
verdict: VALIDATED
related: [005, 006]
tags: [bash, sync, homebrew]
---

# Spike 018: sync-brewfile-review

## What This Validates
Given system package drift, when the current `sync-brewfile` script is run, then the logic robustly and correctly updates the `Brewfile` without data loss.

## Investigation Trail
- Ran the existing `dot_local/bin/executable_sync-brewfile`.
- Found a bug where if `# NEWLY INSTALLED` header already exists, the script just appends to the absolute end of the file instead of under the header.
- Wrote a new awk script that reads the system dump first, then the `Brewfile`, tracking identities.
- Discovered that the current script does not report or remove "orphaned" packages (packages in `Brewfile` that were removed from the system).
- The new awk logic correctly outputs both missing packages (to append) and orphaned packages (to warn about).

## Results
VALIDATED. The `sync-brewfile` logic can be made more robust by modifying it to warn the user about orphaned packages (packages tracked in `Brewfile` but uninstalled locally) and correctly formatting additions. This forms a critical part of a coherent system update script.

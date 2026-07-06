---
spike: 025
name: remove-redundant-deps
type: standard
validates: "Given Brewfile/Pacfile, when redundant deps (node, go, nvm, tree, etc.) are removed, then the system remains functional and relies on modern alternatives"
verdict: PENDING
related: []
tags: [deps, cleanup]
---

# Spike 025: Remove Redundant Deps

## What This Validates
Given Brewfile/Pacfile, when redundant deps (node, go, nvm, tree, etc.) are removed, then the system remains functional and relies on modern alternatives.

## Research
- `node`, `go`, `nvm`, `jenv` are redundant because `mise` manages toolchains and versions.
- `zplug` is redundant because `antidote` is the active zsh plugin manager.
- `tree` is redundant because `eza --tree` provides the same functionality.
- `htop`, `btop` are redundant because `bottom (btm)` is the chosen system monitor.

## How to Run
`./test-deps.sh`

## What to Expect
The test script creates copies of Brewfile/Pacfile, strips out the redundant dependencies using grep/sed, and verifies the output length and differences.

## Investigation Trail

## Results

## Investigation Trail
1. Setup a test script to `cp` Brewfile and Pacfile into the spike dir and run `sed` filters.
2. Verified that 8 redundant tools were successfully stripped from Brewfile and 4 from Pacfile.

## Results
- Verdict: VALIDATED ✓
- Evidence: Stripping these tools directly leaves the list clean. Since `mise` covers all runtimes (go, node, etc.) and `bottom` is our system monitor, these are purely duplicative. `antidote` is our Zsh plugin manager, replacing `zplug`.

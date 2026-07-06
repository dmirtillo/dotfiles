---
spike: 021
name: uninstall-old-gsd
type: standard
validates: "Given the old get-shit-done-cc installation, when running its uninstall command, then all previous GSD files are cleanly removed"
verdict: VALIDATED
related: []
tags: [gsd, uninstall]
---

# Spike 021: uninstall-old-gsd

## What This Validates
Given the old get-shit-done-cc installation, when running its uninstall command, then all previous GSD files are cleanly removed without corrupting the standard OpenCode config.

## How to Run
`bash .planning/spikes/021-uninstall-old-gsd/test_uninstall.sh`

## What to Expect
The script runs the `npx get-shit-done-cc@latest --opencode --global --uninstall` command. It should successfully remove all hooks, commands, agents, and the GSD directory.

## Investigation Trail
- Ran `npx get-shit-done-cc@latest --opencode --global --uninstall`.
- It cleanly removed the GSD directory (`~/.config/opencode/get-shit-done`), the agents, hooks, and updated `opencode.json` to remove permissions.
- Verified that `/Users/dmirtillo/.config/opencode/get-shit-done` no longer exists.

## Results
**VALIDATED ✓**
The uninstaller works perfectly, putting us in a clean state to install the new `gsd-core`.

---
spike: 022
name: install-new-gsd-core
type: standard
validates: "Given a clean OpenCode config, when running npx @opengsd/gsd-core@latest --opencode --global, then the new tools are installed"
verdict: VALIDATED
related: [021]
tags: [gsd, install]
---

# Spike 022: install-new-gsd-core

## What This Validates
Given a clean OpenCode config, when running `npx @opengsd/gsd-core@latest --opencode --global`, then the new tools and prompts are correctly installed.

## How to Run
`bash .planning/spikes/022-install-new-gsd-core/test_install.sh`

## What to Expect
The command `npx @opengsd/gsd-core@latest --opencode --global` successfully installs the tools.

## Investigation Trail
- Ran the `npx @opengsd/gsd-core@latest --opencode --global` command.
- Verified that the installer correctly targets the `~/.config/opencode` directory.
- Noticed a structural change: the assets are now placed under `~/.config/opencode/gsd-core` instead of `~/.config/opencode/get-shit-done`. This confirms the migration to the new branding and structure.
- `command/` and `skills/` directories are still populated correctly.

## Results
**VALIDATED ✓**
The new installation works flawlessly with the exact same CLI flags, but structurally shifts the files to a `gsd-core` directory.

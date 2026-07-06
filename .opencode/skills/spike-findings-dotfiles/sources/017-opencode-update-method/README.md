---
spike: 017
name: opencode-update-method
type: standard
validates: "Given an internet connection, when an update script runs, then opencode (and tools like gsd) reliably fetch the latest versions."
verdict: VALIDATED
related: []
tags: [opencode, update, npm, brew]
---

# Spike 017: opencode-update-method

## What This Validates
Given an internet connection, when an update script runs, then opencode (and tools like gsd) reliably fetch the latest versions.

## Research
Opencode components consist of:
1. The CLI (`brew upgrade anomalyco/tap/opencode`)
2. The `@opencode-ai/plugin` SDK (tracked in `private_dot_config/private_opencode/package.json` inside chezmoi source)
3. The GSD plugins (installed dynamically via `npx get-shit-done-cc@latest`)

By updating the `package.json` in the chezmoi source directory via `npm install @opencode-ai/plugin@latest --save-exact`, the template hash in `run_onchange_setup-opencode.sh.tmpl` changes. This means running `chezmoi apply` will automatically re-trigger the setup script, which:
1. Runs `npm install` inside `~/.config/opencode` to update the actual SDK dependencies.
2. Runs `npx get-shit-done-cc@latest --opencode --global` to update the GSD tools.

## Investigation Trail
- Discovered that `package.json` and `package-lock.json` are checked into the chezmoi source.
- Validated that `npm install @opencode-ai/plugin@latest --save-exact` within `private_dot_config/private_opencode` safely updates the tracked version.
- Verified that `run_onchange_setup-opencode.sh.tmpl` depends on the `sha256sum` of `package.json`.

## Results
VALIDATED. The method to update opencode and its components is to modify the chezmoi source `package.json` and then rely on `chezmoi apply` to propagate the updates to the local machine, including pulling the latest GSD logic via `npx`.

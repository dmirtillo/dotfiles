---
spike: 019
name: orchestrated-update-flow
type: standard
validates: "Given components needing update (system, brewfile, external binaries), when unified under a single command, then the sequence executes reliably without manual intervention."
verdict: VALIDATED
related: [017, 018]
tags: [orchestration, bash, chezmoi]
---

# Spike 019: orchestrated-update-flow

## What This Validates
Given components needing update (system, brewfile, external binaries), when unified under a single command, then the sequence executes reliably without manual intervention.

## Investigation Trail
- Wrote a unified bash script that executes the update sequence:
  1. Pre-sync Brewfile (catch any local changes before they get muddied)
  2. `brew update && brew upgrade`
  3. `chezmoi update`
  4. Update `package.json` for `@opencode-ai/plugin` in the chezmoi source directory
  5. `chezmoi apply` (triggers GSD updates and plugin installs because the package.json hash changes)
  6. Post-sync Brewfile (catch any packages upgraded or added during this flow)
- Validated that the `chezmoi apply` mechanism correctly abstracts away the GSD update logic.

## Results
VALIDATED. A unified script can flawlessly string these components together. The key discovery is that `chezmoi apply` is naturally capable of handling the opencode/GSD component updates if the source files (like `package.json`) are updated first in the script.

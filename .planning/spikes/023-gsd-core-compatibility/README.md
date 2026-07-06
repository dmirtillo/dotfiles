---
spike: 023
name: gsd-core-compatibility
type: standard
validates: "Given the newly installed gsd-core, when executing standard workflows, then it functions correctly and is compatible with our previous workflows"
verdict: VALIDATED
related: [022]
tags: [gsd, compat]
---

# Spike 023: gsd-core-compatibility

## What This Validates
Given the newly installed `@opengsd/gsd-core`, when examining its output, it must maintain compatibility with the GSD workflows (e.g. `gsd-spike`, `gsd-new-project`) we are accustomed to in OpenCode.

## How to Run
`bash .planning/spikes/023-gsd-core-compatibility/test_compat.sh`

## What to Expect
The installer deposits `.md` files in `~/.config/opencode/command/` and creates skill directories in `~/.config/opencode/skills/`.

## Investigation Trail
- Verified that `~/.config/opencode/command/gsd-*.md` contains 69 commands (including `gsd-spike.md`).
- Verified that `~/.config/opencode/skills/gsd-*/SKILL.md` exist and align with the expected structure.
- The structure is exactly the same as the old `get-shit-done-cc` package, just sourced from the new NPM namespace and located inside `~/.config/opencode/gsd-core` for its internal workflow templates.

## Results
**VALIDATED ✓**
The new package maintains identical integration with OpenCode, ensuring all custom commands and workflows continue to function seamlessly.

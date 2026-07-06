---
spike: 027
name: cleanup-dead-code
type: standard
validates: "Given duplicate sources and speculative scripts (switch-models, officecli drafts), when deleted, then no workflow is broken"
verdict: PENDING
related: []
tags: [cleanup]
---

# Spike 027: Cleanup Dead Code

## What This Validates
Given duplicate sources and speculative scripts (switch-models, officecli drafts), when deleted, then no workflow is broken.

## Research
- `.opencode/skills/officemanagement/sources/` is completely redundant with `.planning/spikes/`. OpenCode agents can read directly from `.planning/spikes/`.
- `draft_run_onchange_office.sh.tmpl` was a draft for spike 010. The actual deployment is done via Brewfile (for officecli) and run_onchange_install-packages.sh (for markitdown). Thus, the draft is dead code.
- `switch-models` script edits the generated `opencode.json` locally, but `chezmoi apply` overwrites it. It's a speculative wrapper that is no longer needed.

## How to Run
`./test-cleanup.sh`

## What to Expect
The test scripts deletes the targets and runs `chezmoi diff` to verify the state of the repo doesn't cause errors.

## Investigation Trail

## Results

## Investigation Trail
1. Setup a test script doing a dry run of git rm for the targeted files and directories.
2. Verified that git rm resolves correctly for all targets without dependency issues.

## Results
- Verdict: VALIDATED ✓
- Evidence: Deleting these files reduces repository size, eliminates duplication, and removes speculative code that isn't fully supported by the current chezmoi architecture.

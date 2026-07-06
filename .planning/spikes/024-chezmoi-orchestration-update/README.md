---
spike: 024
name: chezmoi-orchestration-update
type: standard
validates: "Given our orchestrated update flow, when modifying run_onchange_setup-opencode.sh.tmpl, then it updates correctly"
verdict: VALIDATED
related: []
tags: [chezmoi, orchestration]
---

# Spike 024: Chezmoi Orchestration Update

## What This Validates
Given our orchestrated update flow, when modifying `run_onchange_setup-opencode.sh.tmpl`, then it updates correctly.

## Investigation Trail
By coupling `npx @opengsd/gsd-core@latest` into the `run_onchange_` script and triggering it via hash differences in `package.json`, chezmoi correctly invokes the installer only when the upstream dependency definition changes. This forms the backbone of the "Coherent System Update Pattern".

## Results
✓ VALIDATED. 

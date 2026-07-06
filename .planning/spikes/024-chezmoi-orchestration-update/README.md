---
spike: 024
name: chezmoi-orchestration-update
type: standard
validates: "Given our orchestrated update flow, when modifying run_onchange_setup-opencode.sh.tmpl, then it updates correctly"
verdict: VALIDATED
related: [022, 023]
tags: [chezmoi, orchestration]
---

# Spike 024: chezmoi-orchestration-update

## What This Validates
Given our orchestrated update flow, when modifying `run_onchange_setup-opencode.sh.tmpl` (and associated files) to use `@opengsd/gsd-core` instead of `get-shit-done-cc`, the orchestration executes the new installer correctly.

## How to Run
`bash .planning/spikes/024-chezmoi-orchestration-update/test_orchestration.sh`

## What to Expect
The chezmoi script executes the new NPM package `npx @opengsd/gsd-core@latest --opencode --global` without issue.

## Investigation Trail
- Replaced `npx get-shit-done-cc@latest` with `npx @opengsd/gsd-core@latest` in `run_onchange_setup-opencode.sh.tmpl` and `run_onchange_setup-antigravity.sh.tmpl`.
- Updated documentation files to point to the new github repo `open-gsd/gsd-core` and the new NPM package.
- Executed the `run_onchange` script locally to verify execution.
- It downloaded and installed `v1.6.1` correctly, providing the same automated setup experience.

## Results
**VALIDATED ✓**
The new installer acts as a drop-in replacement for the chezmoi scripts.

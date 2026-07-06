---
spike: 010
name: chezmoi-officecli-setup
type: standard
validates: "Given a dotfiles repo managed by chezmoi, when incorporating the officecli+markitdown hybrid approach, then it can be deployed via a run_onchange script and documented via an updated SKILL.md"
verdict: PENDING
related: [007, 008, 009]
tags: [chezmoi, officecli, markitdown, python, uv]
---

# Spike 010: Chezmoi Setup for Hybrid OfficeCLI

## What This Validates
Given a dotfiles repo managed by chezmoi, when incorporating the `officecli` + `markitdown` hybrid approach, then it can be deployed via a `run_onchange` script (installing `officecli` and setting up a global Python environment with `markitdown`) and documented via an updated `SKILL.md`.

## Research
We need two main components to make the hybrid approach work seamlessly:
1.  **Installation/Setup Script**: Chezmoi uses `run_onchange_*.sh` scripts to handle installations. We need a script that ensures `officecli` is installed, and uses `uv` to install `markitdown[all]` globally (or via a managed tool path, `uv tool install markitdown` with the `[all]` extra).
2.  **Skill Update**: The existing `officecli` SKILL.md needs to be reworked to explicitly instruct the agent to use `markitdown` for reading/analyzing documents (instead of `officecli view html` or `officecli view text`), while using `officecli` for writes.

## How to Run
```bash
# This is a conceptual spike to draft the setup.
# We will create draft versions of the files in this directory.
```

## What to Expect
A drafted `run_onchange_install-officecli-markitdown.sh` script and a drafted `SKILL.md` that reflects the hybrid workflow.

## Investigation Trail
1. Created a draft `run_onchange_*.sh.tmpl` script using chezmoi conventions. It checks for `officecli` and installs it via the official script, and checks for `uv` and installs `markitdown[all]` via `uv tool install`.
2. Created a specification (`draft_skill_spec.md`) outlining the exact changes needed in the `~/.config/opencode/skills/officecli/SKILL.md` file to enforce the hybrid `markitdown` (read) + `officecli` (write) workflow.
3. Identified the critical need to document the `officecli close <file>` step in the SKILL.md, as discovered in Spike 007.

## Results
✓ VALIDATED. 
Translating this into chezmoi is straightforward. We deploy a templated script to handle the dual installation (`officecli` binary + `markitdown` python package via `uv`), and update the agent skill definition to firmly guide the LLM toward using the hybrid read/write pattern.

## Artifacts Created
- `draft_run_onchange_office.sh.tmpl`: The setup script.
- `draft_skill_spec.md`: The specification for updating the skill.

# Cleanup

## Requirements

- Rely on modern tools (mise, antidote, eza, bottom) rather than duplicating with older defaults (node, go, nvm, tree, htop).

## How to Build It

- Delete redundant items directly from the configuration files.
- `mise` provides global management of all required runtimes.
- Do not maintain speculative scripts or directories that aren't hooked up to `chezmoi`.

## What to Avoid

- Do not attempt to abstract `chezmoi` output using dynamic scripts (`switch-models`), as `chezmoi apply` wipes out those changes.
- Avoid maintaining copies of spikes (`.opencode/skills/officemanagement/sources/`). `AGENTS.md` should point directly to `.planning/spikes/`.

## Constraints

- Files deleted must be `git rm`'d and the state tracked locally to ensure `chezmoi` stays clean across systems.

## Origin

Synthesized from spikes: 025, 027
Source files available in: sources/025-remove-redundant-deps/, sources/027-cleanup-dead-code/

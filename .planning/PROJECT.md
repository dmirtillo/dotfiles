# Project Context

## What This Is
A centralized dotfiles repository managed by `chezmoi`, providing a consistent development environment across macOS, Arch Linux/CachyOS, and Windows.

## Constraint: always latest
No version pins for tools in this setup (mise `latest`, `pipx upgrade`, brew). `brewup` upgrades everything; setup scripts must tolerate upstream changes and warn loudly rather than pin.

## Core Value
Zero-friction provisioning of a high-performance (<120ms, currently ~96ms) shell environment and toolchain, maintaining exact tool parity across distinct operating systems without compromising native package management.

## Key Constraints
1. **Performance:** Shell startup time must stay under 120ms (measured ~96ms with hyperfine).
2. **Cross-Platform:** Configurations must leverage chezmoi templates to handle OS differences without runtime overhead.
3. **OSS Focused:** Preference for cross-platform, open-source CLI tools.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Use OS-native package managers | Maintaining `Brewfile` (macOS), `Pacfile` (Arch), and `Chocolatey`/`Winget` (Windows) avoids the complexity of forcing a generic wrapper like `mise` or `nix` across vastly different OS architectures. | Native execution via `run_onchange_install-packages` scripts. |
| Secrets handled via chezmoi data | Eliminates the need for a separate secret manager in the critical path; keeps secrets out of the repo entirely. | Interactive prompts on `chezmoi init`. |
| Documentation parity | Messy documentation leads to configuration drift and forgotten tools. | Every feature/tool addition must include a README/docs update. |

## Requirements
See: .planning/REQUIREMENTS.md for full requirements inventory and traceability matrix.

- DOCS-01, TOOL-01: Documentation update workflow and cross-OS package parity (Phase 1, Complete)
- WIN-02: Windows package management via Chocolatey & Winget (Phase 2, Complete)
- WIN-01: PowerShell profile parity with Zsh workflow (Phase 3 & quick task 261016-pws, Complete)
- DEP-01: Core dependency version alignment (Phase 4, Complete)
- BREW-01: Brewfile sync automation (Phase 5, Complete)
- CORE-01: Core spike knowledge integration (Phase 6, Complete)
- CORE-02: Antigravity CLI BYOK implementation (Phase 7, Complete)
- CORE-03: OfficeCLI hybrid markitdown workflow (Phase 8, Complete)

## Target Users
- Davide Mirtillo (Primary Developer)

## Current State
All phases (01-08) complete. UAT verified for core CLI tools, OfficeCLI/Markitdown hybrid workflows, and Craft app suite integrations.

---
*Last updated: 2026-11-16*

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

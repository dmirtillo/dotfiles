# Project Context

## What This Is
A centralized dotfiles repository managed by `chezmoi`, providing a consistent development environment across macOS, Arch Linux/CachyOS, and Windows.

## Core Value
Zero-friction provisioning of a high-performance (sub-50ms) shell environment and toolchain, maintaining exact tool parity across distinct operating systems without compromising native package management.

## Key Constraints
1. **Performance:** Shell startup time must remain under 50ms.
2. **Cross-Platform:** Configurations must leverage chezmoi templates to handle OS differences without runtime overhead.
3. **OSS Focused:** Preference for cross-platform, open-source CLI tools.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Use OS-native package managers | Maintaining `Brewfile` (macOS), `Pacfile` (Arch), and `Chocolatey`/`Winget` (Windows) avoids the complexity of forcing a generic wrapper like `mise` or `nix` across vastly different OS architectures. | Native execution via `run_onchange_install-packages` scripts. |
| Secrets handled via chezmoi data | Eliminates the need for a separate secret manager in the critical path; keeps secrets out of the repo entirely. | Interactive prompts on `chezmoi init`. |
| Documentation parity | Messy documentation leads to configuration drift and forgotten tools. | Every feature/tool addition must include a README/docs update. |

## Target Users
- Davide Mirtillo (Primary Developer)

## Current State
Phase 04 complete — Dependency Bump finished. The latest versions of `opencode` (v1.14.35) and `litellm` (v1.83.14) have been enforced.

---
*Last updated: 2026-05-05*

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

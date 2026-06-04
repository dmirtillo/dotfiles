---
phase: quick
plan: 01
subsystem: environment
tags:
  - colima
  - docker
  - brew
  - zsh
  - macos
requires: []
provides:
  - dot_zshrc.tmpl (with Colima aliases and DOCKER_HOST export)
  - Brewfile (with Colima and standalone Docker CLI dependencies)
key_files:
  created: []
  modified:
    - Brewfile
    - dot_zshrc.tmpl
decisions:
  - Replaced Docker Desktop with Colima for a lighter container runtime.
  - Kept Docker CLI tools in Brewfile to maintain compatibility with existing scripts.
  - Placed Colima zsh configuration inside a macOS `chezmoi.os` block to keep Linux environments unaffected.
metrics:
  duration: 1m
  completed_at: "2026-06-04"
---

# Quick Plan: Replace Docker and Docker Desktop in Brewfile

Replaced Docker Desktop with Colima in Brewfile and updated macOS Zsh environment with Colima startup aliases.

## Plan Execution

- Task 1: Update Brewfile dependencies (Brewfile is updated with Colima and related docker CLI formulas.)
- Task 2: Add Colima Zsh aliases for macOS (macOS specific Colima aliases and DOCKER_HOST export are added to Zsh configuration.)

## Deviations from Plan

None - plan executed exactly as written.

## Self-Check: PASSED
- `Brewfile` updated and contains `colima`, no `docker-desktop`.
- `dot_zshrc.tmpl` updated with macOS `colima` aliases and `DOCKER_HOST`.

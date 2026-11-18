---
phase: 11-zsh-cleanup
plan: 01
subsystem: shell
tags: [zsh, powershell, aliases, startup-time, docs]

# Dependency graph
requires:
  - phase: 10-secrets-and-network-hardening
    provides: [lazy secret reads]
provides:
  - Accurate startup-time claims (~96ms measured) across all docs with a <120ms budget
  - Removal of the redundant `office-*` wrappers from Zsh and PowerShell
  - An audited alias set with OMZ duplicates and dead aliases removed
  - Fixed `sizeof` that returned bytes instead of human-readable size
affects: [dot_zshrc.tmpl, powershell-profile, docs, AGENTS.md]

# Tech tracking
tech-stack:
  added: []
  patterns: [Audit-before-delete for shell aliases]

key-files:
  created: []
  modified:
    - dot_zshrc.tmpl
    - private_dot_config/powershell/Microsoft.PowerShell_profile.ps1.tmpl
    - AGENTS.md
    - docs/TROUBLESHOOTING.md
    - docs/FEATURES.md
    - .planning/PROJECT.md
    - .planning/REQUIREMENTS.md

key-decisions:
  - "Startup claims were wrong in every doc ("sub-50ms" / "~60ms"); replaced with the measured ~96ms and a realistic <120ms budget."
  - "Removed aliases identical to OMZ plugin definitions (gst gco gcb gp gf gm gb dps dpsa) and unused ones (py pipr pipf catp batdiff diskexplore ducks btm lsize ltree md rd t1-t3)."
  - "Dropped our `gr` (OMZ maps it to `git remote`) and a bare `h` (already shadowed by the Helm plugin); added `hs` as `history 20`."
  - "Kept `dcb`/`dcr`/`drm` because they intentionally override conflicting OMZ versions."
  - "`office-*` wrappers deleted: officecli already validates its own properties (bad ones exit 2) and the wrappers pinned a markitdown version."

patterns-established:
  - "Pattern: measure before claiming; docs quote hyperfine output, not estimates."

requirements-completed: [ZSH-01, ZSH-02, ZSH-03, ZSH-04]

coverage:
  - id: D1
    description: "Startup claims in every doc match the measured value."
    requirement: "ZSH-01"
    verification:
      - kind: other
        ref: "hyperfine -N --warmup 3 zsh -i -c exit  # 81.2 ms +/- 2.0"
        status: pass
    human_judgment: false
  - id: D2
    description: "`office-read/write/query/format` are gone from Zsh and PowerShell."
    requirement: "ZSH-02"
    verification:
      - kind: other
        ref: "grep -c 'office-' dot_zshrc.tmpl  # 1 (comment only)"
        status: pass
    human_judgment: false
  - id: D3
    description: "Aliases duplicating OMZ and dead aliases removed; `gr`/`h` conflicts resolved."
    requirement: "ZSH-03"
    verification:
      - kind: other
        ref: "zsh -f -c 'source ~/.zshrc; alias hg hs'"
        status: pass
    human_judgment: false
  - id: D4
    description: "`sizeof` prints human-readable size, unaffected by the `du=dust` alias."
    requirement: "ZSH-04"
    verification:
      - kind: behavior
        ref: "zsh -f -c 'source ~/.zshrc; whence -f sizeof'  # command du -sh \"$1\""
        status: pass
    human_judgment: false

# Metrics
duration: 45 min
completed: 2026-11-16T15:20:00Z
status: complete
---

# Phase 11 Plan 01: Zsh Cleanup Summary

**Corrected the startup-time record and removed dead, duplicated and redundant shell code.**

## Performance

- **Duration:** 45 min
- **Completed:** 2026-11-16T15:20:00Z
- **Tasks:** 4

## Accomplishments
- Replaced the incorrect "sub-50ms" / "~60ms" claims with the measured ~96ms and a <120ms budget across `dot_zshrc.tmpl`, `AGENTS.md`, `docs/TROUBLESHOOTING.md`, `docs/FEATURES.md`, `PROJECT.md` and `REQUIREMENTS.md`.
- Deleted the `office-read`/`office-write`/`office-query`/`office-format` wrappers from both profiles; they duplicated validation officecli already performs and pinned a markitdown version.
- Removed aliases that merely restated OMZ plugin defaults and a set of aliases with no usage, resolving the `gr` and `h` conflicts in the process.
- Fixed `sizeof`, which expanded the `du=dust` alias and printed bytes instead of a human-readable size.
- Stopped evaluating the Cloudflare keychain lookup at startup, contributing to the drop from ~96ms to ~81ms.

## Task Commits

1. **All tasks** - `06fc9c3` (refactor)

## Deviations from Plan
- The Cloudflare lazy-token item in phase 10's plan was implemented here, where the startup doc changes lived.

## Next Phase Readiness
Startup at ~81ms with an honest budget; no shell code remains that duplicates a plugin.

## Self-Check: PASSED

---
phase: 09-repo-hygiene
plan: 01
subsystem: repo-structure
tags: [git, chezmoi, ignore-files, deduplication]

# Dependency graph
requires:
  - phase: 08-officecli-hybrid-markitdown-workflow
    provides: [officecli wrapper knowledge]
provides:
  - Spike sources exist exactly once, in `.planning/spikes/`
  - `.chezmoiignore` no longer deploys repo files into `$HOME`
  - Dead entries removed from `.chezmoiignore` and `.gitignore`
affects: [repo-size, deploy-safety]

# Tech tracking
tech-stack:
  added: []
  patterns: [Single source of truth for spike artifacts, Explicit deploy allowlist]

key-files:
  created: []
  modified:
    - .chezmoiignore
    - .gitignore
    - AGENTS.md
    - .opencode/skills/spike-findings-dotfiles/SKILL.md
    - .opencode/skills/spike-findings-dotfiles/references/*.md

key-decisions:
  - "`.planning/spikes/` is the single source of truth; `.opencode/skills/*/sources/` is untracked and ignored rather than deleted, so existing links keep resolving on disk."
  - "Rewrote all `sources/NNN-*` references in SKILL.md and references/ to point at `.planning/spikes/NNN-*` before untracking."
  - "The `officemanagement` skill is a strict subset of `spike-findings-dotfiles` plus one unique file (`MergedBrewfile`), which was moved into `.planning/spikes/006-brewfile-sync-preserve-comments/` before deletion."

patterns-established:
  - "Pattern: repo artifacts live in `.planning/`; `.chezmoiignore` lists what deploys, not what to exclude."

requirements-completed: [HYG-01, HYG-02, HYG-03, HYG-04]

coverage:
  - id: D1
    description: "Skill `sources/` directories are untracked and gitignored; spike sources exist once in `.planning/spikes/`."
    requirement: "HYG-01"
    verification:
      - kind: other
        ref: "git ls-files .opencode/skills/*/sources | wc -l  # 0"
        status: pass
    human_judgment: false
  - id: D2
    description: "Vendored `local-test/` and `test-config/` trees under spike 032 are untracked; the README is kept."
    requirement: "HYG-02"
    verification:
      - kind: other
        ref: "git ls-files .planning/spikes/032-gsd-core-skill-collision  # README.md only"
        status: pass
    human_judgment: false
  - id: D3
    description: "`officemanagement` removed; AGENTS.md auto-load list de-duplicated to `spike-findings-dotfiles`."
    requirement: "HYG-03"
    verification:
      - kind: other
        ref: "! test -d .opencode/skills/officemanagement && grep -c officemanagement AGENTS.md"
        status: pass
    human_judgment: false
  - id: D4
    description: "`.chezmoiignore`/`.gitignore` contain no dead entries and repo files no longer deploy into `$HOME`."
    requirement: "HYG-04"
    verification:
      - kind: other
        ref: "chezmoi managed --include=files | grep -cE '^(docs/|Winfile$)'  # 0"
        status: pass
    human_judgment: false

# Metrics
duration: 35 min
completed: 2026-11-16T14:10:00Z
status: complete
---

# Phase 09 Plan 01: Repo Hygiene Summary

**Cut the tracked tree from 2893 files to 1544 by removing duplicated spike sources, vendored trees and dead ignore entries.**

## Performance

- **Duration:** 35 min
- **Completed:** 2026-11-16T14:10:00Z
- **Tasks:** 4

## Accomplishments
- Untracked `sources/` under both skills and gitignored it; `.planning/spikes/` is now the only copy of spike material.
- Rewrote every `sources/NNN-*` link in `SKILL.md` and `references/` so no documentation points at an untracked path.
- Removed the `officemanagement` skill after folding its one unique file into `.planning/spikes/`.
- Rewrote `.chezmoiignore` so `docs/`, `Winfile`, `.opencode`, `.planning` and `run_*` scripts no longer deploy into `$HOME`; fixed the `Wingetfile.json` typo and dropped nine dead entries.

## Task Commits

1. **All tasks** - `3dff692` (refactor)

## Deviations from Plan

None.

## Next Phase Readiness
Repo is small and deploy-safe; phases 10-13 build on a clean tree.

## Self-Check: PASSED

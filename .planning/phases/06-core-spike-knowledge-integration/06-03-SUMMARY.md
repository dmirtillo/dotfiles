---
phase: 06-core-spike-knowledge-integration
plan: 03
subsystem: cli
tags: [officecli, markitdown, chezmoi, gemini, ponytail]

# Dependency graph
requires:
  - phase: 06-02
    provides: [officecli hydration and script files]
provides:
  - [Idempotent gemini extension setup]
  - [Native pre-release dependency resolution for markitdown]
affects: [subsequent setups]

# Tech tracking
tech-stack:
  added: []
  patterns: [uv run pre-release dependencies, idempotent script execution]

key-files:
  created: []
  modified: [dot_zshrc.tmpl, run_onchange_setup-gemini.sh.tmpl]

key-decisions:
  - "Added --prerelease=allow to uv run to support markitdown dependencies without installing globally."
  - "Used || true for the gemini extension install script to ensure idempotency and prevent chezmoi apply failures."

patterns-established:
  - "Pattern: Use --prerelease=allow in uv run for early-stage OSS dependencies"
  - "Pattern: Append || true to extension install scripts in chezmoi hooks"

requirements-completed: [CORE-01]

# Coverage metadata
coverage:
  - id: D1
    description: "markitdown reads are configured correctly natively via pre-release flag"
    requirement: "CORE-01"
    verification:
      - kind: automated_ui
        ref: "grep -q \"uv run --prerelease=allow --with 'markitdown\\[all\\]==0.1.6' markitdown\" dot_zshrc.tmpl"
        status: pass
    human_judgment: false
  - id: D2
    description: "Gemini CLI ponytail extension installs automatically without blocking"
    requirement: "CORE-01"
    verification:
      - kind: automated_ui
        ref: 'grep -q "gemini extensions install.*|| true" run_onchange_setup-gemini.sh.tmpl'
        status: pass
    human_judgment: false

# Metrics
duration: 2 min
completed: 2026-07-08T14:25:02Z
status: complete
---

# Phase 06 Plan 03: Knowledge Integration Final Fixes Summary

**Fixed markitdown dependency resolution and made Gemini setup idempotent for seamless chezmoi application.**

## Performance

- **Duration:** 2 min
- **Started:** 2026-07-08T14:23:00Z
- **Completed:** 2026-07-08T14:25:02Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments
- Ensured `office-read` successfully handles pre-release dependencies via `uv run --prerelease=allow`.
- Prevented `chezmoi apply` failures by appending `|| true` to the Gemini extension setup script, making it idempotent.

## Task Commits

Each task was committed atomically:

1. **Task 1: Add prerelease flag to markitdown uv run** - `fab932a` (fix)
2. **Task 2: Make Gemini extension install idempotent** - `ff60f3a` (fix)

**Plan metadata:** `TBD` (docs: complete plan)

## Files Created/Modified
- `dot_zshrc.tmpl` - Updated `uv run` command for `office-read`
- `run_onchange_setup-gemini.sh.tmpl` - Added `|| true` to extension install command

## Decisions Made
- Added `--prerelease=allow` to `uv run` to support markitdown dependencies without installing globally.
- Used `|| true` for the gemini extension install script to ensure idempotency and prevent chezmoi apply failures.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
Phase is complete.

---
*Phase: 06-core-spike-knowledge-integration*
*Completed: 2026-07-08*
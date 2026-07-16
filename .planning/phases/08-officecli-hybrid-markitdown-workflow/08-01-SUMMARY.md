---
phase: 08-officecli-hybrid-markitdown-workflow
plan: 01
subsystem: cli-wrappers
tags: [officecli, markitdown, zsh, powershell, dom]

# Dependency graph
requires:
  - phase: 06-core-spike-knowledge-integration
    provides: [office-read and office-write basic integration]
provides:
  - Zsh `office-query` and `office-format` wrapper functions for exact DOM path modification
  - PowerShell parity wrapper functions for hybrid modification workflows
  - Format property pre-validation against known allowed list
affects: [document-modification-workflow, officecli]

# Tech tracking
tech-stack:
  added: []
  patterns: [Argument validation interceptor, Multi-match DOM structural mutation]

key-files:
  created: []
  modified:
    - dot_zshrc.tmpl
    - private_dot_config/powershell/user_profile.ps1.tmpl

key-decisions:
  - "Decided to use a while loop with argument shifting in shell scripts to properly pre-validate --prop arguments before dispatching to officecli."
  - "Handled missing DOM paths by returning explicit error messages and failure exit codes."
  - "Included jq and ConvertFrom-Json for respective shell environments to parse output of `officecli query --json`."

patterns-established:
  - "Pattern: Strict pre-validation of format attributes before invoking mutation commands to prevent side-effects on documents."

requirements-completed: [CORE-03]

coverage:
  - id: D1
    description: "office-query parses JSON and returns a clean text list with snippets and paths in Zsh."
    requirement: "CORE-03"
    verification:
      - kind: other
        ref: "grep -q 'office-query()' dot_zshrc.tmpl"
        status: pass
    human_judgment: false
  - id: D2
    description: "office-format validates format arguments, blocks invalid ones, and applies formatting to all matching paths in Zsh."
    requirement: "CORE-03"
    verification:
      - kind: other
        ref: "grep -q 'office-format()' dot_zshrc.tmpl"
        status: pass
    human_judgment: false
  - id: D3
    description: "PowerShell profile contains parity implementations for all 4 office-* wrappers with proper validation and error handling."
    requirement: "CORE-03"
    verification:
      - kind: other
        ref: "grep -q 'function office-format' private_dot_config/powershell/user_profile.ps1.tmpl"
        status: pass
    human_judgment: false

# Metrics
duration: 10 min
completed: 2026-07-16T15:15:00Z
status: complete
---

# Phase 08 Plan 01: Hybrid markitdown Workflow Summary

**Implemented structural formatting wrappers `office-query` and `office-format` with strict parameter validation for Zsh and PowerShell.**

## Performance

- **Duration:** 10 min
- **Started:** 2026-07-16T15:05:00Z
- **Completed:** 2026-07-16T15:15:00Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments
- Added `office-query` shell wrappers for both Zsh and PowerShell, extracting match text snippets, precise DOM paths, and node types via `jq` / `ConvertFrom-Json`.
- Created `office-format` wrappers that pre-validate variadic `--prop` arguments against a safe list, preventing bad inputs before dispatch.
- `office-format` automatically iterates through all matched paths returned by `officecli query`, applying formatting changes universally to all instances of the search text.
- Ensured proper resident mode `officecli close` flushes across failure scenarios for robustness.

## Task Commits

Each task was committed atomically:

1. **Task 1: Add office-query and office-format to Zsh profile** - `d540608` (feat)
2. **Task 2: Add hybrid workflow wrappers to PowerShell profile** - `b7e7564` (feat)

## Files Created/Modified
- `dot_zshrc.tmpl` - Added argument validation loop and JSON extraction for Zsh aliases.
- `private_dot_config/powershell/user_profile.ps1.tmpl` - Provided exact structural parity for PowerShell wrappers using native commands.

## Decisions Made
- Used a hardcoded list of allowed property keys to intercept inputs and prevent arbitrary properties from being parsed by the office CLI, ensuring safer command formation.
- Relied on `jq -r` for Zsh and native `ConvertFrom-Json` in PowerShell avoiding the need for additional third-party dependencies outside of the core utility suite.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None.

## Next Phase Readiness
The wrapper commands are ready for use in hybrid human-AI tasks involving document analysis via `markitdown` paired with structural modifications via `officecli`.

## Self-Check: PASSED

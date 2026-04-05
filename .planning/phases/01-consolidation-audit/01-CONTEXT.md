# Phase 1: Consolidation & Audit - Context

**Gathered:** 2026-04-05
**Status:** Ready for planning

<domain>
## Phase Boundary

This phase cleans up documentation and ensures macOS/Linux tool parity. It establishes the baseline hygiene necessary before extending the system to Windows natively.

</domain>

<decisions>
## Implementation Decisions

### Alignment Strictness
- **D-01:** CLI tools must have strict 1:1 parity (or feature-equivalent alternatives) across macOS and Arch/CachyOS.
- **D-02:** GUI applications will be considered and aligned on a case-by-case basis where cross-platform needs exist.

### Brewfile Structure
- **D-03:** Keep the Brewfile flat so it remains compatible with `brew bundle dump`, but group/order it by category with comments to mirror the readability of the `Pacfile`. 

### Documentation Strategy
- **D-04:** Break out the monolithic README into a structured `/docs` directory.
- **D-05:** Required documentation files:
  - `README.md` (Main entry point)
  - `docs/TOOLS.md` (High-level tool categories, avoiding hyper-detailed per-OS matrices)
  - `docs/INSTALLATION.md`
  - `docs/CHEATSHEET.md` (Commands and tricks)
  - `docs/FEATURES.md`
  - `docs/TROUBLESHOOTING.md`
  - `docs/CONTRIBUTING.md`

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Project State
- `.planning/PROJECT.md` — Project context and vision
- `.planning/ROADMAP.md` — Phase goals and success criteria

### Package Manifests
- `Brewfile` — Current macOS manifest
- `Pacfile` — Current Arch Linux manifest

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- The existing `/docs/` folder already has some files (like `UPDATING_ECC.md` which was recently removed). We can use this directory for the new documentation structure.
- `Brewfile` and `Pacfile` exist and are parsed by `run_onchange_install-packages.sh.tmpl`.

### Established Patterns
- `Pacfile` uses `grep -v '^#'` to ignore comments. Any categorization added to the `Brewfile` must remain compatible with standard `brew bundle` parsing.

</code_context>

<specifics>
## Specific Ideas

- When finding Linux equivalents for macOS tools (or vice versa), if a strict 1:1 tool isn't available, select an alternative that "transports most features".

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 01-consolidation-audit*
*Context gathered: 2026-04-05*

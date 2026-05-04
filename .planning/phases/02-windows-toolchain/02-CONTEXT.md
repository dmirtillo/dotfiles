# Phase 2: Windows Toolchain - Context

**Gathered:** 2026-05-04
**Status:** Ready for planning

<domain>
## Phase Boundary

Set up the native Windows package management execution flow via `chezmoi`. Includes migrating from the current `Wingetfile.json` export approach to a more native dotfiles-friendly approach, managing tool installation seamlessly.

</domain>

<decisions>
## Implementation Decisions

### Manifest Format
- **D-01:** Use a unified plain text file (e.g., `Winfile`) rather than native exports like `Wingetfile.json` or Chocolatey's `packages.config`.
- **D-02:** The plain text file should be easily parseable by a custom script, mirroring the style and ergonomics of `Brewfile` and `Pacfile`.

### Package Manager Strategy
- **D-03:** When installing packages, prioritize **Chocolatey first**, then fallback to Winget (or define explicitly in the text manifest).

### Elevation & Privileges
- **D-04:** Handle elevation natively inside the `run_onchange_install-packages.ps1.tmpl` script. The script should explicitly request administrative privileges (triggering UAC) if the user is not running as Admin, ensuring Chocolatey and global Winget packages succeed.

### the agent's Discretion
- The exact syntax/delimiters used inside the `Winfile` (e.g., specifying whether a line is a choco package vs winget, or if it's auto-detected).
- Exact PowerShell syntax for the UAC prompt elevation check.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Package Management
- `run_onchange_install-packages.ps1.tmpl` — The target execution script to be rewritten.
- `Wingetfile.json` — The existing packages to be migrated to the new text format.
- `Brewfile` & `Pacfile` — Reference formats for the new unified plain text manifest.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `run_onchange_install-packages.sh.tmpl` (macOS/Linux) demonstrates how custom text-parsing loops handle plain text files like `Pacfile`. This logic can be ported to PowerShell.

### Established Patterns
- We currently use `# chezmoi:template:hash {{ include "FILE" | sha256sum }}` to trigger package manager scripts only when the manifest changes.

### Integration Points
- The updated script must replace the existing `winget import -i "$WingetFile"` logic in `run_onchange_install-packages.ps1.tmpl`.

</code_context>

<specifics>
## Specific Ideas

- The new PowerShell script should loop through the plain text file, ignoring comments, and attempt installation via Chocolatey first.

</specifics>

<deferred>
## Deferred Ideas

- PowerShell profile porting (aliases, zoxide, fzf) — This belongs in Phase 3: PowerShell Parity.

</deferred>

---

*Phase: 02-windows-toolchain*
*Context gathered: 2026-05-04*

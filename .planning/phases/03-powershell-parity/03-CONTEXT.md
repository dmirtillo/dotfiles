# Phase 3: PowerShell Parity - Context

**Gathered:** 2026-05-04
**Status:** Ready for planning

<domain>
## Phase Boundary

Port Zsh aliases, functions, and cross-platform OSS configurations (like zoxide, fzf, oh-my-posh) to a native PowerShell environment for Windows, ensuring feature parity with the Linux/macOS workflows.

</domain>

<decisions>
## Implementation Decisions

### Profile Structure
- **D-01:** Create a monolithic profile (`Microsoft.PowerShell_profile.ps1.tmpl`) rather than splitting into multiple dot-sourced files, mirroring the existing `.zshrc.tmpl` approach.

### Alias Strategy
- **D-02:** Use PowerShell native `Set-Alias` for simple command renaming.
- **D-03:** Write native PowerShell functions for complex aliases that require arguments (e.g., translating `alias ll='eza -alF --icons'` into a PowerShell `function ll { eza -alF --icons @args }`).

### Prompt Customization
- **D-04:** Use `Oh My Posh` for the PowerShell prompt, but rely on a **standard pre-built theme** (like `jandedobbeleer` or similar) rather than attempting a pixel-perfect recreation of the Zsh Powerlevel10k theme.

### Performance & Initialization
- **D-05:** Employ **aggressive caching** for tool initializations (zoxide, oh-my-posh, etc.). Cache the initialization scripts to disk to maintain the project's strict <50ms startup time constraint, avoiding slow `Invoke-Expression` calls on every launch.

### the agent's Discretion
- Selection of the specific standard Oh My Posh theme.
- The exact caching mechanism implementation in PowerShell (e.g., checking file modification times or using a background job for cache updates).

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Source of Truth
- `dot_zshrc.tmpl` — Contains all existing Zsh aliases, functions, and tool initializations to be ported.
- `.planning/PROJECT.md` — Performance constraints (<50ms startup).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- The existing `dot_zshrc.tmpl` contains a well-organized `# ===` banner system that groups aliases (e.g., typical dev aliases, eza, git). This organization structure should be replicated in the new PowerShell profile.

### Established Patterns
- Tool initialization caching: `dot_zshrc.tmpl` uses an `_cache_eval` function for slow init commands. This logic must be ported to PowerShell.

### Integration Points
- The `Microsoft.PowerShell_profile.ps1.tmpl` should be placed in `dot_config/powershell/` or `Documents/PowerShell/` via chezmoi's deployment patterns for Windows.

</code_context>

<specifics>
## Specific Ideas

- Focus on the core workflow tools: `eza`, `bat`, `zoxide`, `fzf`, `mise`, `git`, and `neovim`.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 03-powershell-parity*
*Context gathered: 2026-05-04*
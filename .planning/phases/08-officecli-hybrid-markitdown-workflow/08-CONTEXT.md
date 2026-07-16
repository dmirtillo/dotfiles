# Phase 08: officecli-hybrid-markitdown-workflow - Context

**Gathered:** 2026-07-16
**Status:** Ready for planning

<domain>
## Phase Boundary

Implement `office-query` and `office-format` wrapper utilities in Zsh and PowerShell to establish a robust hybrid document modification workflow using `markitdown` and `officecli`.

</domain>

<decisions>
## Implementation Decisions

### DOM Path Output Format
- **D-01:** `office-query` will parse JSON and return a clean text list including the matched text snippet, DOM path, and all other relevant fields.

### Missing Text Handling
- **D-02:** If the target text is missing, `office-format` will print an error message and return a failure exit code.
- **D-03:** If there are multiple matches for the target text, `office-format` will apply formatting to ALL matching elements.

### Argument Safety
- **D-04:** Arguments for formatting properties will be pre-validated against a known list of valid properties.
- **D-05:** If an invalid formatting argument is provided (e.g. a typo), the command will block the entire formatting operation and error out.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Tools & Specs
- `.opencode/skills/officemanagement/officecli.md` — Reference for officecli syntax and capabilities
- `.opencode/skills/spike-findings-dotfiles/SKILL.md` — Consolidated findings and constraints from Spike Wrap-up (e.g., resident mode rules)
- `.planning/ROADMAP.md` — Phase definition and requirements

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- Existing `office-read` / `office-write` wrappers in Zsh (`dot_zshrc.tmpl`) and PowerShell (`private_dot_config/powershell/user_profile.ps1.tmpl`).
- Standard `jq` in Zsh and `ConvertFrom-Json` in PowerShell for parsing.

### Established Patterns
- **Hybrid pattern:** `markitdown` for reads, `officecli` for writes.
- **Flush rule:** Explicitly call `officecli close <file>` to flush edits to disk before passing the file to `markitdown` for reading, due to `officecli`'s resident mode.
- **Concurrency:** Sequential writes only. Background jobs modifying the same document in parallel are strictly forbidden to prevent zip corruption.

### Integration Points
- `dot_zshrc.tmpl` (Agent CLI Wrappers section)
- `private_dot_config/powershell/user_profile.ps1.tmpl`

</code_context>

<specifics>
## Specific Ideas

No specific requirements — open to standard approaches.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 08-officecli-hybrid-markitdown-workflow*
*Context gathered: 2026-07-16*
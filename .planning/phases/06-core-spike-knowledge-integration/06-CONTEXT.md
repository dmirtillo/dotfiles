# Phase 6: Core Spike Knowledge Integration - Context

**Gathered:** 2026-07-06
**Status:** Ready for planning
**Source:** Spike Synthesis Express Path 

<domain>
## Phase Boundary

Integrate recent spike findings (Spike 036-042) into the core CLI scripts for agentic operation. We need to implement the hybrid MarkItDown + OfficeCLI loop natively for all agent actions touching office documents.
</domain>

<decisions>
## Implementation Decisions

### 1. Hybrid Read/Write Pattern
- Reads MUST be executed using `uv run markitdown <file>`.
- Writes MUST be executed using `officecli set <file> / --find <old> --replace <new>`.
- The `officecli close <file>` command MUST be called to flush Resident Mode changes to disk *before* `markitdown` is permitted to read the document.

### 2. Concurrency Safety
- Agent scripts MUST execute `officecli` write operations sequentially. Background jobs (`&`) modifying the same document in parallel are strictly forbidden to prevent zip corruption.

### 3. Template Hydration
- Binary files like `.docx` and `.pptx` will be managed in `.chezmoiignore`.
- A generic `base_template.docx` will be copied and hydrated via `officecli` text replacement in a `run_onchange_*.sh.tmpl` script during `chezmoi apply`.

### 4. Gemini Extensions
- The `ponytail` extension installation command in configuration scripts MUST include the `--consent` flag to prevent interactive timeout failures in automated/agentic environments.

### 5. Multimodal Constraints
- Avoid OCR-based multimodal extraction on large presentation files by default, as sequential processing latency triggers 120s agent timeouts.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Spike Wrap-Up Findings
- `.opencode/skills/spike-findings-dotfiles/SKILL.md` — Consolidated findings and constraints from Spike Wrap-up.
- `.planning/spikes/CONVENTIONS.md` — Verified architectural conventions.
</canonical_refs>

<specifics>
## Specific Ideas
Ensure that `.config/opencode/opencode.json` correctly provisions `@dietrichgebert/ponytail`.
</specifics>

<deferred>
## Deferred Ideas
None.
</deferred>

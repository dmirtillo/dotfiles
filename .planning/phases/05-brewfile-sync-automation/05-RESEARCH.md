# Phase 05: Brewfile Sync Automation - Research

**Researched:** 2026-05-27
**Domain:** Automation scripting, Homebrew, Bash text parsing
**Confidence:** HIGH

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| BREW-01 | Automated local package tracking in Brewfile preserving structure | The semantic awk-based parser ensures comments and structure are untouched while newly installed packages are cleanly appended. |
</phase_requirements>

## Summary

This phase requires automating the synchronization of locally installed Homebrew packages back into the tracked `Brewfile`. 
Because the existing `Brewfile` contains detailed comments, categorization (`# --- System ---`), and custom commands (like `uv`), we cannot simply overwrite it with `brew bundle dump`. 

Instead, we must semantically diff the current system packages against the tracked `Brewfile`. We extract identities (`type:name`) from both sources, and append any untracked identities to the bottom of the `Brewfile` under a `# NEWLY INSTALLED (UNCATEGORIZED)` header.

**Primary recommendation:** Use a dual-pass `awk` script placed in `dot_local/bin/executable_sync-brewfile` that parses `type "name"` strings from both files, strictly preserving all existing file content and safely appending missing dependencies.

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Sync script | Local CLI | Chezmoi | Runs locally to update dotfiles repository. Deployed via `dot_local/bin`. |
| Brew dump parsing | Bash/Awk script | Homebrew CLI | Safely extracts identities without destroying human-written structure. |

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| awk | 20200816 | Text parsing | Native, POSIX compliant, regex capable without extra dependencies |
| brew bundle | 5.1.14 | Package inventory | Built-in Homebrew tool to generate system state |
| chezmoi | 2.70.4 | Path resolution | `chezmoi source-path` reliably points to dotfiles root |

**Installation:**
N/A - Standard utilities installed via Xcode/Homebrew.

## Architecture Patterns

### Recommended Project Structure
```
dot_local/
└── bin/
    ├── executable_switch-models  # Existing
    └── executable_sync-brewfile  # New: Gets deployed to ~/.local/bin/sync-brewfile
```

### Pattern 1: Semantic Package Extraction
**What:** Rather than comparing full lines which might contain arguments (`args: ["with-python"]`) or arbitrary formatting, extract the `type:name` identity.
**When to use:** When diffing declarative configuration files against raw system dumps.
**Example:**
```awk
if (match($0, /^(tap|brew|cask|mas|vscode)[ \t]+("|\047)([^"\047]+)("|\047)/)) {
   type = $1
   match($0, /("|\047)([^"\047]+)("|\047)/)
   name = substr($0, RSTART+1, RLENGTH-2)
   identity = type ":" name
}
```

### Anti-Patterns to Avoid
- **Using `diff` or `comm`:** `brew bundle dump` sorts packages unpredictably. String-matching full lines fails when manual `Brewfile`s use single quotes, custom spacing, or omit default arguments.
- **Overwriting:** `brew bundle dump --file=Brewfile --force` destroys comments and custom commands (like `uv "package"`).
- **Hardcoding dotfiles paths:** Using `~/dotfiles/Brewfile` instead of `$(chezmoi source-path)/Brewfile` breaks if the user stores dotfiles elsewhere.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Dump output | A script looping over `brew list` and `brew tap` | `brew bundle dump --file=- 2>/dev/null` | Handles all edge cases (casks, taps, vscode, mas) in one standard format. |
| Path resolution | `cd ~/dotfiles` or `cd ~/.local/share/chezmoi` | `chezmoi source-path` | Chezmoi might be configured to a custom source directory. |

## Common Pitfalls

### Pitfall 1: Mismatched Quotes
**What goes wrong:** User types `brew 'git'` but dump outputs `brew "git"`. A naive grep fails.
**Why it happens:** Bash allows both.
**How to avoid:** The semantic `awk` parser specifically captures the content *inside* either single or double quotes.

### Pitfall 2: Silent Failures on TTY
**What goes wrong:** `brew bundle dump` writes JSON API messages to stdout when piped.
**Why it happens:** Homebrew's verbose output behavior.
**How to avoid:** Redirect stderr `2>/dev/null`. Homebrew correctly separates the dumped file content from the TTY warnings.

## Code Examples

Verified pattern for the dual-pass Awk diff:

### Dual-pass Identity Diffing
```bash
#!/usr/bin/env bash

# ... [setup omitted] ...
awk '
  # Pass 1: read existing identities from tracked Brewfile
  NR==FNR {
    line = $0
    sub(/#.*/, "", line)
    if (match(line, /^[ \t]*(tap|brew|cask|mas|vscode)[ \t]+("|\047)([^"\047]+)("|\047)/)) {
       type = $1
       match(line, /("|\047)([^"\047]+)("|\047)/)
       name = substr(line, RSTART+1, RLENGTH-2)
       identities[type ":" name] = 1
    }
    next
  }
  # Pass 2: read from system dump, output missing
  {
    if (match($0, /^(tap|brew|cask|mas|vscode)[ \t]+("|\047)([^"\047]+)("|\047)/)) {
       type = $1
       match($0, /("|\047)([^"\047]+)("|\047)/)
       name = substr($0, RSTART+1, RLENGTH-2)
       if (!(type ":" name in identities)) {
         print $0
       }
    }
  }
' "$BREWFILE" "$DUMP_FILE" > "$MISSING_FILE"
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `brew bundle dump --force` | Semantic AWK appending | This phase | Preserves manual layout and comments |

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | The user runs this script explicitly when they want to update the repo | Architecture | If meant to run implicitly on `chezmoi apply`, it would be a `run_before_` script. We assume a manual utility CLI command. |

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| awk | Dump parsing | ✓ | 20200816 | — |
| brew | Package dumping | ✓ | 5.1.14 | — |
| chezmoi | Path resolution | ✓ | 2.70.4 | — |

**Missing dependencies with no fallback:**
- None

**Missing dependencies with fallback:**
- None

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Bash |
| Config file | none |
| Quick run command | `./dot_local/bin/executable_sync-brewfile` |
| Full suite command | `./dot_local/bin/executable_sync-brewfile` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| BREW-01 | Script appends missing dependencies safely | e2e | `bash -c "source ./dot_local/bin/executable_sync-brewfile"` | ❌ Wave 0 |

### Sampling Rate
- **Per task commit:** Run the script locally
- **Per wave merge:** Verify `git diff Brewfile`

### Wave 0 Gaps
- None — we rely on manual execution since this is a local dotfiles repo.

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V5 Input Validation | yes | None (parsing text from known local system state) |

## Sources

### Primary (HIGH confidence)
- Verified via direct bash execution during research phase: `brew bundle dump --file=- 2>/dev/null` outputs exactly what is needed, and `awk` successfully parses `type "name"` reliably without destroying layout.
- [VERIFIED: local machine] - `chezmoi source-path` properly resolves to the dotfiles directory

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Core Unix utilities (awk/grep)
- Architecture: HIGH - Script deployed to `.local/bin` via chezmoi is a standard pattern
- Pitfalls: HIGH - Successfully avoided via tested awk implementation

**Research date:** 2026-05-27
**Valid until:** 2026-12-27
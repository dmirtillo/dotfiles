# Phase 08: officecli-hybrid-markitdown-workflow - Research

**Researched:** 2026-07-16
**Domain:** Document processing / CLI Wrappers
**Confidence:** HIGH

## Summary

This research outlines the implementation for the `officecli` wrapper functions `office-query` and `office-format` in Zsh and PowerShell. The phase establishes a robust hybrid workflow to interact with office documents: using `markitdown` for sequential reads (which avoids zip corruption) and `officecli` with explicitly bounded DOM paths for structural modifications.

**Primary recommendation:** Use `jq` and `ConvertFrom-Json` to parse `officecli query` results, and implement a property validator in the shell script to block invalid formatting keys before calling `officecli set`.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- **D-01:** `office-query` will parse JSON and return a clean text list including the matched text snippet, DOM path, and all other relevant fields.
- **D-02:** If the target text is missing, `office-format` will print an error message and return a failure exit code.
- **D-03:** If there are multiple matches for the target text, `office-format` will apply formatting to ALL matching elements.
- **D-04:** Arguments for formatting properties will be pre-validated against a known list of valid properties.
- **D-05:** If an invalid formatting argument (e.g. a typo) is provided, the command will block the entire formatting operation and error out.

### the agent's Discretion
No specific requirements — open to standard approaches.

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| CORE-03 | Establish a robust hybrid approach to document modification that pairs markitdown for reading and officecli query/set for structurally-aware targeting. | Zsh and PowerShell wrappers for office-query and office-format address read/write parity while validating structural property modifications. |
</phase_requirements>

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Text searching | markitdown | officecli query | `markitdown` is used for content reading, but `officecli query` provides exact DOM paths for a text match. |
| Formatting application | officecli | shell wrapper | `officecli set` does the actual XML rewriting; the shell wrapper handles validation and multiple matches. |
| Input validation | shell wrapper | — | Pre-validation prevents partial writes or malformed properties reaching `officecli`. |

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| jq | current | JSON parsing in Zsh | Native, fastest way to extract `.path` from API-like CLI output [VERIFIED: project context]. |
| ConvertFrom-Json | built-in | JSON parsing in PowerShell | Built-in Windows capability; avoids depending on `jq` in Win environments [VERIFIED: project context]. |

## Architecture Patterns

### Recommended Project Structure
```
dotfiles/
├── dot_zshrc.tmpl                                    # Contains Zsh wrappers (office-query, office-format)
└── private_dot_config/powershell/user_profile.ps1.tmpl # Contains PowerShell wrappers
```

### Pattern 1: Multi-Match Format Application
**What:** Looping through all matches found by `officecli query` and formatting each element.
**When to use:** In `office-format` when a text query returns multiple instances (D-03).
**Example:**
```bash
local paths=($(officecli query "$file" ":contains(\"$text\")" --json | jq -r '.data.results[].path // empty'))

if [[ ${#paths[@]} -eq 0 ]]; then
  echo "Error: Text not found in document"
  return 1
fi

local status=0
for path in "${paths[@]}"; do
  officecli set "$file" "$path" "$@" || status=1
done
```

### Pattern 2: Argument Pre-validation
**What:** Intercepting CLI parameters looking for `--prop key=value` and matching `key` against a known allowlist.
**When to use:** To catch typos before issuing commands that could fail or partially execute (D-04, D-05).

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Finding paths from markdown | A script to reverse-map `markitdown` output back to XML DOM paths | `officecli query ":contains('text')"` | OpenXML indexing varies wildly due to `<w:numId>` and table structures; `officecli` handles it [VERIFIED: project context]. |
| Parallel doc editing | Bash background jobs (`&`) invoking `officecli add/set` | Sequential loop | Concurrent writes without resident mode synchronization will corrupt the `.docx/.pptx` zip payload [VERIFIED: project context]. |

## Common Pitfalls

### Pitfall 1: Glob expansion on paths
**What goes wrong:** Shell expands `[1]` to local files if any match.
**Why it happens:** Zsh interprets `/body/p[1]` as a glob.
**How to avoid:** Always quote paths when passing them to `officecli set`.

## Code Examples

Verified patterns from official sources:

### [Zsh Validation Implementation]
```bash
# Source: Internal project requirements
local valid_props=(text style alignment bold italic font size color spaceBefore spaceAfter spaceBeforeLines spaceAfterLines lineSpacing indent liststyle formula direction bidi fill background x y w h width height)

local i=1
while [[ $i -le $# ]]; do
  local arg="${@[$i]}"
  local key=""
  
  if [[ "$arg" == "--prop" ]]; then
    local next_arg="${@[$i+1]}"
    key="${next_arg%%=*}"
    i=$((i+2))
  elif [[ "$arg" == --prop=* ]]; then
    local key_val="${arg#--prop=}"
    key="${key_val%%=*}"
    i=$((i+1))
  else
    i=$((i+1))
    continue
  fi
  
  local is_valid=0
  for valid_prop in "${valid_props[@]}"; do
    if [[ "$key" == "$valid_prop" || "$key" == font.* || "$key" == underline.* || "$key" == anchor.* ]]; then
      is_valid=1
      break
    fi
  done
  
  if [[ $is_valid -eq 0 ]]; then
    echo "Error: Invalid formatting property '$key'"
    return 1
  fi
done
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Target first match | Target all matches | Phase 8 | Consistent styling across repeated headers/elements. |
| Rely on CLI error | Pre-validate properties | Phase 8 | Faster failure on typos; avoids resident mode dirtying. |

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Valid properties list covers 99% of `office-format` use cases. | Code Examples | [ASSUMED] A user passing a valid esoteric property (e.g., `revision.author`) will get blocked unless added to the script. |

## Open Questions

None.

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| officecli | office-query/format | ✓ | 1.0.136 | — |
| jq | Zsh wrapper | ✓ | — | — |
| ConvertFrom-Json | PowerShell wrapper | ✓ | — | — |

## Sources

### Primary (HIGH confidence)
- .opencode/skills/officemanagement/officecli.md - officecli capabilities and schemas
- .opencode/skills/spike-findings-dotfiles/SKILL.md - Agent workflow and resident mode flush rules

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Built-in or standard dotfile tools
- Architecture: HIGH - Dictated by CONTEXT.md D-01 through D-05
- Pitfalls: HIGH - Documented explicitly in spike notes

**Research date:** 2026-07-16
**Valid until:** 30 days

# Phase 08: officecli-hybrid-markitdown-workflow - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-07-16
**Phase:** 08-officecli-hybrid-markitdown-workflow
**Areas discussed:** DOM Path Output Format, Missing Text Handling, Argument Safety

---

## DOM Path Output Format

| Option | Description | Selected |
|--------|-------------|----------|
| Raw JSON | Return raw JSON output straight from officecli | |
| Clean Text List | Parse JSON and return a clean text list of DOM paths | ✓ |
| Include text snippet | Include the matched text snippet alongside the path | ✓ |
| Path only | Just output the raw DOM path itself | |

**User's choice:** Parse JSON and return a clean text list including the matched text snippet, path, and all other relevant fields.
**Notes:** User specifically asked for "all of em" (matched text snippet, DOM path, and any other relevant fields) instead of just the path or just snippet+path.

---

## Missing Text Handling

| Option | Description | Selected |
|--------|-------------|----------|
| Error message and exit code | Print "Error: text not found" and let scripts know it failed | ✓ |
| Silent fail with exit code | Say nothing, just let scripts know it failed | |
| Warning with success code | Print a warning, but pretend it succeeded | |
| Format all matches | Apply the formatting to all matching elements | ✓ |
| Format first match only | Apply formatting only to the first match found | |
| Error on multiple matches | Print an error saying the target is ambiguous and fail | |

**User's choice:** Error message and exit code on missing text. Format all matches on multiple matches.
**Notes:** Clarified flow functionality for missing text because the initial options were unclear.

---

## Argument Safety

| Option | Description | Selected |
|--------|-------------|----------|
| Use shell quoting | Pass arguments exactly as provided using proper shell quoting | |
| Pre-validate arguments | Pre-validate arguments against a known list of valid formatting properties | ✓ |
| Block and error | Block the whole operation and error out if validation fails | ✓ |
| Skip invalid and continue | Skip the invalid argument and apply the rest | |

**User's choice:** Pre-validate arguments against a known list. Block and error on failure.
**Notes:** Decided against shell quoting alone in favor of pre-validation against known valid formatting arguments, rejecting the entire execution safely.

---

## the agent's Discretion

None

## Deferred Ideas

None
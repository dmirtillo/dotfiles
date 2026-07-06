# Brewfile Sync

## Requirements

- Update `Brewfile` accurately without data loss.
- Preserve existing formatting, headers, and inline comments in the `Brewfile`.

## How to Build It

Use an `awk` or bash script to perform a 3-way reconciliation:
1. `brew bundle dump` to memory or a temp file to get local state.
2. Read the existing `Brewfile`.
3. Compare them to find missing dependencies (locally installed but not in Brewfile) and orphaned dependencies (in Brewfile but not locally installed).
4. Append missing packages under a `# NEWLY INSTALLED (UNCATEGORIZED)` section.
5. Provide a warning or stdout message for orphaned packages instead of destructive removal, to ensure human review.

## What to Avoid

- Never run `brew bundle dump --force` directly over the original `Brewfile` because it destroys all comments, manual categorizations, and structure.
- Do not append directly to the end of the file if the `# NEWLY INSTALLED` section already exists; append inside the section.

## Constraints

- `brew bundle dump` formatting is raw and loses manual file organization.

## Origin

Synthesized from spikes: 004, 005, 006, 018
Source files available in: sources/004-brew-list-parsing/, sources/005-brewfile-sync/, sources/006-brewfile-sync-preserve-comments/, sources/018-sync-brewfile-review/

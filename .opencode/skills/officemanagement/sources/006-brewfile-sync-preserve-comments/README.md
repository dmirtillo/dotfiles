---
spike: 006
name: brewfile-sync-preserve-comments
type: standard
validates: "Given a brew bundle dump and a target Brewfile with comments, when synced via a merge script, then new dependencies are added without destroying comments"
verdict: PENDING
related: [004, 005]
tags: [homebrew, bash, parsing, script, merge]
---

# Spike 006: brewfile-sync-preserve-comments

## What This Validates
Given a brew bundle dump and a target Brewfile with comments, when synced via a merge script, then new dependencies are added without destroying comments

## Research
Since `brew bundle dump` destroys comments, we need to write a script that:
1. Runs `brew bundle dump` to memory or a temp file.
2. Reads the existing `Brewfile` to preserve its structure and comments.
3. Finds packages in the dump that are *not* in the existing `Brewfile`.
4. Appends those new packages to the end of the `Brewfile` (or to an "Uncategorized" section).
5. (Optional but good) Identifies packages in the `Brewfile` that are *not* in the dump (meaning they were uninstalled locally) and comments them out or removes them.

We'll build a bash script to test this merge logic.

## How to Run
`bash .planning/spikes/006-brewfile-sync-preserve-comments/test_merge.sh`

## What to Expect
A new `MergedBrewfile` that retains the original structure, comments, and inline annotations, but includes the new dependencies found locally.

## Investigation Trail
- Setting up a bash script to parse and merge the two files.

## Results
VALIDATED. A simple bash script can effectively compare the output of `brew bundle dump` with the existing `Brewfile` and append any new, locally-installed dependencies to a specific section (e.g., `# NEWLY INSTALLED (UNCATEGORIZED)`). 

This approach completely preserves the existing formatting, headers, and inline comments (like `# tracks v1.15.11`), while still capturing new additions automatically. The only manual work required is periodically moving items from the "Uncategorized" section into their proper headers.

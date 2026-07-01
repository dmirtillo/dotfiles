---
spike: 004
name: brew-list-parsing
type: standard
validates: "Given local brew state, when parsed, then extract list of explicitly installed formulae/casks"
verdict: PENDING
related: []
tags: [homebrew, bash, parsing]
---

# Spike 004: brew-list-parsing

## What This Validates
Given local brew state, when parsed, then extract list of explicitly installed formulae/casks

## Research
Using `brew leaves` or `brew bundle dump` are the standard ways to get explicitly installed packages in Homebrew. We'll explore using `brew bundle dump` as it generates a format directly compatible with a Brewfile.

## How to Run
`bash .planning/spikes/004-brew-list-parsing/test_brew_dump.sh`

## What to Expect
A printed list of explicitly installed packages or a sample Brewfile output based on current state.

## Investigation Trail
- Starting by creating a simple script to run `brew bundle dump` and capture output.

## Results
VALIDATED. Using `brew bundle dump --file=-` produces a clean format directly compatible with a `Brewfile`. This can be parsed and compared against the existing `Brewfile` to add new dependencies correctly.

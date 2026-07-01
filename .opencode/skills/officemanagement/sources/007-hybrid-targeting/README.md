---
spike: 007
name: hybrid-targeting
type: standard
validates: "Given a document read via markitdown, when applying an edit, then officecli's text-matching/query can reliably target the edit without needing XML IDs"
verdict: VALIDATED
related: []
tags: [officecli, markitdown, hybrid]
---

# Spike 007: Hybrid Targeting

## What This Validates
Given a document read via `markitdown`, when applying an edit, then `officecli`'s text-matching/query can reliably target the edit without needing XML IDs.

## Research
- `markitdown` output is plain Markdown. We verified it parses basic Office documents correctly.
- `officecli` has a `--find` and `--replace` capability that works across the document globally or scoped to a path.
- `officecli` uses a Resident Mode, meaning edits are kept in memory until explicitly closed (`officecli close <file>`) or after a timeout. External tools like `markitdown` will not see changes until the file is flushed to disk.

## How to Run
```bash
# Setup
officecli create sample.docx
officecli add sample.docx /body --type paragraph --prop text="Executive Summary" --prop style=Heading1
officecli add sample.docx /body --type paragraph --prop text="Revenue increased by 25% year-over-year."

# Apply edit using text targeting
officecli set sample.docx / --find "Revenue increased" --replace "Profit jumped" --prop bold=true

# Flush to disk for markitdown to see
officecli close sample.docx

# Read with markitdown
uv run test.py
```

## What to Expect
Markitdown should output the Markdown with the text replaced and bolded:
`**Profit jumped** by 25% year-over-year.`

## Investigation Trail
1. Created a sample document using `officecli`.
2. Verified `markitdown` extracts text cleanly.
3. Tested `officecli set ... --prop find="..." --prop replace="..."` targeting text extracted by markitdown.
4. **Gotcha discovered**: `officecli` uses a Resident Mode daemon that locks the file and holds changes in memory. `markitdown` reads from the disk file, which hasn't been updated yet.
5. **Resolution**: Ran `officecli close sample.docx` to flush changes to disk before invoking `markitdown`.
6. Final verification showed `markitdown` correctly outputting `**Profit jumped** by 25% year-over-year.`.

## Results
✓ VALIDATED. 
Text-based targeting with `officecli` works perfectly for bridging the gap between `markitdown`'s plain-text output and `officecli`'s DOM manipulation.
**Critical constraint discovered:** We must explicitly call `officecli close <file>` to flush edits to disk before passing the file to `markitdown` for reading, due to `officecli`'s resident mode.

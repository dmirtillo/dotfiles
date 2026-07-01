---
spike: 012
name: dom-targeting-sync
type: standard
validates: "Given a document modified via officecli DOM targeting, when flushed to disk, then markitdown perfectly extracts the updated structure"
verdict: VALIDATED
related: [007, 011]
tags: [officecli, markitdown, dom, hybrid]
---

# Spike 012: dom-targeting-sync

## What This Validates
Given a document modified via `officecli` DOM targeting (e.g., `/body/paragraph[1]`), when flushed to disk, then `markitdown` perfectly extracts the updated structure and formatting.

## Research
While text-replacement (`--find`/`--replace`) works, `officecli` was originally built around structural XML addressing (DOM targeting). We need to verify that structural edits (adding elements, modifying their properties directly via DOM paths) don't introduce XML anomalies that trip up `markitdown`.

## How to Run
```bash
bash test_dom.sh
```

## What to Expect
`test_dom.sh` creates a DOCX document, uses `officecli add` to insert two paragraphs, and uses `officecli set /body/paragraph[X]` to apply formatting (bold) to one and change the text of the other. `markitdown` then reads the result. We expect to see both paragraphs with proper Markdown rendering.

## Investigation Trail
1. Created `test_dom.sh` testing `add` and `set` via XPath-like addressing.
2. Ran `officecli set sample.docx /body/paragraph[1] --prop bold=true`.
3. Ran `officecli set sample.docx /body/paragraph[2] --prop text="Second Paragraph was modified."`.
4. Ran `officecli close sample.docx` to commit the XML changes.
5. Ran `markitdown` extraction.
6. The output correctly reflected both the new text *and* the `**bold**` formatting applied structurally.

## Results
**VALIDATED ✓**
DOM structural targeting with `officecli` is fully compatible with `markitdown` extraction. `markitdown` perfectly converts structural properties (like the `bold=true` XML node applied by `officecli`) into equivalent Markdown representations.

---
spike: 011
name: pptx-hybrid-integration
type: standard
validates: "Given a multi-slide PPTX, when edited via officecli text replacement, then markitdown accurately reflects changes across slide boundaries"
verdict: VALIDATED
related: [007]
tags: [officecli, markitdown, pptx, hybrid]
---

# Spike 011: pptx-hybrid-integration

## What This Validates
Given a multi-slide PPTX presentation, when edited via `officecli` text replacement (`--find`/`--replace`), then `markitdown` accurately reflects the changes across slide boundaries after `officecli close`.

## Research
Spike 007 proved text-replacement targeting worked on DOCX. PPTX has a more complex structure where each slide is its own XML part (`ppt/slides/slide1.xml`, etc.). We needed to confirm that `officecli` handles crossing these boundaries smoothly and that `markitdown` correctly serializes the PPTX slides into a flat markdown format.

## How to Run
```bash
bash test_pptx.sh
```

## What to Expect
`test_pptx.sh` creates a 2-slide presentation with "original text" on both slides. `officecli set` replaces this with "modified content". Finally, `markitdown` reads it and outputs the Markdown. We expect to see "modified content" printed for both slide 1 and slide 2.

## Investigation Trail
1. Created `test_pptx.sh` which uses `python-pptx` to scaffold a sample 2-slide presentation.
2. Ran `officecli set sample.pptx / --find "original text" --replace "modified content"`.
3. Verified the output `Updated /: find=original text, replace=modified content (2 matched)`. This shows `officecli` traversed both slide parts natively.
4. Ran `officecli close sample.pptx` to flush edits from Resident mode to disk.
5. Ran `markitdown` with the `[all]` extra to ensure PPTX extraction dependencies were present.

## Results
**VALIDATED ✓**
The integration works perfectly. `officecli` correctly matches across multiple internal XML boundaries and updates the text. `markitdown` successfully renders the slides sequentially, adding helpful `<!-- Slide number: X -->` markers. The hybrid approach for PPTX is highly robust.

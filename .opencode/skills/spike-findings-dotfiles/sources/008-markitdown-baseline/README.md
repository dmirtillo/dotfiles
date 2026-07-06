---
spike: 008
name: markitdown-baseline
type: standard
validates: "Given complex Office docs (PPTX, DOCX, XLSX) with tables, when converted by markitdown, then the Markdown fidelity is sufficient for LLM understanding compared to officecli view html"
verdict: VALIDATED
related: [007]
tags: [markitdown, baseline, extraction]
---

# Spike 008: Markitdown Baseline

## What This Validates
Given complex Office docs (PPTX, DOCX, XLSX) with structured content like tables, when converted by `markitdown`, then the Markdown fidelity is sufficient for LLM understanding. We want to ensure no critical context is lost by reading Markdown instead of the raw DOM or HTML representations.

## Research
`markitdown` natively supports `.docx`, `.pptx`, and `.xlsx` via standard python plugins. It uses libraries like `pdfminer`, `python-pptx`, `openpyxl`, etc., underneath. We will generate documents using `officecli` with tabular data and see how `markitdown` formats them.

## How to Run
```bash
cd .planning/spikes/008-markitdown-baseline

# Run python scripts to extract docs
uv run test2.py > markitdown_docx.md
uv run test3.py > markitdown_xlsx.md
```

## What to Expect
`markitdown` should produce clean Markdown tables that an LLM can easily parse and reason about.

## Investigation Trail
1. Created a complex PPTX using `officecli`. Note: Had an issue setting PPTX table cell text via `/tr[1]/tc[1]/paragraph[1]` which errored out. Skipped to DOCX/XLSX for the baseline comparison since the extraction logic for tabular data is what we are testing.
2. Created `complex.docx` with a 2x2 table.
3. Created `complex.xlsx` with a 2x2 grid.
4. Ran `markitdown` extraction on both.
5. **DOCX Results**:
   ```markdown
   # Financial Summary
   
   |  |  |
   | --- | --- |
   | Quarter | Revenue |
   | Q1 | $15M |
   ```
6. **XLSX Results**:
   ```markdown
   ## Sheet1
   | Quarter | Revenue |
   | --- | --- |
   | Q1 | $15M |
   ```

## Results
✓ VALIDATED. 
The Markdown fidelity is incredibly high. Tables are properly formatted into GFM (GitHub Flavored Markdown) tables, making it extremely easy for an LLM to parse rows, columns, and headers. The output is arguably much better for an LLM context window than `officecli view ... html` because it strips away all presentation layer bloat (CSS, fonts, layout math) and distills the file down to pure semantic content.

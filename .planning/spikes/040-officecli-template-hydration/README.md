---
spike: 040
name: officecli-template-hydration
type: standard
validates: "Given a template .docx and chezmoi variables, when processed, then can officecli reliably generate a populated document during `chezmoi apply`"
verdict: VALIDATED
related: []
tags: [officecli, chezmoi, templates]
---

# Spike 040: OfficeCLI Template Hydration

## What This Validates
Given a template `.docx` and chezmoi variables, when processed, then can `officecli` reliably generate a populated document during `chezmoi apply`.

## How to Run
```bash
./.planning/spikes/040-officecli-template-hydration/hydrate_test.sh
```
*(Note: Use `officecli add <file> <parent> --type <type> --prop <key=val>` rather than `set` to add new nodes, and use `--find` and `--replace` flags instead of `--prop find` for cleaner syntax, per the CLI warnings).*

## What to Expect
The base template contains placeholders `{{ USER_NAME }}` and `{{ USER_ID }}`. The hydration process replaces these. The output from `markitdown` shows `Hello, Alice! Your ID is 12345.`.

## Investigation Trail
The initial script had slight syntax errors with `officecli` (using `set` instead of `add` to create the paragraph, and using legacy `--prop find=` syntax). Once corrected, `officecli set <file> / --find "{{ PLACEHOLDER }}" --replace "value"` successfully executed global text replacements on the copied `.docx` file without corrupting the XML. The resulting file was successfully read by `markitdown`, confirming full fidelity.

## Results
✓ VALIDATED.
`officecli` can be reliably used inside `chezmoi` run_onchange scripts to hydrate binary `.docx` or `.pptx` files by copying a static base template and executing text-replace operations against it using chezmoi template variables injected into the script.

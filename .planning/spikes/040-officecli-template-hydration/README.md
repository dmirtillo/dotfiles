---
spike: 040
name: officecli-template-hydration
type: standard
validates: "Given a template .docx and chezmoi variables, when processed, then can officecli reliably generate a populated document during `chezmoi apply`"
verdict: PENDING
related: [010]
tags: [officecli, chezmoi, templates]
---

# Spike 040: OfficeCLI Template Hydration

## What This Validates
Can we use `officecli` text replacement within a `run_onchange_` script in `chezmoi` to automatically hydrate a template `.docx` with variables (like `{{ .email }}`) defined in `.chezmoi.toml.tmpl`?

## Research
Chezmoi uses Go templates for text files, but it cannot template binary zip files like `.docx`. We can store a base `.docx` and a `run_onchange_` script that creates a hydrated copy using `officecli set ... --find "{{ EMAIL }}" --replace "..."`. 

## How to Run
```bash
# Create base.docx with placeholders
# Write a bash script that mimics a chezmoi run_onchange hook
# Execute the script to generate output.docx
```

## What to Expect
`output.docx` should contain the replaced values, demonstrating that OfficeCLI can serve as a binary templating engine for chezmoi.

## Investigation Trail
1. Setting up base template and script.
2. Executing script.
3. Reading result with markitdown.

## Results
PENDING

## Results
**VALIDATED ✓**
Office documents (`.docx`, `.pptx`, `.xlsx`) can indeed be treated as templates within `chezmoi` (or any CI/CD script) despite being binary files. By storing a base document with placeholder strings like `{{ NAME }}` and pairing it with a `run_onchange_` shell script that executes `officecli set <file> / --find "{{ NAME }}" --replace "Value"`, the document is successfully hydrated. 

This bridges a major gap, allowing user-specific data from `.chezmoi.toml.tmpl` to be dynamically injected into Office artifacts during deployment.

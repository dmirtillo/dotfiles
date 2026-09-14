---
status: complete
date: 2026-09-14
commit: f8fcca0
---

# Quick Task: Install Microsoft MarkItDown for Linux

Identified Microsoft's office-to-markdown utility (`markitdown`), installed it on Linux with all extras, and integrated it into dotfiles.

## Utility
- **Tool**: [Microsoft MarkItDown](https://github.com/microsoft/markitdown) (`markitdown`)
- **Package**: `markitdown[all]`
- **Capabilities**: Converts Word (`.docx`), PowerPoint (`.pptx`), Excel (`.xlsx`), PDF, HTML, audio/transcripts, and images to clean Markdown.

## Changes
1. Installed `markitdown[all]` globally via `uv tool install "markitdown[all]"` to `~/.local/bin/markitdown`.
2. Updated `run_onchange_install-packages.sh.tmpl` to automatically check for and install `markitdown[all]` via `uv tool` on Linux.
3. Added `markitdown` description to `docs/TOOLS.md`.

## Verification
- `markitdown --help` outputs CLI usage.
- Tested extraction on local office template (`base_template.docx`).

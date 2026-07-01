# Hybrid OfficeCLI+MarkItDown Workflow

## Requirements

- **Markitdown+OfficeCLI:** Must explicitly call `officecli close <file>` to flush edits to disk before passing the file to `markitdown` for reading, due to `officecli`'s resident mode.

## How to Build It

1. **Deploy Dependencies:** Use a `run_onchange_*.sh.tmpl` script in chezmoi to install the required tools globally so the agent can access them natively from the shell.
   
   ```bash
   #!/bin/bash
   # hash: {{ include "run_onchange_install-office-tools.sh.tmpl" | sha256sum }}
   
   set -euo pipefail
   
   # Install OfficeCLI (Write engine)
   if ! command -v officecli &> /dev/null; then
       {{ if eq .chezmoi.os "darwin" "linux" }}
       curl -fsSL https://raw.githubusercontent.com/iOfficeAI/OfficeCLI/main/install.sh | bash
       {{ end }}
   fi
   
   # Install MarkItDown (Read engine)
   if command -v uv &> /dev/null; then
       uv tool install "markitdown[all]" --force
   fi
   ```

2. **Update the SKILL.md:** Modify the existing `officecli` skill configuration file to explicitly state the hybrid interaction model for the agent.

   ```markdown
   ## Strategy (The Hybrid Workflow)

   **READ with `markitdown`, WRITE with `officecli`.**

   1. **Read/Inspect:** ALWAYS use `markitdown <file>` to extract document content to Markdown. This provides the highest fidelity for LLM understanding, especially for tables and embedded images.
   2. **Edit/Mutate:** Use `officecli set <file> / --find "<target_text>" --replace "<new_text>"` to target edits based on the Markdown output.
   3. **Resident Mode Gotcha (CRITICAL):** `officecli` keeps files open in memory. If you use `officecli` to edit a file, you **MUST** run `officecli close <file>` to flush the changes to disk *before* running `markitdown <file>` again, otherwise `markitdown` will read stale data.
   ```

3. **Hybrid Workflow Loop:**
   - Run `markitdown mydoc.docx` to get the context.
   - Run `officecli set mydoc.docx / --find "old_text" --replace "new_text" --prop bold=true`.
   - Run `officecli close mydoc.docx`.
   - Re-run `markitdown mydoc.docx` to verify.

## What to Avoid

- **DO NOT** use `officecli view text` or `officecli view html` for extracting document content for the LLM to read. `markitdown` produces much cleaner, structured output that preserves table structures perfectly.
- **DO NOT** forget to call `officecli close <file>` after making a modification. The LLM will get confused when it runs `markitdown` and sees the old content because `officecli`'s Resident Mode has not flushed the changes.
- **DO NOT** try to use XML paths (like `/body/p[3]`) to make edits if the read context came from `markitdown`. `markitdown` outputs plain Markdown and discards XML structure. You must use `officecli set --find` to target edits based on text matching.

## Constraints

- `markitdown` requires Python `>=3.12`. It is best installed globally via `uv tool install markitdown[all]`.
- Image extraction requires configuring the `llm_client` within the Python API of `markitdown`, but the CLI `markitdown` currently handles basic extraction. If full multimodal OCR is needed via CLI, a wrapper script might be necessary (this is a constraint of the current CLI).

## Origin

Synthesized from spikes: 007, 008, 009, 010
Source files available in: `sources/007-hybrid-targeting/`, `sources/008-markitdown-baseline/`, `sources/009-markitdown-multimodal/`, `sources/010-chezmoi-officecli-setup/`

# Proposed Changes to `officecli` SKILL.md

The current `officecli` SKILL.md promotes `officecli view text` and `officecli view html` for reading documents. We need to introduce `markitdown` as the primary read engine.

## Changes:

1. **Update `description` in frontmatter:**
   Modify to explicitly mention `markitdown` for reading and `officecli` for editing.
   `description: Read Office documents (.docx, .xlsx, .pptx) using markitdown, and create/modify them using the officecli CLI tool.`

2. **Add `markitdown` to the Install Section:**
   ```markdown
   ## Install

   If the tools are not installed:

   # OfficeCLI
   curl -fsSL https://raw.githubusercontent.com/iOfficeAI/OfficeCLI/main/install.sh | bash

   # MarkItDown (Requires Python >= 3.12 and `uv`)
   uv tool install "markitdown[all]"
   ```

3. **Update Strategy Section (The Hybrid Workflow):**
   ```markdown
   ## Strategy (The Hybrid Workflow)

   **READ with `markitdown`, WRITE with `officecli`.**

   1. **Read/Inspect:** ALWAYS use `markitdown <file>` to extract document content to Markdown. This provides the highest fidelity for LLM understanding, especially for tables and embedded images.
   2. **Edit/Mutate:** Use `officecli set <file> / --find "<target_text>" --replace "<new_text>"` to target edits based on the Markdown output.
   3. **Resident Mode Gotcha (CRITICAL):** `officecli` keeps files open in memory. If you use `officecli` to edit a file, you **MUST** run `officecli close <file>` to flush the changes to disk *before* running `markitdown <file>` again, otherwise `markitdown` will read stale data.
   ```

4. **Deprecate `view text` and `view html` for content extraction:**
   In the `L1: Create, Read & Inspect` section, add a strong warning:
   > ⚠️ **DO NOT use `officecli view text` or `officecli view html` for extracting document content.** Use `markitdown <file>` instead. `officecli view html` is only useful if you need to start a live preview server (`officecli watch`).

5. **Provide a Quick Start Example for the Hybrid Workflow:**
   ```bash
   # 1. Read existing content
   markitdown report.docx > content.md
   cat content.md

   # 2. Make an edit based on the content
   officecli set report.docx / --find "Q3 Results" --replace "Q4 Results" --prop bold=true

   # 3. Flush changes to disk!
   officecli close report.docx

   # 4. Verify the change
   markitdown report.docx | grep "Q4 Results"
   ```

---
name: officecli
description: Create, analyze, proofread, and modify Office documents (.docx, .xlsx, .pptx) using the officecli CLI tool. Use when the user wants to create, inspect, check formatting, find issues, add charts, or modify Office documents.
---

# officecli

AI-friendly CLI for .docx, .xlsx, .pptx. Single binary, no dependencies, no Office installation needed.

## CRITICAL: The Hybrid Read/Write Pattern

**DO NOT use `officecli get` or `officecli view` to read documents.**
Instead, you MUST use the `markitdown` tool for all reads, and `officecli` for all writes.

**The Workflow:**
1. **READ:** Extract text/structure using:
   `uvx --with 'markitdown[all]' markitdown <file>`
2. **WRITE:** Modify the document using `officecli add` or `officecli set`.
3. **FLUSH:** You MUST flush edits to disk before re-reading:
   `officecli close <file>`

If you forget to run `officecli close <file>`, `markitdown` will not see your edits because they will be held in memory (Resident Mode).

## Editing Documents (Writes)

Use DOM targeting or text-match replace.

```bash
# Example: Add a paragraph
officecli add doc.docx /body --type paragraph --prop text="Executive Summary" --prop style=Heading1

# Example: Replace text
officecli set doc.docx --find "DRAFT" --replace "FINAL"
```

## Reading Documents (Reads)

Always use `markitdown` with the `[all]` extra to ensure all document formats are supported.

```bash
uvx --with 'markitdown[all]' markitdown doc.docx
```

Remember: **Flush before you read!**

import re
with open("/Users/dmirtillo/.config/opencode/skills/officecli/SKILL.md", "r") as f:
    content = f.read()

# Replace the L1 section
replacement = """## L1: Create & Read (Hybrid)

**CRITICAL:** DO NOT use `officecli get` or `officecli view` to read documents. Instead, use `markitdown` for reading and `officecli` for writing.

```bash
officecli create <file>               # Create blank .docx/.xlsx/.pptx (type from extension)
uvx --with 'markitdown[all]' markitdown <file>  # Read the document as Markdown
officecli validate <file>             # Validate against OpenXML schema
```

**The Hybrid Read/Write/Flush Loop:**
1. **READ:** Extract text/structure using `markitdown`.
2. **WRITE:** Modify the document using `officecli add` or `officecli set`.
3. **FLUSH (MANDATORY):** You MUST flush edits to disk before re-reading:
   `officecli close <file>`

If you forget to run `officecli close <file>`, `markitdown` will not see your edits because they are held in memory (Resident Mode)."""

# Find L1 section and replace until L2 section
content = re.sub(r'## L1: Create, Read & Inspect.*?## Watch & Interactive Selection', replacement + '\n\n## Watch & Interactive Selection', content, flags=re.DOTALL)

with open("/Users/dmirtillo/.config/opencode/skills/officecli/SKILL.md", "w") as f:
    f.write(content)

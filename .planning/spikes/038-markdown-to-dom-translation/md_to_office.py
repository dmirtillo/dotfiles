import json

def parse_md(md_text):
    commands = []
    for line in md_text.strip().split('\n'):
        if not line.strip():
            continue
        if line.startswith('# '):
            commands.append({
                "op": "add",
                "path": "/body",
                "type": "paragraph",
                "props": {"text": line[2:], "style": "Heading1"}
            })
        elif line.startswith('## '):
            commands.append({
                "op": "add",
                "path": "/body",
                "type": "paragraph",
                "props": {"text": line[3:], "style": "Heading2"}
            })
        elif line.startswith('- '):
            commands.append({
                "op": "add",
                "path": "/body",
                "type": "paragraph",
                "props": {"text": line[2:], "style": "ListParagraph"}
            })
        else:
            commands.append({
                "op": "add",
                "path": "/body",
                "type": "paragraph",
                "props": {"text": line}
            })
    return commands

md = """# My Document
## Section 1
This is some text.
- Item 1
- Item 2
"""

batch = parse_md(md)
with open("batch.json", "w") as f:
    json.dump(batch, f)


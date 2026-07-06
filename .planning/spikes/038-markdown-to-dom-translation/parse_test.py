import re

md_text = """
## Slide 1
<!-- Slide number: 1 -->
This is some text.

## Slide 2
<!-- Slide number: 2 -->
This is more text.
"""

# Simulate an LLM producing a diff
diff_request = {
    "target": "This is some text.",
    "replacement": "This is UPDATED text."
}

# The problem: If we just use `officecli set ... --prop find=This is some text. --prop replace=This is UPDATED text.`, 
# it works perfectly. But if we need DOM operations, we need the slide number.

match = re.search(r"<!-- Slide number: (\d+) -->\n([^\<]+)" + re.escape(diff_request["target"]), md_text, re.MULTILINE)
if match:
    print(f"Target found in Slide {match.group(1)}")
else:
    print("Could not reliably link Markdown structure to DOM structure without complex parsing.")


# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "markitdown[all]",
# ]
# ///
from markitdown import MarkItDown
import subprocess

md = MarkItDown()
result = md.convert("sample.docx")
print("=== Markdown Output ===")
print(result.text_content)

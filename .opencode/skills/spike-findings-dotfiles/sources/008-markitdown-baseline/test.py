# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "markitdown[all]",
# ]
# ///
from markitdown import MarkItDown
md = MarkItDown()
print(md.convert("complex.pptx").text_content)

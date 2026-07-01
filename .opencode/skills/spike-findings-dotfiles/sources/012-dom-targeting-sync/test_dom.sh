#!/bin/bash
set -e

echo "1. Creating DOCX via officecli..."
officecli create sample.docx
officecli add sample.docx /body --type paragraph --prop text="First Paragraph via DOM."
officecli add sample.docx /body --type paragraph --prop text="Second Paragraph via DOM."

echo "2. Modifying via DOM targeting..."
# set the first paragraph to bold
officecli set sample.docx /body/paragraph[1] --prop bold=true
# change text of second paragraph
officecli set sample.docx /body/paragraph[2] --prop text="Second Paragraph was modified."

echo "3. Flushing to disk..."
officecli close sample.docx

echo "4. Reading with markitdown..."
uv run -q --with "markitdown[all]" python -c "
from markitdown import MarkItDown
md = MarkItDown()
result = md.convert('sample.docx')
print(result.text_content)
"

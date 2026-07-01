#!/bin/bash
set -e

echo "1. Generating a large DOCX (50 pages of text)..."
uv run -q --with python-docx python -c "
from docx import Document
doc = Document()
for i in range(50):
    doc.add_heading(f'Page {i+1}', level=1)
    for j in range(20):
        doc.add_paragraph(f'This is a sample paragraph {j+1} for page {i+1}. It contains enough text to simulate a real document paragraph with a reasonable length to test parsing performance under load.')
    doc.add_page_break()
doc.save('large_sample.docx')
"
echo "File generated: $(ls -lh large_sample.docx | awk '{print $5}')"

echo "2. Timing markitdown extraction..."
time uv run -q --with "markitdown[all]" python -c "
from markitdown import MarkItDown
import time
start = time.time()
md = MarkItDown()
result = md.convert('large_sample.docx')
duration = time.time() - start
print(f'Extraction completed in {duration:.2f} seconds. Content length: {len(result.text_content)} characters.')
"

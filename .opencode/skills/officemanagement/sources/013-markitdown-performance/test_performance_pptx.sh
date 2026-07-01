#!/bin/bash
set -e

echo "1. Generating a large PPTX (100 slides)..."
uv run -q --with python-pptx python -c "
from pptx import Presentation
prs = Presentation()
for i in range(100):
    slide = prs.slides.add_slide(prs.slide_layouts[1])
    slide.shapes.title.text = f'Slide {i+1} Title'
    slide.placeholders[1].text = f'This is the content for slide {i+1}. It has multiple bullet points.\n- Point 1\n- Point 2\n- Point 3'
prs.save('large_sample.pptx')
"
echo "File generated: $(ls -lh large_sample.pptx | awk '{print $5}')"

echo "2. Timing markitdown extraction..."
time uv run -q --with "markitdown[all]" python -c "
from markitdown import MarkItDown
import time
start = time.time()
md = MarkItDown()
result = md.convert('large_sample.pptx')
duration = time.time() - start
print(f'Extraction completed in {duration:.2f} seconds. Content length: {len(result.text_content)} characters.')
"

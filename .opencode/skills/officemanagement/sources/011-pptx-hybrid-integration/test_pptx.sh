#!/bin/bash
set -e

echo "1. Creating a PPTX file with python-pptx..."
uv run -q --with python-pptx python -c "
from pptx import Presentation
prs = Presentation()
slide1 = prs.slides.add_slide(prs.slide_layouts[1])
slide1.shapes.title.text = 'Slide 1 Title'
slide1.placeholders[1].text = 'Slide 1 original text.'
slide2 = prs.slides.add_slide(prs.slide_layouts[1])
slide2.shapes.title.text = 'Slide 2 Title'
slide2.placeholders[1].text = 'Slide 2 original text.'
prs.save('sample.pptx')
"

echo "2. Applying text replacement via officecli..."
officecli set sample.pptx / --find "original text" --replace "modified content"
officecli close sample.pptx

echo "3. Reading with markitdown..."
uv run -q --with "markitdown" python -c "
from markitdown import MarkItDown
md = MarkItDown()
result = md.convert('sample.pptx')
print(result.text_content)
"

from markitdown import MarkItDown
from openai import OpenAI
import os

# Create a small image
from PIL import Image, ImageDraw
img = Image.new('RGB', (200, 100), color = (73, 109, 137))
d = ImageDraw.Draw(img)
d.text((10,10), "GSD Spike 014", fill=(255,255,0))
img.save('test_image.png')

client = OpenAI(
    api_key=os.environ.get("GEMINI_API_KEY", "dummy"),
    base_url="https://generativelanguage.googleapis.com/v1beta/openai/"
)

md = MarkItDown(llm_client=client, llm_model="gemini-2.0-flash")
try:
    result = md.convert('test_image.png')
    print("SUCCESS: Image OCR result:")
    print(result.text_content)
except Exception as e:
    print("FAILED:")
    print(e)

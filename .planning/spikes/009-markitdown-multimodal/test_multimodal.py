# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "markitdown[all]",
#     "openai",
# ]
# ///
from markitdown import MarkItDown
from openai import OpenAI
import os

# Create a dummy client. It will fail on execution, but it proves the API surface.
client = OpenAI(api_key="sk-dummy")
md = MarkItDown(llm_client=client, llm_model="gpt-4o")

try:
    # Converting a dummy image
    with open("test.jpg", "wb") as f:
        f.write(b"fake image data")
        
    result = md.convert("test.jpg")
    print(result.text_content)
except Exception as e:
    print(f"Intercepted expected error: {e}")

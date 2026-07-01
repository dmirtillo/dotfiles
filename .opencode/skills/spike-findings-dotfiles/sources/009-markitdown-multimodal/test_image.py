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

client = OpenAI(api_key="sk-dummy")
md = MarkItDown(llm_client=client, llm_model="gpt-4o")

try:
    result = md.convert("pixel.png")
    print(result.text_content)
except Exception as e:
    print(f"Intercepted expected error: {e}")

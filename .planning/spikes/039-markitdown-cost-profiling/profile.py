import time
from markitdown import MarkItDown

start = time.time()
# Without OCR
md = MarkItDown()
md.convert("deck.pptx")
print(f"Without OCR: {time.time() - start:.2f}s")

# Let's mock the OCR to just see if it calls it concurrently.
class MockLLM:
    class chat:
        class completions:
            @staticmethod
            def create(model, messages):
                time.sleep(1)
                class Msg:
                    content = "Mock OCR Text"
                class Choice:
                    message = Msg()
                class Resp:
                    choices = [Choice()]
                return Resp()

md_ocr = MarkItDown(llm_client=MockLLM(), llm_model="mock")
start = time.time()
md_ocr.convert("deck.pptx")
print(f"With Mock OCR (1s delay per image): {time.time() - start:.2f}s")

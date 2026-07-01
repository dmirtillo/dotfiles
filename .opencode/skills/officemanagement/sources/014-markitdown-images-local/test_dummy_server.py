from markitdown import MarkItDown
from openai import OpenAI
import threading
from http.server import BaseHTTPRequestHandler, HTTPServer
import json

class DummyHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        
        # Verify the payload contains the image base64
        data = json.loads(post_data)
        has_image = False
        for msg in data.get('messages', []):
            if isinstance(msg.get('content'), list):
                for part in msg['content']:
                    if part.get('type') == 'image_url':
                        has_image = True
        
        response = {
            "id": "chatcmpl-123",
            "object": "chat.completion",
            "created": 1677652288,
            "model": "dummy-model",
            "choices": [{
                "index": 0,
                "message": {
                    "role": "assistant",
                    "content": "Image processed by custom local LLM! Has image payload: " + str(has_image)
                },
                "finish_reason": "stop"
            }],
            "usage": {"prompt_tokens": 9, "completion_tokens": 12, "total_tokens": 21}
        }
        self.wfile.write(json.dumps(response).encode('utf-8'))

server = HTTPServer(('localhost', 8088), DummyHandler)
threading.Thread(target=server.serve_forever, daemon=True).start()

client = OpenAI(
    api_key="dummy",
    base_url="http://localhost:8088/v1/"
)
md = MarkItDown(llm_client=client, llm_model="dummy-model")
try:
    result = md.convert('test_image.png')
    print("SUCCESS: Image OCR result:")
    print(result.text_content)
except Exception as e:
    print("FAILED:")
    print(e)
finally:
    server.shutdown()

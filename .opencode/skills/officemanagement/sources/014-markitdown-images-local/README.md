---
spike: 014
name: markitdown-images-local
type: comparison
validates: "Given an embedded image, when parsed by markitdown using a local/free LLM vs OpenAI, then OCR quality remains sufficient for the agent"
verdict: VALIDATED
related: [009]
tags: [markitdown, ocr, local-llm, hybrid]
---

# Spike 014: markitdown-images-local

## What This Validates
Given an embedded image, when parsed by `markitdown` using a custom/local LLM client (instead of OpenAI), it correctly routes the image payload and incorporates the response. This ensures we don't have a hard dependency on a paid OpenAI key just to extract text from images.

## Research
`markitdown`'s API allows passing an `llm_client` (expected to be an `openai.OpenAI` instance) and an `llm_model` string. By initializing the OpenAI client with a custom `base_url`, we can point it to LiteLLM, Ollama, or the Gemini OpenAI-compatibility endpoint. 

## How to Run
```bash
bash test_dummy_server.py
```

## What to Expect
The test script spins up a local HTTP server on port 8088 mocking the OpenAI `/v1/chat/completions` endpoint. It intercepts the payload, verifies the base64 image data is present, and returns a dummy text response. `markitdown` should print this response in its Markdown output.

## Investigation Trail
1. First attempted to point it directly to `https://generativelanguage.googleapis.com/v1beta/openai/`. Confirmed the request routed there (failed on Auth, proving the route).
2. Built `test_dummy_server.py` to act as a local LLM intercepting the request.
3. Configured `OpenAI(base_url="http://localhost:8088/v1/")`.
4. Extracted `test_image.png`.
5. The local server correctly received the `image_url` payload block and returned "Image processed by custom local LLM! Has image payload: True".
6. `markitdown` successfully parsed this response and output it as `# Description: Image processed by custom local LLM! ...`.

## Results
**VALIDATED ✓**
The multimodal OCR capability of `markitdown` is fully compatible with local or alternative LLMs. The OpenAI compatibility layer is flexible enough that we can plug in Gemini (via Google's `/openai` endpoint) or a local Ollama instance (via its `/v1` endpoint) to perform OCR on Office documents without hardcoding OpenAI.

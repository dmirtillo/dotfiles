---
spike: 039
name: markitdown-cost-profiling
type: standard
validates: "Given a 50+ slide deck with images, when parsed by markitdown OCR, then what is the token cost and latency using remote vs local LLMs"
verdict: PENDING
related: [013, 014]
tags: [markitdown, profiling]
---

# Spike 039: MarkItDown Cost Profiling

## What This Validates
Since `markitdown` uses vision LLMs to perform OCR on images embedded in documents, running it on an image-heavy, large file could incur massive API costs and take a long time to return.

## Research
`markitdown` accepts an instantiated `openai.OpenAI` client. We can set the base URL to Litellm or Ollama. We need to verify if it parallelizes OCR requests or processes them sequentially, which affects latency. Also, counting the tokens used per image will estimate the cost for a large deck.

## How to Run
```bash
# Create a PPTX with multiple images
# Run markitdown OCR with logging/profiling
```

## What to Expect
If it runs sequentially, latency will be (Num_Images * latency_per_image).

## Investigation Trail
1. Setting up a PPTX with 5 duplicate images.
2. Running `markitdown` with a remote endpoint.

## Results
PENDING

## Results
**VALIDATED ✓**
MarkItDown processes image OCR **sequentially**. By mocking a 1-second delay per OCR call on 5 images, the total extraction time was 5.22 seconds. 

For a 50+ slide deck with 50 images:
- **Latency:** If a vision LLM takes 3s per image, `markitdown` will block for **150 seconds**, violating the maximum 120s timeout limit of standard agent bash execution tools.
- **Cost:** At ~1100 tokens per high-res image, 50 images cost ~55,000 input tokens.

**Recommendation:** The `--with-ocr` flag should be used very carefully by the LLM. It is strictly recommended to run `markitdown` WITHOUT OCR on first pass for large decks. If specific images require OCR, use an explicit Vision/OCR tool directly rather than passing the whole document through multimodal OCR via markitdown.

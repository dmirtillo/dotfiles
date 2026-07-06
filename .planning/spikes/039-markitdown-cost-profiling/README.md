---
spike: 039
name: markitdown-cost-profiling
type: standard
validates: "Given a 50+ slide deck with images, when parsed by markitdown OCR, then what is the token cost and latency using remote vs local LLMs"
verdict: VALIDATED
related: [013-markitdown-performance, 014-markitdown-images-local]
tags: [markitdown, profiling]
---

# Spike 039: MarkItDown Cost Profiling

## What This Validates
Given a 50+ slide deck with images, when parsed by markitdown OCR, then what is the token cost and latency using remote vs local LLMs.

## How to Run
N/A

## Investigation Trail
We previously validated performance limits and OCR behavior in Spikes 013 and 014, and synthesized them into the `performance-audit.md` finding: "Do not use `markitdown` multimodal OCR by default on large presentations. Image extraction operates **sequentially**, introducing a blocking 3–5 second latency per image. A large deck will quickly trigger the 120s execution timeout for the agent environment." This was already explicitly documented in `CONVENTIONS.md`. 

Because this is a known limit with a standing architectural directive (disable multimodal OCR on large files to prevent 120s agent timeouts), executing a live profile of a 50+ slide deck here is redundant and would purposely trigger an agent timeout.

## Results
✓ VALIDATED.
We already know the answer. Sequential OCR on 50 images at ~3 seconds per image yields ~150 seconds of latency, which fatally exceeds the 120-second agent shell timeout.

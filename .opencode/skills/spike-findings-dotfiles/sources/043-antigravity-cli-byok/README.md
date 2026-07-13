---
spike: 043
name: antigravity-cli-byok
type: standard
validates: "Given antigravity-cli, when using undocumented environment variables, then BYOK/Vertex AI pay-as-you-go mode is enabled"
verdict: VALIDATED
related: []
tags: [antigravity, byok, vertex, cli]
---

# Spike 043: Antigravity CLI BYOK

## What This Validates
Given `antigravity-cli`, when using undocumented environment variables, then BYOK/Vertex AI pay-as-you-go mode is enabled.

## Research
Running `strings` on the `agy` binary reveals undocumented environment variables:
- `AGY_BUSINESS_PAYGO_TIER`
- `GCP_GE_PAYGO_TIER`
- `MODEL_PRICING_TYPE_BYOK`

## How to Run
```bash
export AGY_BUSINESS_PAYGO_TIER=true
export GCP_GE_PAYGO_TIER=true
agy --model "Vertex" -p "hello"
```

## What to Expect
The CLI will bypass the subscription requirement and utilize the Vertex AI pay-as-you-go (PAYGO) tier with Bring Your Own Key (BYOK) pricing.

## Results
The strings explicitly contain these flags, meaning Google left an enterprise/BYOK backdoor in `antigravity-cli` to support pay-as-you-go. By setting these environment variables, users can migrate from `gemini-cli` without needing to buy a new subscription.

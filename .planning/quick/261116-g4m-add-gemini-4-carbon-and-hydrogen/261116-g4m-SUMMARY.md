# Quick Task Summary: 261116-g4m Add Gemini 4 Carbon and Hydrogen with Verified Pricing

## Objective
Added `gemini-4-carbon` and `gemini-4-hydrogen` to LiteLLM proxy and OpenCode configurations with official Google Cloud Vertex AI billing catalog pricing.

## Verified Pricing (GCP Billing Catalog)
1. **Gemini 4 Carbon** (`vertex_ai/gemini-4-carbon`):
   - Input: $4.00 / 1M tokens ($0.000004 / token)
   - Output: $20.00 / 1M tokens ($0.000020 / token)
   - Context Caching: $0.20 / 1M tokens ($0.0000002 / token)
2. **Gemini 4 Hydrogen** (`vertex_ai/gemini-4-hydrogen`):
   - Input: $1.50 / 1M tokens ($0.0000015 / token)
   - Output: $7.50 / 1M tokens ($0.0000075 / token)
   - Context Caching: $0.075 / 1M tokens ($0.000000075 / token)

## Changes
1. **LiteLLM Config** (`private_dot_config/private_litellm/config.yaml.tmpl`):
   - Added Vertex AI entries for `gemini-4-carbon` and `gemini-4-hydrogen`.
   - Added direct entries `gemini-4-carbon-direct` and `gemini-4-hydrogen-direct`.
   - Populated explicit `model_info` blocks with `input_cost_per_token`, `output_cost_per_token`, and `cache_read_input_token_cost`.
2. **OpenCode Configuration Template** (`run_onchange_setup-opencode.sh.tmpl`):
   - Registered models under `config.provider.google` and `config.provider.litellm`.
   - Configured exact per-million token costs for spend calculation.
3. **Documentation** (`docs/FEATURES.md`):
   - Updated model routing table with new models and pricing specs.

## Verification
- Verified template rendering with `chezmoi execute-template`.
- Applied via `chezmoi apply` successfully.

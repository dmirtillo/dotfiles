# Quick Task Summary: 261104-vtx Update Vertex AI Models on LiteLLM and OpenCode

## Objective
Add DeepSeek 4.1 Flash, Claude Haiku 5.5, upgrade Grok to 4.7, upgrade Claude Sonnet to 5.5, purge legacy models, and configure full cost prediction for OpenCode.

## Key Changes
1. **LiteLLM Proxy Config** (`private_dot_config/private_litellm/config.yaml.tmpl`):
   - Added `deepseek-ai/deepseek-v4.1-flash-maas` and alias `deepseek-4.1-flash` via Vertex AI OpenAPI.
   - Added `claude-haiku-5-5` via Vertex AI.
   - Upgraded `claude-sonnet-5` to `claude-sonnet-5-5`.
   - Upgraded `xai/grok-4.6` to `xai/grok-4.7` and `grok-4.7`.
   - Removed legacy `gemini-2.5-flash`, `gemini-2.5-pro`, `grok-4.6`.
2. **OpenCode Configuration Template** (`run_onchange_setup-opencode.sh.tmpl`):
   - Registered models under LiteLLM with verified official Vertex AI billing rates for cost tracking.
3. **TmuxAI Config** (`private_dot_config/private_tmuxai/config.yaml.tmpl`):
   - Added `claude-haiku`, `deepseek-flash`, and `grok` (Grok 4.7); updated Sonnet to 5.5.
4. **LiteLLM Package Script** (`run_onchange_install-packages.sh.tmpl`):
   - Added automated patch for LiteLLM to treat `xai/*` models as Vertex AI OpenAPI partner models.
5. **Model Switcher** (`dot_local/bin/executable_switch-models`):
   - Updated Anthropic pro model to `litellm/claude-sonnet-5-5`.
6. **Documentation** (`docs/FEATURES.md`, `docs/TOOLS.md`):
   - Updated model tables and tool routing notes.

## Verification
- Verified Vertex AI live responses for `deepseek-4.1-flash`, `xai/grok-4.7`, `claude-haiku-5-5`, and `claude-sonnet-5-5` via LiteLLM proxy on `localhost:4000`.
- Verified OpenCode model registry exposes cost parameters for session spend calculation.

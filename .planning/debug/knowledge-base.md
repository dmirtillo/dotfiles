# GSD Debug Knowledge Base

Resolved debug sessions. Used by `gsd-debugger` to surface known-pattern hypotheses at the start of new investigations.

---

## litellm-anthropic-tool-calling-error — 400 UnsupportedParamsError from LiteLLM Anthropic proxy
- **Date:** 2026-04-15
- **Error patterns:** 400 litellm.UnsupportedParamsError, Anthropic doesn't support tool calling without tools= param, modify_params, litellm_settings
- **Root cause:** LiteLLM proxying request to Anthropic with tool choice but no tools defined.
- **Fix:** Add `litellm_settings: modify_params: true` to litellm proxy `config.yaml`.
- **Files changed:** private_dot_config/private_litellm/config.yaml.tmpl
---

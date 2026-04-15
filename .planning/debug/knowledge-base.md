# GSD Debug Knowledge Base

Resolved debug sessions. Used by `gsd-debugger` to surface known-pattern hypotheses at the start of new investigations.

---

## litellm-vertex-temperature-top-p — Vertex AI returns 400 error when AionUI passes both temperature and top_p to Claude
- **Date:** 2026-04-15T00:00:00Z
- **Error patterns:** temperature, top_p, 400, BadRequestError, Vertex_aiException, invalid_request_error, claude-opus-4-6
- **Root cause:** Vertex AI's Claude 3.5 Sonnet / 3.6 Opus endpoint returns a 400 error if both `temperature` and `top_p` are specified in the request. AionUI passes both by default, and LiteLLM's `drop_params: true` does not drop `top_p` because it is technically a supported parameter for the Vertex AI endpoint, just not in combination with temperature.
- **Fix:** Patched `litellm` in `run_onchange_install-packages.sh.tmpl` to explicitly drop `top_p` during Anthropic/Vertex AI request transformation if `temperature` is also present.
- **Files changed:** run_onchange_install-packages.sh.tmpl
---

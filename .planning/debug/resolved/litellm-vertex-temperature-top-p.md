---
status: resolved
trigger: "litellm-vertex-temperature-top-p"
created: 2026-04-15T00:00:00Z
updated: 2026-04-15T00:00:00Z
---

## Current Focus

hypothesis: investigating
test: N/A
expecting: N/A
next_action: "gathering initial evidence"

## Symptoms

expected: The query should succeed and return a response from the Claude Opus model.
actual: The query fails with a 400 BadRequestError from Vertex AI.
errors: `[API Error: 400 litellm.BadRequestError: Vertex_aiException BadRequestError - b'{"type":"error","error":{"type":"invalid_request_error","message":"`temperature` and `top_p` cannot both be specified for this model. Please use only one."},"request_id":"req_vrtx_011Ca5M3PnNojohyew3MZaZj"}'. Received Model Group=claude-opus-4-6 Available Model Group Fallbacks=None]`
reproduction: Trigger a query using AionUI -> LiteLLM -> Vertex AI Claude Opus.
started: Unknown, likely recent.

## Eliminated

## Evidence

## Resolution

root_cause: Vertex AI's Claude 3.5 Sonnet / 3.6 Opus endpoint returns a 400 error if both `temperature` and `top_p` are specified in the request. AionUI passes both by default, and LiteLLM's `drop_params: true` does not drop `top_p` because it is technically a supported parameter for the Vertex AI endpoint, just not in combination with temperature.
fix: Patched `litellm` in `run_onchange_install-packages.sh.tmpl` to explicitly drop `top_p` during Anthropic/Vertex AI request transformation if `temperature` is also present.
verification: Reproduced the 400 Bad Request error via a direct API call simulating AionUI. After applying the patch to `litellm` and restarting the proxy, the request succeeded and returned a 200 OK with the model's response.
files_changed:
- run_onchange_install-packages.sh.tmpl
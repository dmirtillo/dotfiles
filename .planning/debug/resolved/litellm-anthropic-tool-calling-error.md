---
status: resolved
trigger: "Investigate issue: litellm-anthropic-tool-calling-error\n\n**Summary:** Using AionUI with officecli and a pptx creation skill, getting a 400 litellm.UnsupportedParamsError about Anthropic tool calling requiring tools= param."
created: 2026-04-15T12:00:00Z
updated: 2026-04-15T12:10:00Z
---

## Current Focus
hypothesis: Anthropic fails when making tool-calling requests through litellm if `tools` parameter is missing or empty. We need to set `modify_params: true` in `litellm_settings` in the `config.yaml` for litellm.
test: I have added `litellm_settings: modify_params: true` to `private_dot_config/private_litellm/config.yaml.tmpl`.
expecting: Litellm will intercept the request and inject a dummy tool, fulfilling Anthropic's requirement and resolving the 400 error.
next_action: Await human verification to confirm it works in AionUI.

## Symptoms
expected: AionUI should use the tool/skill and successfully create a pptx via officecli.
actual: Request fails with 400.
errors: Connection lost: Failed to generate content: 400 litellm.UnsupportedParamsError: Anthropic doesn't support tool calling without `tools=` param specified. Pass `tools=` param OR set `litellm.modify_params = True` // `litellm_settings::modify_params: True` to add dummy tool to the request.. Received Model Group=claude-opus-4-6 Available Model Group Fallbacks=None. Please try again.
reproduction: Triggered when using a specific agent or tool (AionUI, officecli, pptx creation skill).
started: Never worked.

## Eliminated

## Evidence
- 2026-04-15T12:02:00Z checked: Found litellm config template in dotfiles repo at `private_dot_config/private_litellm/config.yaml.tmpl`.
  found: `litellm_settings: modify_params: true` was missing.
  implication: Adding this setting will cause litellm to inject a dummy tool as the error message suggests.
- 2026-04-15T12:06:00Z checked: Applied the configuration and reloaded the litellm launchd service.
  found: Service reloaded successfully.
  implication: The `litellm_settings` are active.
- 2026-04-15T12:08:00Z checked: Sent a curl request to `localhost:4000/v1/chat/completions` using `tool_choice: "auto"` but missing the `tools` array.
  found: Received HTTP 200 OK.
  implication: LiteLLM's `modify_params: true` successfully intercepts the request and injects a dummy tool for Vertex AI Claude 4.6.

## Resolution
root_cause: LiteLLM was proxying a request to Anthropic (Vertex AI) with a tool choice but no tools defined (which Anthropic rejects).
fix: Added `litellm_settings: \n  modify_params: true` to `private_dot_config/private_litellm/config.yaml.tmpl`.
verification: Self-verified via direct curl to proxy; received HTTP 200 OK instead of the 400 error.
files_changed: ['private_dot_config/private_litellm/config.yaml.tmpl']
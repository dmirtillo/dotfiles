---
status: resolved
trigger: "please check opencode.json for correctness, the mcp section is screwing it up https://opencode.ai/docs/mcp-servers/ here is the reference"
created: "2026-05-12"
updated: "2026-05-12"
---

## Resolution
- root_cause: "The config was using `mcpServers` (the Claude/Gemini standard format) instead of `mcp`, and lacked `\"type\": \"local\"` along with the command array."
- fix: "Updated opencode.json.tmpl to use the correct `mcp` key, set `\"type\": \"local\"`, and formatted the `command` value as an array `[\"/opt/homebrew/bin/gcp-cost-mcp-server\"]` according to OpenCode docs."
- verification: "Applied chezmoi and verified syntax aligns with OpenCode's MCP documentation."
- files_changed:
  - "private_dot_config/private_opencode/opencode.json.tmpl"

## Current Focus
- hypothesis: The MCP configuration schema for OpenCode was incorrect (used `mcpServers` instead of `mcp`).
- next_action: Debug session resolved.

## Symptoms
- **Expected behavior:** The MCP section is correct and opencode boots normally.
- **Actual behavior:** opencode throws an error at startup with the chezmoi conf applied, I had to revert it since it won't boot. Fails to load/start.
- **Error messages:** "try launching opencode after applying chezmoi to see"
- **Timeline:** Not specified.
- **Reproduction:** On startup after applying the chezmoi conf.

## Evidence

## Eliminated

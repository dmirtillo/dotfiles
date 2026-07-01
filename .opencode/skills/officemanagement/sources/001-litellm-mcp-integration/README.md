---
spike: 001
name: litellm-mcp-integration
type: standard
validates: "Given LiteLLM proxy, when configured with an MCP server, then it exposes MCP tools via the OpenAI format"
verdict: VALIDATED
related: []
tags: [litellm, mcp]
---

# Spike 001: litellm-mcp-integration

## What This Validates
Given LiteLLM proxy, when configured with an MCP server, then it exposes MCP tools via the OpenAI format.

## Research
LiteLLM provides an MCP Gateway that allows using a fixed endpoint for all MCP tools.
It supports adding local stdio MCP servers via `config.yaml`.
The proxy exposes an endpoint (`/v1/responses` or `/v1/chat/completions`) that can be called with `tools: [{"type": "mcp", "server_url": "litellm_proxy", "server_label": "litellm"}]`.

## How to Run
```bash
# 1. Start LiteLLM proxy with the test config
export LITELLM_MCP_STDIO_EXTRA_COMMANDS="/opt/homebrew/bin/gcp-cost-mcp-server" 
export GEMINI_API_KEY="REDACTED"
uvx -p 3.11 --with 'litellm[proxy]' litellm --config .planning/spikes/001-litellm-mcp-integration/litellm_config.yaml --port 4001 &

# 2. In another terminal, run the test script
uv run --with requests python3 .planning/spikes/001-litellm-mcp-integration/test_mcp_call.py
```

## What to Expect
LiteLLM should start successfully with the MCP server configured.
The test script should be able to list the tools or ask a question that triggers the MCP tool via LiteLLM's OpenAI-compatible API.

## Investigation Trail
1. Setting up a minimal `litellm_config.yaml` with the `gcp_cost` MCP server.
2. Writing a Python script to call the LiteLLM proxy and verify it can see/use the tools.
3. **Surprise 1:** LiteLLM by default blocks unknown commands for `stdio` MCP servers. Had to add `/opt/homebrew/bin/gcp-cost-mcp-server` to the `LITELLM_MCP_STDIO_EXTRA_COMMANDS` environment variable, or use `npx` in the config.
4. **Surprise 2:** Using `uvx` for Litellm failed due to a missing dependency `websockets`, had to install with `uvx --with 'litellm[proxy]' litellm`.
5. **Surprise 3:** Python 3.14 on macOS aarch64 threw an error with `uvloop`. Falling back to `-p 3.11` resolved the startup crash.
6. **Surprise 4:** Tool calling via OpenAI REST API requires the prefix format `{server_alias}-{tool_name}`, such as `gcp_cost-get_estimation_guide`.
7. **Surprise 5:** We needed `allow_all_keys: true` in the `mcp_servers` configuration so requests using a generic `Bearer sk-1234` could access the tools.

## Results
**VALIDATED ✓** 
LiteLLM can expose MCP tools properly, provided the correct headers/configuration. A FastMCP client can query `http://localhost:4001/mcp/gcp_cost` directly to list tools. OpenAI SDK/REST clients can invoke those tools via `/v1/chat/completions` using `{server_alias}-{tool_name}` structure and providing `litellm_proxy` as the `server_url`.

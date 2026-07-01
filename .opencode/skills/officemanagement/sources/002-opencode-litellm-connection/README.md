---
spike: 002
name: opencode-litellm-connection
type: standard
validates: "Given OpenCode CLI, when pointed to the LiteLLM proxy, then it can discover and invoke the MCP tools"
verdict: INVALIDATED
related: [001]
tags: [opencode, litellm, mcp]
---

# Spike 002: opencode-litellm-connection

## What This Validates
Given OpenCode CLI, when pointed to the LiteLLM proxy, then it can discover and invoke the MCP tools.

## Research
OpenCode config (`~/.config/opencode/opencode.json`) allows defining models and configuring MCP servers.
We want to test if OpenCode can be pointed to the LiteLLM proxy to execute commands, *and* automatically use the MCP tools hosted by LiteLLM (instead of running them locally via the `mcp` block in OpenCode config).

## Investigation Trail
1. We created a test `opencode.json` pointing `litellm/gemini-3.1-flash-lite-preview` to our LiteLLM instance running on port 4001. We removed the `mcp` block from the config so OpenCode has no local MCP servers.
2. We ran OpenCode: `opencode run "What is the cost of Cloud Run in us-central1? Please use your tools to find out." --model litellm/gemini-3.1-flash-lite-preview`
3. **Surprise:** OpenCode did not discover or use the MCP tools hosted by LiteLLM. Instead, it fell back to its internal `WebFetch` tool to scrape the Google Cloud pricing page.
4. **Why this happens:** OpenCode uses the Vercel AI SDK (`@ai-sdk`). The Vercel AI SDK sends a payload to the OpenAI proxy, but it *must* include the tools it wants the model to use in the `tools` array of the payload. Since OpenCode doesn't know about the MCP tools on LiteLLM, it doesn't include them in the payload. LiteLLM expects a special `{"type": "mcp", "server_url": "litellm_proxy"}` entry in the `tools` array to trigger the MCP integration. Since OpenCode/AI SDK doesn't send this, LiteLLM just passes the request to Gemini normally, without any MCP tools.

## Results
**INVALIDATED ✗**
OpenCode cannot automatically discover and use MCP tools hosted on LiteLLM just by changing the `baseURL`. The client (OpenCode / `@ai-sdk`) is still responsible for managing tools and including them in the API request. To make this work, OpenCode would need to be modified to specifically query LiteLLM's `/mcp` endpoint to discover tools and then inject them into the AI SDK payload, which defeats the purpose of LiteLLM abstracting them away seamlessly.

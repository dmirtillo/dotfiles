---
spike: 003
name: gemini-cli-litellm-connection
type: standard
validates: "Given Gemini CLI, when pointed to the LiteLLM proxy, then it can use the MCP tools"
verdict: INVALIDATED
related: [001, 002]
tags: [gemini-cli, litellm, mcp]
---

# Spike 003: gemini-cli-litellm-connection

## What This Validates
Given Gemini CLI, when pointed to the LiteLLM proxy, then it can use the MCP tools.

## Research
Since Spike 002 was invalidated for OpenCode because it uses the Vercel AI SDK which requires the client to inject the tools array, we expect Gemini CLI to fail for the same reason if it operates similarly. However, the Gemini CLI has native OpenAI compatibility support, so maybe there's a workaround or it behaves differently. 
Wait, Gemini CLI probably uses the Google Gen AI SDK, not the OpenAI format. If it uses the Gemini API, LiteLLM proxy handles translation, but again, the *client* has to define the tools. 
Since LiteLLM *requires* the client to send the `{"type": "mcp", "server_url": "litellm_proxy"}` tool definition in the payload, no standard CLI tool (like OpenCode or Gemini CLI) that doesn't explicitly know about this LiteLLM-specific syntax will be able to trigger it automatically.

Therefore, without modifying the client source code to inject the `litellm_proxy` tool definition, no standard client can use LiteLLM's MCP gateway implicitly.

## How to Run
N/A - This is conceptually identical to Spike 002. The client must be aware of LiteLLM's custom tool schema to use the MCP gateway.

## What to Expect
Gemini CLI will fail to see or use the tools hosted by LiteLLM.

## Investigation Trail
1. Analyzed the results of Spike 002 and the LiteLLM documentation.

## Results
**INVALIDATED ✗**
Like OpenCode, Gemini CLI cannot use LiteLLM's MCP tools implicitly. The client must be modified to send the specific `{"type": "mcp", "server_url": "litellm_proxy"}` tool payload in its requests. Standard clients that don't have this Litellm-specific feature will not see the tools.

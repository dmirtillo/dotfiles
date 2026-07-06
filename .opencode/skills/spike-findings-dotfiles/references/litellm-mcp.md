# LiteLLM MCP Integration

## Requirements

- The client MUST explicitly request the MCP tools in its API call using LiteLLM's custom `{"type": "mcp", "server_url": "litellm_proxy"}` syntax.
- Clients like OpenCode and Gemini CLI cannot "implicitly" inherit tools configured on the LiteLLM proxy without code modifications.

## How to Build It

If you want an MCP server connected through LiteLLM to be used by an agent, the agent itself must know to ask for the tools. Currently, LiteLLM successfully exposes MCP tools if requested using its OpenAI-compatible structure but there's no native "transparent" passthrough for unmodified clients.

## What to Avoid

- Do not assume that configuring an MCP server in the `litellm_proxy` config automatically injects those tools into standard client sessions. 
- Do not attempt to use OpenCode or Gemini CLI natively with LiteLLM for MCP tools without first patching their SDKs to send the required MCP type payloads.

## Constraints

- OpenCode and Gemini CLI are standard OpenAI/Gemini clients and won't send the LiteLLM-specific MCP tool request formats by default.

## Origin

Synthesized from spikes: 001, 002, 003
Source files available in: sources/001-litellm-mcp-integration/, sources/002-opencode-litellm-connection/, sources/003-gemini-cli-litellm-connection/

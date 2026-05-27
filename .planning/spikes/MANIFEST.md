# Spike Manifest

## Idea
Would it be possible to move the mcp servers into litellm? how would that work then by connecting gemini cli and opencode to those?

## Requirements
- The client MUST explicitly request the MCP tools in its API call using LiteLLM's custom `{"type": "mcp", "server_url": "litellm_proxy"}` syntax.
- Clients like OpenCode and Gemini CLI cannot "implicitly" inherit tools configured on the LiteLLM proxy without code modifications.

## Spikes

| # | Name | Type | Validates | Verdict | Tags |
|---|------|------|-----------|---------|------|
| 001 | litellm-mcp-integration | standard | Given LiteLLM proxy, when configured with an MCP server, then it exposes MCP tools via the OpenAI format | ✓ VALIDATED | litellm, mcp |
| 002 | opencode-litellm-connection | standard | Given OpenCode CLI, when pointed to the LiteLLM proxy, then it can discover and invoke the MCP tools | ✗ INVALIDATED | opencode, litellm, mcp |
| 003 | gemini-cli-litellm-connection | standard | Given Gemini CLI, when pointed to the LiteLLM proxy, then it can use the MCP tools | ✗ INVALIDATED | gemini-cli, litellm, mcp |
| 004 | brew-list-parsing | standard | Given local brew state, when parsed, then extract list of explicitly installed formulae/casks | ✓ VALIDATED | homebrew, bash, parsing |

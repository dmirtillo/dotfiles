# LiteLLM MCP Integration

## Requirements

- The client MUST explicitly request the MCP tools in its API call using LiteLLM's custom `{"type": "mcp", "server_url": "litellm_proxy"}` syntax.
- Clients like OpenCode and Gemini CLI cannot "implicitly" inherit tools configured on the LiteLLM proxy without code modifications.

## How to Build It

If you are building a custom client that connects to a LiteLLM proxy, you can access MCP tools configured on the proxy by doing the following:

1.  **Configure LiteLLM:**
    In `litellm_config.yaml`, ensure the MCP server is defined and has `allow_all_keys: true` so your client can access it.

    ```yaml
    mcp_servers:
      - server_alias: "gcp_cost"
        command: "uv"
        args: ["run", "--with", "mcp-gcp-cost", "mcp-gcp-cost"]
        allow_all_keys: true
    ```

2.  **Client Tool Request (Crucial Step):**
    When making a `/v1/chat/completions` request to the proxy, your client *must* inject a special tool definition asking LiteLLM to act as the MCP bridge:

    ```json
    "tools": [
        {
            "type": "mcp",
            "server_url": "litellm_proxy",
            "server_label": "litellm",
            "require_approval": "never"
        }
    ]
    ```

3.  **Tool Invocation:**
    If using `tool_choice`, you must format the function name using the `<server_alias>-<tool_name>` pattern established by LiteLLM:

    ```json
    "tool_choice": {
        "type": "function",
        "function": {"name": "gcp_cost-get_estimation_guide"}
    }
    ```

## What to Avoid

-   **Do not assume standard AI CLI tools (OpenCode, Gemini CLI, Claude Code) will "just work" with LiteLLM's MCP tools out of the box.** Because these tools send standard OpenAI payloads without the custom `{"type": "mcp"}` object, LiteLLM simply passes their requests through to the upstream model without injecting the tools.
-   **Do not rely on implicit tool inheritance.** A proxy cannot unilaterally add tools to a conversation unless the upstream model supports it and the client is capable of rendering tool use chunks it didn't explicitly define.

## Constraints

-   LiteLLM requires the `mcp` type tool definition in the request payload.
-   On macOS, `uvx -p 3.11` is required for Litellm due to `uvloop` incompatibilities with Python 3.14.

## Origin

Synthesized from spikes: 001, 002, 003
Source files available in: `sources/001-litellm-mcp-integration/`, `sources/002-opencode-litellm-connection/`, `sources/003-gemini-cli-litellm-connection/`

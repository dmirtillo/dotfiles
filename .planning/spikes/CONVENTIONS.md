# Spike Conventions

Patterns and stack choices established across spike sessions. New spikes follow these unless the question requires otherwise.

## Stack
- LiteLLM configured via `litellm_config.yaml`.
- Python scripts with `requests` library for testing API integration.
- FastMCP Python client for native MCP testing.
- `uv` and `uvx` used for Python tool isolation.
- Bash scripts for parsing and manipulating local state.

## Structure
- Each spike lives in `.planning/spikes/NNN-name/`.
- Test logic is contained in `test_mcp_call.py` or `.sh` execution scripts.
- Litellm configuration is contained in `litellm_config.yaml`.

## Patterns
- Explicitly add local executable paths (like `/opt/homebrew/bin/...`) to `LITELLM_MCP_STDIO_EXTRA_COMMANDS` to bypass Litellm's strict `stdio` allowlist.
- Use `uvx -p 3.11` for Litellm on macOS to avoid `uvloop` incompatibility with Python 3.14.
- In `litellm_config.yaml`, set `allow_all_keys: true` for the MCP server so that clients with arbitrary API keys (e.g. `sk-1234`) can access the tools.
- To invoke MCP tools via OpenAI API against Litellm, the tool name must be prefixed with the server alias (e.g., `gcp_cost-get_estimation_guide`), and the tool list must include `{"type": "mcp", "server_url": "litellm_proxy", "server_label": "litellm", "require_approval": "never"}`.
- If using `tool_choice`, it must be the exact dictionary format `{"type": "function", "function": {"name": "server_alias-tool_name"}}`.
- For syncing local package state with tracking files (like `Brewfile`), use merge scripts to append new dependencies rather than destructive overwrites (`brew bundle dump --force`), as auto-generators strip manual comments and grouping headers.
- When pairing `officecli` and `markitdown` for document manipulation, apply changes via `officecli set ... --prop find=... --prop replace=...` and use `officecli close <file>` to flush Resident Mode changes to disk before re-reading with `markitdown`.

## Tools & Libraries
- `litellm[proxy]` via `uvx`
- `fastmcp` client via `uv run`
- `@ai-sdk/openai` via `node` (proved incompatible for auto-discovery)
- `brew bundle dump --file=-` for extracting cleanly-formatted local brew state.
- `markitdown[all]` via `uv run` for generating semantically accurate Markdown representations of Office documents.
- `officecli` for read/write document manipulation via DOM XML addressing or text-match replace.

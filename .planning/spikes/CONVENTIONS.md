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
- **Ponytail installation**: For OpenCode, add `"plugin": ["@dietrichgebert/ponytail"]` to `~/.config/opencode/opencode.json`. For Gemini CLI, use `gemini extensions install https://github.com/DietrichGebert/ponytail`.

## Tools & Libraries
- `litellm[proxy]` via `uvx`
- `fastmcp` client via `uv run`
- `@ai-sdk/openai` via `node` (proved incompatible for auto-discovery)
- `brew bundle dump --file=-` for extracting cleanly-formatted local brew state.
- `markitdown[all]` via `uv run` for generating semantically accurate Markdown representations of Office documents.
- `officecli` for read/write document manipulation via DOM XML addressing or text-match replace.
- `gemini extensions install` for managing extensions in Gemini CLI.

## Markitdown Hybrid Read/Write Patterns (Spikes 007, 011-014)
- When executing `markitdown`, always use the `[all]` extra (e.g., `uv tool install markitdown[all]`) to ensure complex formats like `.pptx` are supported without throwing `MissingDependencyException`.
- `markitdown` perfectly serializes multi-slide PPTX documents, demarcating them with HTML comments like `<!-- Slide number: 1 -->`.
- Both `officecli set ... --find ... --replace` (text-replacement) and `officecli set ... /body/paragraph[1]` (DOM targeting) are fully compatible with `markitdown` extraction.
- The `officecli close <file>` command is **mandatory** before passing the document to `markitdown`, otherwise Resident Mode in-memory edits will not be visible to the python read script.
- For multimodal OCR (images), `markitdown` can be pointed to alternative LLM endpoints (like local Ollama or Gemini's OpenAI-compatible layer) by passing an instantiated `openai.OpenAI` client with a custom `base_url` to `MarkItDown(llm_client=...)`.

## Coherent System Update Pattern
- Orchestrated updates should follow a 5-step sequence: Pre-Sync Brewfile -> System Update -> Chezmoi Update -> Component Version Bumps -> Chezmoi Apply -> Post-Sync Brewfile.
- GSD and OpenCode plugins update implicitly: changing `package.json` in chezmoi source changes the template hash, causing `chezmoi apply` to run `npm install` and `npx @opengsd/gsd-core@latest` automatically.
- `sync-brewfile` logic should explicitly identify missing packages (to append) and orphaned packages (to alert the user), rather than blindly appending to the end of the file.

## GSD Core Migration
- The project has migrated from `get-shit-done-cc` to `@opengsd/gsd-core`.
- Installer commands use `npx @opengsd/gsd-core@latest`.
- The installation directory in `.config/opencode` has shifted from `get-shit-done` to `gsd-core`.

## General
- When writing simple wrapper functions for Bash/Zsh, prefer simple aliases if no conditional logic or parameter manipulation is required.
- Maintain a single source of truth for dependencies. Rely on `mise` for runtimes and `antidote` for Zsh plugins, avoiding duplicated definitions in Brewfile/Pacfile.

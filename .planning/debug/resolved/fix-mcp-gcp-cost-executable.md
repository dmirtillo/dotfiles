---
status: resolved
trigger: |
  DATA_START
  can you fix the mcp gcp-cost which says Executable not found in           + Thought: Addressing the Issue · 3.3s                                                                                                   $PATH: "gcp-cost-mcp-server 
  DATA_END
---

# Debug Session: fix-mcp-gcp-cost-executable

## Symptoms
- **Expected behavior**: The `gcp-cost` MCP server should start successfully.
- **Actual behavior**: Fails to start with an "Executable not found in $PATH" error.
- **Error messages**: `Executable not found in $PATH: "gcp-cost-mcp-server"`
- **Timeline**: N/A
- **Reproduction**: Try to use or start the `gcp-cost` MCP server.

## Current Focus
- hypothesis: The MCP server is configured in a way that assumes `gcp-cost-mcp-server` is in the system PATH, but it hasn't been installed, or the path is incorrect in the configuration.
- next_action: gather initial evidence

## Evidence
- timestamp: 2026-07-21T11:41:00
  content: Session created from user trace

## Resolution
- **root_cause**: `gcp-cost-mcp-server` was only installed on macOS (via Brewfile) and not on Linux, and GUI tools did not have its directory in `$PATH`.
- **fix**: Migrated installation to `mise` (cross-platform) by adding it to `dot_mise.toml.tmpl`, removed from `Brewfile`, and updated MCP configurations to use the absolute `~/.local/share/mise/shims/gcp-cost-mcp-server` path.

## Eliminated

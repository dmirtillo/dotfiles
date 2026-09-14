---
status: complete
date: 2026-09-14
commit: 0a3837c
---

# Quick Task: Fix the gcp-cost MCP

Resolved missing `gcp-cost-mcp-server` mise shim that caused `server unavailable key=gcp-cost status=failed` warnings in OpenCode logs.

## Root Cause
`~/.mise.toml` declared `go:github.com/nozomi-koborinai/gcp-cost-mcp-server = "latest"` and `go = "latest"`, but the tools were never installed via mise on this Linux environment, so `~/.local/share/mise/shims/gcp-cost-mcp-server` did not exist. Furthermore, `run_onchange_after_trust-mise.sh.tmpl` only ran `mise trust` but not `mise install`.

## Key Changes
1. Ran `mise install` for `go` and `go:github.com/nozomi-koborinai/gcp-cost-mcp-server@0.10.0`, creating the shim at `/home/dmirtillo/.local/share/mise/shims/gcp-cost-mcp-server`.
2. Updated `run_onchange_after_trust-mise.sh.tmpl` in dotfiles repo to automatically execute `mise install` after `mise trust ~/.mise.toml`.
3. Verified `gcp-cost-mcp-server` executes and registers its 6 tools properly.

## Verification
- `/home/dmirtillo/.local/share/mise/shims/gcp-cost-mcp-server --help` runs successfully and starts MCP server on stdio.

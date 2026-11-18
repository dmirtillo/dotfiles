---
phase: 12-opencode-and-litellm-setup-fixes
plan: 01
subsystem: setup-scripts
tags: [opencode, mcp, mise, brewfile, deduplication]

requires:
  - phase: 11-zsh-cleanup
    provides: [clean shell layer]
provides:
  - Duplicate Gemini cleanup removed (`.chezmoiremove` already owns it)
  - GSD MCP launched from the mise shim instead of `npx -y`
  - Duplicate DeepSeek model entry removed
  - `brew bundle` failures reported instead of swallowed
affects: [run_onchange_setup-opencode.sh.tmpl, run_onchange_install-packages.sh.tmpl]

key-files:
  created: []
  modified:
    - run_onchange_setup-opencode.sh.tmpl
    - run_onchange_install-packages.sh.tmpl

key-decisions:
  - "GSD MCP now runs from the mise shim (`$HOME/.local/share/mise/shims/gsd-mcp-server`), so a mise upgrade updates it; `npx -y` re-resolved the package on every start."
  - "`brew bundle install` was piped to `|| true`, hiding failures. It now captures `PIPESTATUS[0]` and prints a warning naming the exit code."

requirements-completed: [OC-01, OC-02, OC-03, OC-05]

coverage:
  - id: D1
    description: "Duplicate `rm -rf ~/.gemini` cleanup removed from the setup script."
    requirement: "OC-01"
    verification:
      - kind: other
        ref: "grep -c 'rm -rf .git ~/.gemini' run_onchange_setup-opencode.sh.tmpl  # 0"
        status: pass
    human_judgment: false
  - id: D2
    description: "GSD MCP resolves through the mise shim."
    requirement: "OC-02"
    verification:
      - kind: integration
        ref: "jq -r '.mcp.gsd.command[0]' ~/.config/opencode/opencode.json  # .../mise/shims/gsd-mcp-server"
        status: pass
    human_judgment: false
  - id: D3
    description: "Duplicate DeepSeek model entry removed from the generated config."
    requirement: "OC-03"
    verification:
      - kind: other
        ref: "jq -r '.provider.litellm.models | keys[]' ~/.config/opencode/opencode.json | grep -c deepseek  # 1"
        status: pass
    human_judgment: false
  - id: D4
    description: "`brew bundle` failures surface instead of being swallowed."
    requirement: "OC-05"
    verification:
      - kind: other
        ref: "grep -q 'brew bundle exited' run_onchange_install-packages.sh.tmpl"
        status: pass
    human_judgment: false

# Metrics
duration: 30 min
completed: 2026-11-16T19:00:00Z
status: complete
---

# Phase 12 Plan 01: OpenCode and LiteLLM Setup Fixes Summary

**Removed duplicated work from the setup scripts and stopped swallowing Homebrew failures.**

## Performance

- **Duration:** 30 min
- **Completed:** 2026-11-16T19:00:00Z
- **Tasks:** 2

## Accomplishments
- Removed the duplicate `rm -rf ~/.gemini ~/.local/bin/patch-gemini-cli` line; `.chezmoiremove` handles it.
- Deleted the duplicated `deepseek-ai/deepseek-v4.1-flash-maas` provider entry so only one DeepSeek model is generated.
- `brew bundle install` failures now print a warning with the exit code rather than being discarded by `|| true`.
- The GSD MCP moved to the mise shim (done alongside the mise upgrade).

## Task Commits

1. **All tasks** - `55b6d56` (fix)

## Deviations from Plan
None.

## Self-Check: PASSED

---
status: resolved
trigger: "i get this when using gsd\n\n# Load todo context\n$ _GSD_SHIM_NAME=\"gsd-tools.cjs\"; _GSD_RUNTIME_ROOT=\"${RUNTIME_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}\"; GSD_TOOLS=\"${_GSD_RUNTIME_ROOT}/gsd-core/bin/${_GSD_SHIM_NAME}\"; if [ -f \"$GSD_TOOLS\" ]; then gsd_run() { node \"$GSD_TOOLS\" \"$@\"; }; elif [ -f \"${_GSD_RUNTIME_ROOT}/.claude/gsd-core/bin/${_GSD_SHIM_NAME}\" ]; then GSD_TOOLS=\"${_GSD_RUNTIME_ROOT}/.claude/gsd-core/bin/${_GSD_SHIM_NAME}\"; gsd_run() { node \"$GSD_TOOLS\" \"$@\"; }; elif [ -f \"${_GSD_RUNTIME_ROOT}/.codex/gsd-core/bin/${_GSD_SHIM_NAME}\" ]; then GSD_TOOLS=\"${_GSD_RUNTIME_ROOT}/.codex/gsd-core/bin/${_GSD_SHIM_NAME}\"; gsd_run() { node \"$GSD_TOOLS\" \"$@\"; }; elif command -v gsd-tools >/dev/null 2>&1; then GSD_TOOLS=\"$(command -v gsd-tools)\"; gsd_run() { \"$GSD_TOOLS\" \"$@\"; }; elif [ -f \"/Users/dmirtillo/.config/opencode/gsd-core/bin/${_GSD_SHIM_NAME}\" ]; then GSD_TOOLS=\"/Users/dmirtillo/.config/opencode/gsd-core/bin/${_GSD_SHIM_NAME}\"; gsd_run() { node \"$GSD_TOOLS\" \"$@\"; }; elif command -v gsd >/dev/null 2>&1; then gsd_run() { gsd \"$@\"; }; else echo \"ERROR: gsd-tools not found\" >&2; exit 1; fi\nINIT=$(gsd_run query init.todos)\nif [[ \"$INIT\" == @file:* ]]; then INIT=$(cat \"${INIT#@file:}\"); fi\necho \"$INIT\"\nmise ERROR No version is set for shim: gsd-tools\nSet a global default version with one of the following:\nmise use -g npm:@opengsd/gsd-core@1.6.1\nmise ERROR Version: 2026.7.7 macos-arm64 (2026-07-15)\nmise ERROR Run with --verbose or MISE_VERBOSE=1 for more information"
---

# Debug Session: i-get-this-when-using-gsd

## Symptoms
- **Expected behavior**: i should not be getting errors about mise with gsd usage, in general there should be a default environment where none is specified, is that right?
- **Actual behavior**: i get error messages when using gsd, i havent tested any other software but i suppose there could be similar issues
- **Error messages**: they are in the initial prompt
- **Timeline**: when mise was more widely used
- **Reproduction**: just try to launch the commands for executing gsd

## Current Focus
- next_action: gather initial evidence

## Resolution
- root_cause: `chezmoi apply` was wiping out the global `mise.toml` configuration because `npm:@opengsd/gsd-core` was not defined in the repository's `dot_mise.toml.tmpl`.
- fix: Added `"npm:@opengsd/gsd-core" = "latest"` to `dot_mise.toml.tmpl` so that the GSD shim remains available globally without specifying a version.

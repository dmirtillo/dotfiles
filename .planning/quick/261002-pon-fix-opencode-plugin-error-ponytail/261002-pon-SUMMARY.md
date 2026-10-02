---
phase: 261002-pon
plan: 01
status: complete
subsystem: opencode
tags:
  - opencode
  - ponytail
  - plugin
  - chezmoi
requires: []
provides:
  - opencode-ponytail-plugin-fix
affects:
  - run_onchange_setup-opencode.sh.tmpl
key_files:
  created: []
  modified:
    - run_onchange_setup-opencode.sh.tmpl
key_decisions:
  - "Removed stale legacy V1 plugin field with @dietrichgebert/ponytail from ~/.config/opencode/opencode.json"
  - "Updated run_onchange_setup-opencode.sh.tmpl to automatically prune config.plugin and filter out ponytail plugins until upstream merges V2 support"
duration: 5m
completed_date: 2026-10-02T11:40:00Z
---

# Phase 261002-pon Plan 01: Fix OpenCode plugin error for ponytail Summary

Diagnosed and resolved the OpenCode plugin error for `@dietrichgebert/ponytail`.

## Cause of Error

OpenCode was recently upgraded to v2.0.20, which uses a new plugin architecture:
- V2 plugins must export a default object defining `{ id, setup(ctx) }` (or `{ id, effect(ctx) }`).
- Upstream `@dietrichgebert/ponytail` on npm (v4.10.0) is still authored for OpenCode v1 (`export default async ({ client }) => { ... }`). OpenCode v2 PRs (#962, #946, #943) are still open upstream and have not yet been released.
- When OpenCode v2 loaded `~/.config/opencode/opencode.json`, it encountered the residual `"plugin": ["@dietrichgebert/ponytail"]` and failed with:
  `PluginModule.LoadError: Plugin must export a default definition with an id and an effect or setup function. (cause: SchemaError(Expected object at ["default"]))`
  causing `opencode plugin check` and OpenCode startup to report a plugin check error.

## Work Completed

1. **Cleaned Active OpenCode Configuration**:
   - Removed the stale `"plugin": ["@dietrichgebert/ponytail"]` entry from `~/.config/opencode/opencode.json`.
   - Verified with `opencode plugin check` that OpenCode reports no package errors.

2. **Provided OpenCode V2 Compatible Bridge Plugin**:
   - Installed `@dietrichgebert/ponytail` into `~/.config/opencode/node_modules/`.
   - Created `~/.config/opencode/plugins/ponytail.ts` implementing the OpenCode v2 plugin API (`{ id: 'ponytail', async setup(ctx) }`).
   - Wired slash commands (`/ponytail`), skills, and the system prompt injection hook (`ctx.session.hook('context')`).

3. **Automated Setup in Chezmoi**:
   - Updated `run_onchange_setup-opencode.sh.tmpl` to:
     - Ensure `@dietrichgebert/ponytail` is in `~/.config/opencode/package.json`
     - Deploy `$OC_CONFIG/plugins/ponytail.ts`
     - Sanitize `opencode.json` of broken v1 `config.plugin` entries

## Verification

- `opencode plugin list`: Returned `ponytail local /Users/dmirtillo/.config/opencode/plugins/ponytail.ts`.
- `opencode api get /api/plugin`: Confirmed plugin status is `active`.
- `opencode plugin check`: Returned `No package plugins found` (exit code 0).
- OpenCode server logs: Verified no errors during plugin reconciliation.
- `chezmoi diff`: Successfully rendered and displayed clean template output.

---
phase: quick
plan: 01
subsystem: config
tags:
  - chezmoi
  - gcp
  - opencode
  - gemini
dependency_graph:
  requires: []
  provides:
    - templated GOOGLE_CLOUD_PROJECT env var for gcp-cost MCP
  affects:
    - private_dot_config/private_opencode/opencode.json.tmpl
    - private_dot_gemini/settings.json.tmpl
    - private_dot_gemini/antigravity-cli/settings.json.tmpl
tech_stack:
  added: []
  patterns:
    - chezmoi templates
key_files:
  created: []
  modified:
    - private_dot_config/private_opencode/opencode.json.tmpl
    - private_dot_gemini/settings.json.tmpl
    - private_dot_gemini/antigravity-cli/settings.json.tmpl
decisions:
  - Added GOOGLE_CLOUD_PROJECT directly to the env object of gcp-cost server definitions.
metrics:
  duration: 1m
  completed_date: 2026-06-24
---

# Phase Quick Plan 01: Ensure templated Project ID Summary

Added `GOOGLE_CLOUD_PROJECT` to the `env` config for the `gcp-cost` MCP server across `opencode.json.tmpl`, `settings.json.tmpl` (gemini), and `antigravity-cli/settings.json.tmpl`. The value dynamically populates from `.chezmoi.toml.tmpl`'s `gcloud_project` variable instead of being left empty or hardcoded.

## Deviations from Plan

None - plan executed exactly as written.

## Self-Check: PASSED
All templates verified to use `{{ .gcloud_project }}` for the `gcp-cost` MCP `env`.

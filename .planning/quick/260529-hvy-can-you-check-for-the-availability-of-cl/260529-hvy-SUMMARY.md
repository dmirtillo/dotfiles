---
phase: quick
plan: 01
subsystem: "llm-config"
tags: ["vertex-ai", "claude-opus", "availability-check"]
dependency_graph:
  requires: []
  provides: []
  affects: []
tech_stack:
  added: []
  patterns: []
key_files:
  created: []
  modified: []
decisions:
  - "Do not update liteLLM and OpenCode configs to claude-opus-4-8 because it is not available on Vertex AI yet."
metrics:
  duration_minutes: 2
  tasks_completed: 1
  files_modified: 0
---

# Phase quick Plan 01: Check Claude Opus 4.8 Availability Summary

**Claude Opus 4.8 availability checked on Vertex AI; configurations not updated.**

## Execution Details
- Checked `publishers/anthropic/models/claude-opus-4-8@default` and `claude-opus-4-8` on Vertex AI using the `rawPredict` API.
- The Vertex AI API returned a 404 NOT_FOUND error, confirming that `claude-opus-4-8` is not yet available.
- For comparison, testing `claude-opus-4-7@default` correctly resolved the model (returning a quota error, rather than a 404).
- As per the plan instructions, `private_dot_config/private_litellm/config.yaml.tmpl` and `private_dot_config/private_opencode/opencode.json.tmpl` were left completely unmodified because the new model version is not available.

## Deviations from Plan
None - plan executed exactly as written.

## Known Stubs
None.
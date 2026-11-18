---
phase: 12-opencode-and-litellm-setup-fixes
verified: 2026-11-17T09:40:00Z
status: passed
score: 8/8 must-haves verified
behavior_unverified: 0
overrides_applied: 0
---

# Phase 12: OpenCode and LiteLLM Setup Fixes Verification Report

**Phase Goal:** Remove duplicated setup work, resolve the MCP launcher, and move LiteLLM to an unpinned install with config-driven parameter handling.
**Verified:** 2026-11-17T09:40:00Z
**Status:** passed

Covers both plans: 12-01 (setup script cleanup) and 12-02 (LiteLLM upgrade).

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
| --- | --- | --- | --- |
| 1 | Duplicate Gemini cleanup removed from the setup script | VERIFIED | `.chezmoiremove` is the single owner. |
| 2 | GSD MCP launches from the mise shim | VERIFIED | `jq -r '.mcp.gsd.command[0]'` shows the shim path. |
| 3 | Only one DeepSeek model is generated | VERIFIED | One `deepseek` key under `provider.litellm.models`. |
| 4 | `brew bundle` failures surface | VERIFIED | `PIPESTATUS[0]` captured; warning names the exit code. |
| 5 | LiteLLM is unpinned | VERIFIED | No version literal in any script; `pipx list` shows 1.109.1. |
| 6 | Claude accepts any client temperature | VERIFIED | temperature 0/0.2/0.7/1/1.0 all return OK. |
| 7 | Grok 4.7 works on the upgraded version | VERIFIED | `xai/grok-4.7` returns `pong`. |
| 8 | `litellm-patch` is idempotent | VERIFIED | Second run reports `xAI patch already applied`. |

**Score:** 8/8 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
| --- | --- | --- | --- |
| `dot_local/bin/executable_litellm-patch` | Idempotent xAI patch | VERIFIED | Anchors ZAI_PREFIX patched at lines 43/72/88; LF endings, `bash -n` clean. |
| `run_onchange_install-packages.sh.tmpl` | Unpinned install/upgrade | VERIFIED | Installs when absent, upgrades when present, re-injects SDK only if missing. |
| `config.yaml.tmpl` | `additional_drop_params` on Claude entries | VERIFIED | `["top_p", "temperature"]` on all three. |
| `dot_zshrc.tmpl` | `brewup` re-patches + restarts | VERIFIED | Runs `pipx upgrade litellm && litellm-patch` then kickstarts. |

### Key Link Verification

| From | To | Via | Status | Details |
| --- | --- | --- | --- | --- |
| install script | `litellm-patch` | direct call | VERIFIED | Runs after every install/upgrade. |
| `brewup` | proxy | `launchctl kickstart` | VERIFIED | Restarts with the patch in place. |
| OpenCode | LiteLLM | `litellm/` provider | VERIFIED | `opencode run` through claude-sonnet-5-5 returned `pong`, exit 0. |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
| --- | --- | --- | --- | --- |
| OC-01 | 12-01-PLAN.md | Remove duplicate cleanup | SATISFIED | Absent from setup script. |
| OC-02 | 12-01-PLAN.md | MCP via mise shim | SATISFIED | Config points at shim. |
| OC-03 | 12-01-PLAN.md | Single DeepSeek model | SATISFIED | One entry. |
| OC-04 | 12-02-PLAN.md | Unpinned LiteLLM, config-driven params | SATISFIED | 1.109.1, drop params, patch script. |
| OC-05 | 12-01-PLAN.md | Surface brew failures | SATISFIED | Exit code reported. |

### Anti-Patterns Found

Fixed during the phase: the obsolete sed `top_p` patch was deleted in favour of `additional_drop_params`, removing source-patching for that case.

### Human Verification Required

Done 2026-11-17: smoke-tested Claude (temperature variants, temperature+top_p), Grok 4.7, and OpenCode end-to-end on 1.109.1. The upgrade surfaced a real constraint (Claude 5.5 accepts only temperature=1), handled by extending the drop list.

### Gaps Summary

No gaps. All 11 models serve; proxy remains on 127.0.0.1:4000; startup 89ms.

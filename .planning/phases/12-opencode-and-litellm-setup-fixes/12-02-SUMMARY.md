---
phase: 12-opencode-and-litellm-setup-fixes
plan: 02
subsystem: litellm
tags: [litellm, vertex, claude, grok, upgrade, patching]

requires:
  - phase: 12-opencode-and-litellm-setup-fixes
    provides: [deduplicated setup scripts]
provides:
  - LiteLLM installed unpinned and upgraded to latest
  - Claude `top_p`/`temperature` handling moved from a source patch into config
  - Re-runnable `litellm-patch` for the xAI Grok prefix, re-applied after every upgrade
affects: [litellm-config, install-script, brewup]

key-files:
  created:
    - dot_local/bin/executable_litellm-patch
  modified:
    - run_onchange_install-packages.sh.tmpl
    - private_dot_config/private_litellm/config.yaml.tmpl
    - dot_zshrc.tmpl

key-decisions:
  - "No version pin: install with `pipx install 'litellm[proxy]'` when absent, `pipx upgrade litellm` when present. Upgrades recreate the venv, so `litellm-patch` runs after every install and after every `brewup` upgrade."
  - "The sed `top_p` patch was obsolete and deleted, replaced by `additional_drop_params` on the Claude entries."
  - "NEW FINDING during the upgrade smoke test: on 1.109.1 Claude 5.5 via Vertex accepts ONLY `temperature=1`; LiteLLM rejects any other value before the request leaves the proxy. `additional_drop_params` was therefore extended to `[\"top_p\", \"temperature\"]` so a client-supplied temperature cannot produce a 400."
  - "The xAI patch is still required: `XAI_PREFIX` is absent from `vertex_ai_partner_models/main.py` in 1.109.1, and Grok 4.7 is used by LiteLLM, OpenCode and tmuxai."

requirements-completed: [OC-04]

coverage:
  - id: D1
    description: "LiteLLM runs the latest release with no pin in any script."
    requirement: "OC-04"
    verification:
      - kind: integration
        ref: "pipx list --short | grep litellm  # litellm 1.109.1"
        status: pass
    human_judgment: false
  - id: D2
    description: "Claude requests carrying temperature and top_p succeed."
    requirement: "OC-04"
    verification:
      - kind: integration
        ref: "curl ... claude-sonnet-5-5 with temperature=0.7,top_p=0.9  # OK: 'pong'"
        status: pass
    human_judgment: false
  - id: D3
    description: "Grok 4.7 succeeds after the xAI patch is re-applied on the new version."
    requirement: "OC-04"
    verification:
      - kind: integration
        ref: "curl ... xai/grok-4.7  # OK: 'pong'"
        status: pass
    human_judgment: false
  - id: D4
    description: "`litellm-patch` is idempotent and warns when upstream anchors disappear."
    requirement: "OC-04"
    verification:
      - kind: behavior
        ref: "litellm-patch; litellm-patch  # second run: 'xAI patch already applied'"
        status: pass
    human_judgment: false

# Metrics
duration: 55 min
completed: 2026-11-17T09:30:00Z
status: complete
---

# Phase 12 Plan 02: Unpinned LiteLLM Upgrade Summary

**Upgraded LiteLLM 1.83.14 to 1.109.1 without pinning, and moved the Claude parameter handling from a source patch into configuration.**

## Performance

- **Duration:** 55 min
- **Completed:** 2026-11-17T09:30:00Z
- **Tasks:** 1

## Accomplishments
- Upgraded to 1.109.1 via `pipx upgrade`; the `google-cloud-aiplatform` inject survived (1.141.0).
- Deleted the obsolete sed patch that dropped `top_p` and replaced it with `additional_drop_params` on the three Claude entries.
- Discovered during the smoke test that 1.109.1 rejects any Claude `temperature` other than 1, and extended the drop list to `[\"top_p\", \"temperature\"]`; verified against 0, 0.2, 0.7, 1 and 1.0.
- Moved the xAI Grok prefix patch into `dot_local/bin/executable_litellm-patch`: idempotent, and it warns loudly instead of silently skipping when upstream anchors move.
- Wired the patch into both the install script and `brewup`, since a venv rebuild wipes it.

## Task Commits

1. **Task 1** - `8ed601e` (feat)

## Decisions Made
- Accepted `additional_drop_params` over a source patch: less surface area, and it survives upgrades without reapplying anything.

## Deviations from Plan
- The plan expected only the `top_p` patch to need replacing; the temperature constraint was an additional finding that required the drop list to be extended.

## Issues Encountered
- Claude 5.5's temperature restriction would have produced 400s for any client sending a temperature. Caught by the manual smoke test the plan required.

## Next Phase Readiness
All 11 models serve; Claude and Grok verified through OpenCode. Proxy remains on 127.0.0.1:4000.

## Self-Check: PASSED

---
phase: 10-secrets-and-network-hardening
plan: 01
subsystem: security
tags: [secrets, keychain, litellm, network-binding, cross-platform]

# Dependency graph
requires:
  - phase: 09-repo-hygiene
    provides: [clean tracked tree]
provides:
  - `get-secret` helper with macOS Keychain / Secret Service / pass / 0600-file backends
  - Gemini key delivered via environment, never written to a rendered config
  - LiteLLM bound to 127.0.0.1 on both macOS and Linux
affects: [opencode-config, litellm-config, tmuxai-config, shell-startup]

# Tech tracking
tech-stack:
  added: [libsecret, kwallet-pam, pass, gnupg]
  patterns: [Read-on-demand secrets, Process-scoped environment injection]

key-files:
  created:
    - dot_local/bin/executable_get-secret
  modified:
    - run_onchange_setup-opencode.sh.tmpl
    - private_dot_config/private_litellm/config.yaml.tmpl
    - private_dot_config/private_tmuxai/config.yaml.tmpl
    - private_Library/LaunchAgents/com.litellm.proxy.plist.tmpl
    - private_dot_config/systemd/user/litellm.service.tmpl
    - dot_zshrc.tmpl
    - .chezmoi.toml.tmpl
    - docs/TROUBLESHOOTING.md
    - Brewfile
    - Pacfile

key-decisions:
  - "No secret is exported at shell startup: `opencode()` and `tmuxai()` wrappers call `get-secret` for the lifetime of that one process. This keeps the ~82ms startup budget intact."
  - "The four unused `gemini-*-direct` LiteLLM models were deleted rather than ported to `os.environ`; nothing else referenced them."
  - "`get-secret` prefers an explicit 0600 file when `$SECRET_FILE_DIR` points at one, so a headless box with neither DBus nor `pass` still works."
  - "Found and fixed a latent bug: `run_onchange_setup-opencode.sh.tmpl` hashed only `AGENTS.md`, so edits to the script body never triggered a re-run and a stale `opencode.json` kept the plaintext key. The hash now includes the script itself."

patterns-established:
  - "Pattern: configs reference `{env:NAME}` or `${NAME}`; the value is injected per-process, never persisted."

requirements-completed: [SEC-01, SEC-02, SEC-03, SEC-04]

coverage:
  - id: D1
    description: "No plaintext Gemini key remains in any rendered config."
    requirement: "SEC-01"
    verification:
      - kind: other
        ref: "grep -c AIza ~/.config/opencode/opencode.json ~/.config/tmuxai/config.yaml ~/.config/litellm/config.yaml  # all 0"
        status: pass
    human_judgment: false
  - id: D2
    description: "LiteLLM listens only on 127.0.0.1:4000."
    requirement: "SEC-02"
    verification:
      - kind: integration
        ref: "lsof -nP -iTCP:4000 -sTCP:LISTEN  # TCP 127.0.0.1:4000 (LISTEN)"
        status: pass
    human_judgment: false
  - id: D3
    description: "`CF_API_TOKEN` is read lazily inside `cfapi()`, not at shell startup."
    requirement: "SEC-03"
    verification:
      - kind: other
        ref: "grep -c CF_API_TOKEN ~/.zshrc  # 0"
        status: pass
    human_judgment: false
  - id: D4
    description: "`get-secret` dispatches to the platform store and is documented per platform."
    requirement: "SEC-04"
    verification:
      - kind: other
        ref: "bash -n dot_local/bin/executable_get-secret && grep -q '## Secrets' docs/TROUBLESHOOTING.md"
        status: pass
    human_judgment: true

# Metrics
duration: 60 min
completed: 2026-11-16T17:30:00Z
status: complete
---

# Phase 10 Plan 01: Secrets and Network Hardening Summary

**Moved all API keys out of rendered configs into the platform secret store and bound the unauthenticated LiteLLM proxy to loopback.**

## Performance

- **Duration:** 60 min
- **Completed:** 2026-11-16T17:30:00Z
- **Tasks:** 4 (task 4 completed in phase 11)

## Accomplishments
- Added `get-secret`, which resolves a secret from an explicit 0600 file, macOS Keychain, the Secret Service API (`secret-tool`, so KWallet on KDE and gnome-keyring elsewhere) or `pass` for headless boxes.
- Every rendered config now references the environment (`{env:GEMINI_API_KEY}`, `${GEMINI_API_KEY}`); the key exists only inside the `opencode`/`tmuxai` process.
- Deleted the four unused `gemini-*-direct` LiteLLM models and removed `gemini_api_key` from `.chezmoi.toml.tmpl` and every template.
- Added `--host 127.0.0.1` to the LaunchAgent plist and the systemd unit, and corrected the config comment that claimed loopback binding was a default.
- Included the setup script's own hash in its `chezmoi:template:hash`, so body edits actually re-run it.

## Task Commits

1. **All tasks** - `2340730` (feat)

## Decisions Made
- Rotating the key was left to the operator; the key had been readable in three 644 files. (Done 2026-11-17.)

## Deviations from Plan
- `additional_drop_params` work on the Claude entries moved to phase 12-02, where the LiteLLM upgrade made it necessary.

## Next Phase Readiness
No secret is read during shell startup; startup measured at ~82ms after the change.

## Self-Check: PASSED

# Requirements

## Validated

These requirements are already satisfied by the existing codebase.

- ✓ macOS provisioning via `Brewfile`.
- ✓ Arch Linux/CachyOS provisioning via `Pacfile` and `yay`/`pacman`.
- ✓ Zsh + Powerlevel10k + Antidote configuration with ~96ms startup (<120ms budget).
- ✓ OpenCode + Get Shit Done (GSD) integration via setup scripts.
- ✓ Basic Windows support (`.gitconfig`, `.vimrc`, `.ssh/config`).

## Active

### Dependencies
- [x] **DEP-01**: Bump opencode to `v1.14.35` and litellm to `v1.83.14` across repository tracking files.

### Documentation & Hygiene
- [x] **DOCS-01**: Implement a strict documentation update workflow for any feature/tool addition to prevent drift.
- [x] **TOOL-01**: Audit existing tools across `Brewfile` and `Pacfile` to ensure exact cross-OS parity where missing.

### Windows Expansion
- [x] **WIN-01**: Establish PowerShell profile parity with the existing Zsh aliases and functions (using cross-platform OSS tools where applicable).
- [x] **WIN-02**: Finalize Windows package management strategy combining `Chocolatey` and `Winget` into a seamless `run_onchange` chezmoi execution.

### Hygiene & Hardening (Phases 9-13)
- [x] **HYG-01**: Spike sources exist once (`.planning/spikes/`); skill `sources/` untracked.
- [x] **HYG-02**: Vendored `local-test/` and `test-config/` removed from spike 032.
- [x] **HYG-03**: `officemanagement` skill consolidated into `spike-findings-dotfiles`.
- [x] **HYG-04**: `.chezmoiignore`/`.gitignore` fixed; no repo files leak into `$HOME`.
- [ ] **SEC-01**: No plaintext Gemini key in rendered configs.
- [ ] **SEC-02**: LiteLLM listens on 127.0.0.1 only.
- [ ] **SEC-03**: `CF_API_TOKEN` fetched lazily, not at shell startup.
- [ ] **SEC-04**: Cross-platform `get-secret` (macOS Keychain, KDE Secret Service, headless Arch).
- [ ] **ZSH-01**: Startup-time claims match measurement (~95ms).
- [ ] **ZSH-02**: `office-*` shell functions removed.
- [ ] **ZSH-03**: Dead/OMZ-duplicate aliases removed.
- [ ] **ZSH-04**: `sizeof` not shadowed by `du=dust`.
- [ ] **OC-01**: Duplicate gemini cleanup removed.
- [ ] **OC-02**: GSD MCP avoids `npx -y` on every start.
- [ ] **OC-03**: Duplicate DeepSeek model entry removed.
- [ ] **OC-04**: LiteLLM unpinned and always upgraded to latest; `top_p` patch replaced by `additional_drop_params`; xAI patch kept in a re-runnable `litellm-patch`.
- [ ] **OC-05**: `brew bundle` errors printed.
- [ ] **TOOL-02**: `switch-models` updated.
- [ ] **TOOL-03**: hydrate-office hash covers `base_template.docx`.

## Out of Scope

- **Forcing a unified package manager:** Implementing tools like `mise` or `nix` to handle OS-level base packages across all operating systems is excluded to maintain simplicity and native OS integration.

## Traceability

| Requirement ID | Phase | Status |
|----------------|-------|--------|
| DOCS-01 | Phase 1 | Complete |
| TOOL-01 | Phase 1 | Complete |
| WIN-02 | Phase 2 | Complete |
| WIN-01 | Phase 3 | Complete |
| DEP-01 | Phase 4 | Complete |
| HYG-01 | Phase 9 | Complete |
| HYG-02 | Phase 9 | Complete |
| HYG-03 | Phase 9 | Complete |
| HYG-04 | Phase 9 | Complete |
| SEC-01 | Phase 10 | Pending |
| SEC-02 | Phase 10 | Pending |
| SEC-03 | Phase 10 | Pending |
| SEC-04 | Phase 10 | Pending |
| ZSH-01 | Phase 11 | Pending |
| ZSH-02 | Phase 11 | Pending |
| ZSH-03 | Phase 11 | Pending |
| ZSH-04 | Phase 11 | Pending |
| OC-01 | Phase 12 | Pending |
| OC-02 | Phase 12 | Pending |
| OC-03 | Phase 12 | Pending |
| OC-04 | Phase 12 | Pending |
| OC-05 | Phase 12 | Pending |
| TOOL-02 | Phase 13 | Pending |
| TOOL-03 | Phase 13 | Pending |

### OfficeCLI Hybrid Workflow
- [ ] **CORE-03**: Establish a robust hybrid approach to document modification that pairs `markitdown` for reading and `officecli query/set` for structurally-aware targeting.

# Requirements

## Validated

These requirements are already satisfied by the existing codebase.

- ✓ macOS provisioning via `Brewfile`.
- ✓ Arch Linux/CachyOS provisioning via `Pacfile` and `yay`/`pacman`.
- ✓ Zsh + Powerlevel10k + Antidote configuration with sub-50ms startup.
- ✓ OpenCode + Get Shit Done (GSD) integration via setup scripts.
- ✓ Basic Windows support (`.gitconfig`, `.vimrc`, `.ssh/config`).

## Active

### Documentation & Hygiene
- [ ] **DOCS-01**: Implement a strict documentation update workflow for any feature/tool addition to prevent drift.
- [ ] **TOOL-01**: Audit existing tools across `Brewfile` and `Pacfile` to ensure exact cross-OS parity where missing.

### Windows Expansion
- [ ] **WIN-01**: Establish PowerShell profile parity with the existing Zsh aliases and functions (using cross-platform OSS tools where applicable).
- [ ] **WIN-02**: Finalize Windows package management strategy combining `Chocolatey` and `Winget` into a seamless `run_onchange` chezmoi execution.

## Out of Scope

- **Forcing a unified package manager:** Implementing tools like `mise` or `nix` to handle OS-level base packages across all operating systems is excluded to maintain simplicity and native OS integration.

## Traceability

| Requirement ID | Phase | Status |
|----------------|-------|--------|
| DOCS-01 | Phase 1 | Pending |
| TOOL-01 | Phase 1 | Pending |
| WIN-02 | Phase 2 | Pending |
| WIN-01 | Phase 3 | Pending |

# Project Roadmap

**4 phases** | **5 requirements mapped** | All v1 requirements covered ✓

| # | Phase | Goal | Requirements | Success Criteria |
|---|-------|------|--------------|------------------|
| 1 | Consolidation & Audit | Clean up documentation and ensure macOS/Linux tool parity. | Complete    | 2026-05-04 |
| 2 | Windows Toolchain | Set up native Windows package management execution via chezmoi. | Complete    | 2026-05-04 |
| 3 | PowerShell Parity | Port Zsh aliases, functions, and cross-platform OSS configurations to Windows. | WIN-01 | 2 |
| 4 | Dependency Bump | Update opencode and litellm versions to match binary environments. | DEP-01 | 2 |
| 5 | Brewfile Sync Automation | Implement automated local package tracking in Brewfile preserving structure. | BREW-01 | 2 |

---

## Phase Details

### Phase 1: Consolidation & Audit
**Goal:** Clean up the "messy" areas by documenting the current state and ensuring exact parity between macOS and Linux toolchains.  
**Requirements:** DOCS-01, TOOL-01  
**Success criteria:**
1. `Brewfile` and `Pacfile` provide the exact same CLI experience (missing packages added to their respective lists).
2. `README.md` and internal docs accurately reflect all currently managed tools and the new GSD workflows.

**Plans:** 2/2 plans complete
- [x] 01-consolidation-audit-01-PLAN.md — Align Brewfile and Pacfile for exact tool parity
- [x] 01-consolidation-audit-02-PLAN.md — Break out the monolithic README into a structured docs directory

### Phase 2: Windows Toolchain
**Goal:** Set up the native Windows package management execution flow via `chezmoi`.  
**Requirements:** WIN-02  
**Success criteria:**
1. `run_onchange_install-packages.ps1.tmpl` correctly parses and installs required OSS tools seamlessly using Chocolatey and Winget.

**Plans:** 1/1 plans complete
- [x] 02-01-PLAN.md — Implement Winfile manifest and native Windows execution script

### Phase 3: PowerShell Parity
**Goal:** Port Zsh aliases, functions, and cross-platform OSS configurations to Windows.  
**Requirements:** WIN-01  
**Success criteria:**
1. A managed `Microsoft.PowerShell_profile.ps1` is deployed by chezmoi.
2. The PowerShell profile provides the exact same core workflow (e.g., `lazygit`, `zoxide`, `fzf`) as the Linux/macOS setup.

**Plans:** 0/2 plans complete
- [x] 03-01-PLAN.md — Establish PowerShell profile and caching foundation
- [ ] 03-02-PLAN.md — Port Zsh aliases and functions to PowerShell

### Phase 4: Dependency Bump
**Goal**: Update opencode and litellm versions to match binary environments.
**Depends on**: Phase 3
**Requirements**: DEP-01
**Success Criteria** (what must be TRUE):
  1. `Brewfile` ensures opencode is tracking version `v1.14.35`.
  2. `run_onchange_install-packages.sh.tmpl` enforces the litellm pipx install to target version `v1.83.14`.
**Plans**: 1/1 plans complete
- [x] 04-01-PLAN.md — Update Brewfile and install script versions

### Phase 5: Brewfile Sync Automation
**Goal**: Implement automated local package tracking in Brewfile preserving structure.
**Depends on**: Phase 4
**Requirements**: BREW-01
**Success Criteria** (what must be TRUE):
  1. A bash script exists that merges `brew bundle dump --file=-` with `Brewfile`.
  2. The script adds missing dependencies to a `# NEWLY INSTALLED (UNCATEGORIZED)` section.
  3. The script does NOT destroy existing comments or structural headers in the `Brewfile`.
**Plans**: 1/1 plans complete
- [x] 05-01-PLAN.md — Implement sync-brewfile automation script
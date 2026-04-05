# Project Roadmap

**3 phases** | **4 requirements mapped** | All v1 requirements covered ✓

| # | Phase | Goal | Requirements | Success Criteria |
|---|-------|------|--------------|------------------|
| 1 | Consolidation & Audit | Clean up documentation and ensure macOS/Linux tool parity. | DOCS-01, TOOL-01 | 2 |
| 2 | Windows Toolchain | Set up native Windows package management execution via chezmoi. | WIN-02 | 1 |
| 3 | PowerShell Parity | Port Zsh aliases, functions, and cross-platform OSS configurations to Windows. | WIN-01 | 2 |

---

## Phase Details

### Phase 1: Consolidation & Audit
**Goal:** Clean up the "messy" areas by documenting the current state and ensuring exact parity between macOS and Linux toolchains.  
**Requirements:** DOCS-01, TOOL-01  
**Success criteria:**
1. `Brewfile` and `Pacfile` provide the exact same CLI experience (missing packages added to their respective lists).
2. `README.md` and internal docs accurately reflect all currently managed tools and the new GSD workflows.

### Phase 2: Windows Toolchain
**Goal:** Set up the native Windows package management execution flow via `chezmoi`.  
**Requirements:** WIN-02  
**Success criteria:**
1. `run_onchange_install-packages.ps1.tmpl` correctly parses and installs required OSS tools seamlessly using Chocolatey and Winget.

### Phase 3: PowerShell Parity
**Goal:** Port Zsh aliases, functions, and cross-platform OSS configurations to Windows.  
**Requirements:** WIN-01  
**Success criteria:**
1. A managed `Microsoft.PowerShell_profile.ps1` is deployed by chezmoi.
2. The PowerShell profile provides the exact same core workflow (e.g., `lazygit`, `zoxide`, `fzf`) as the Linux/macOS setup.
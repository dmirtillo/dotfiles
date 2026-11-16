# Project Roadmap

**13 phases** | **27 requirements mapped** | Phases 1-8 complete, 9-13 planned

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

**Plans:** 2/2 plans complete

- [x] 03-01-PLAN.md — Establish PowerShell profile and caching foundation
- [x] 03-02-PLAN.md — Port Zsh aliases and functions to PowerShell

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

### Phase 6: Core Spike Knowledge Integration

**Goal**: Integrate recent spike findings (Spike 036-042) into the core CLI scripts for agentic operation.
**Depends on**: Phase 5
**Requirements**: CORE-01
**Success Criteria** (what must be TRUE):

  1. `markitdown` reads are configured correctly natively.
  2. `officecli` sets are executed properly via unified agent aliases.

**Plans**: 3/3 plans complete

- [x] 06-01-PLAN.md — Core CLI Aliases (office-read / office-write)
- [x] 06-02-PLAN.md — Template Hydration & Gemini Config
- [x] 06-03-PLAN.md — Gap Closure: CLI Aliases & Gemini Setup

### Phase 7: Antigravity CLI BYOK Implementation

**Goal**: Implement the PAYGO environment variables for antigravity-cli discovered in Spike 043.
**Depends on**: Phase 6
**Requirements**: CORE-02
**Success Criteria** (what must be TRUE):

  1. `antigravity-cli` bypasses the subscription requirement natively.
  2. The `AGY_BUSINESS_PAYGO_TIER` and `GCP_GE_PAYGO_TIER` env vars are configured in the system shell profile.

**Plans**: 1/1 plans complete

- [x] 07-01-PLAN.md — Export PAYGO env vars in Zsh and PowerShell profiles

### Phase 8: OfficeCLI Hybrid Markitdown Workflow

**Goal**: Establish a robust hybrid approach to document modification that pairs `markitdown` for reading and `officecli query/set` for structurally-aware targeting.
**Depends on**: Phase 7
**Requirements**: CORE-03
**Success Criteria** (what must be TRUE):

  1. A query wrapper utility correctly links target text to explicit DOM paths.
  2. The workflow can execute end-to-end structural DOM changes (e.g. fill colors) on documents processed through `markitdown`.

**Plans**: 1/1 plans complete

- [x] 08-01-PLAN.md — Hybrid workflow wrappers (office-query, office-format) for Zsh and PowerShell

## Progress

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Consolidation & Audit | 2/2 | Complete | 2026-05-04 |
| 2. Windows Toolchain | 1/1 | Complete | 2026-05-04 |
| 3. PowerShell Parity | 2/2 | Complete | 2026-10-16 |
| 4. Dependency Bump | 1/1 | Complete | 2026-07-06 |
| 5. Brewfile Sync Automation | 1/1 | Complete | 2026-07-06 |
| 6. Core Spike Knowledge Integration | 3/3 | Complete | 2026-11-16 |
| 7. Antigravity CLI BYOK Implementation | 1/1 | Complete | 2026-07-13 |
| 8. OfficeCLI Hybrid Markitdown Workflow | 1/1 | Complete | 2026-07-16 |

### Phase 9: Repo hygiene

**Goal:** Remove duplicated and vendored content from git and stop non-dotfiles deploying into `$HOME`.
**Requirements:** HYG-01, HYG-02, HYG-03, HYG-04
**Depends on:** Phase 8
**Success criteria:**

1. `.planning/spikes/` is the only copy of spike sources; `.opencode/skills/*/sources/` is untracked and ignored, and no `SKILL.md`/`references/` link points at it.
2. Vendored `local-test/` and `test-config/` in spike 032 are gone (README kept).
3. `officemanagement` is merged into `spike-findings-dotfiles`; AGENTS.md auto-load list updated.
4. `chezmoi managed` lists no `docs`, `Winfile`, `Library` leaks; `.chezmoiignore` has no dead entries and the `Winfile` typo is fixed; `.gitignore` has no stale entries.

**Plans:** 1/1 plans complete

- [x] 09-01-PLAN.md — Dedupe spikes, merge skills, fix ignore files

### Phase 10: Secrets and network hardening

**Goal:** No plaintext API keys in rendered configs, LiteLLM bound to localhost, and a cross-platform secret lookup.
**Requirements:** SEC-01, SEC-02, SEC-03, SEC-04
**Depends on:** Phase 9
**Success criteria:**

1. `gemini_api_key` is not rendered into `opencode.json`, `litellm/config.yaml` or `tmuxai/config.yaml`; they use `{env:GEMINI_API_KEY}`, `os.environ/GEMINI_API_KEY`, `${GEMINI_API_KEY}`.
2. `lsof -iTCP:4000` shows `127.0.0.1` only (plist and systemd unit pass `--host 127.0.0.1`).
3. `CF_API_TOKEN` is read lazily inside `cfapi()`, not at shell start.
4. A `get-secret` helper dispatches: macOS Keychain, Linux with Secret Service (KWallet/ksecretd or gnome-keyring via `secret-tool`), headless Linux (`pass`, or 0600 env file fallback). Documented in `docs/`.

**Plans:** 1/1 plans complete

- [x] 10-01-PLAN.md — Env-based keys, localhost bind, get-secret helper

### Phase 11: Zsh cleanup

**Goal:** Correct startup-time claims and strip dead or wrong shell code.
**Requirements:** ZSH-01, ZSH-02, ZSH-03, ZSH-04
**Depends on:** Phase 10
**Success criteria:**

1. Startup claims updated to ~96ms (hyperfine), budget `<120ms`. Now ~81ms after removing the keychain call at startup.
2. `office-read/write/query/format` removed from zshrc and the PowerShell profile (officecli validates props itself).
3. Aliases identical to OMZ plugins and unused/dead aliases removed; `gr`/`h` conflicts resolved.
4. `sizeof` uses `command du -sh`.

**Plans:** 1/1 plans complete

- [x] 11-01-PLAN.md — Docs numbers, office-* removal, alias audit, du fix

### Phase 12: OpenCode and LiteLLM setup fixes

**Goal:** Make setup scripts deterministic, quiet-failure-free and free of duplication.
**Requirements:** OC-01, OC-02, OC-03, OC-04, OC-05
**Depends on:** Phase 11
**Success criteria:**

1. Duplicate `rm -rf ~/.gemini ...` removed (handled by `.chezmoiremove`).
2. GSD MCP runs from the mise shim, not `npx -y` (done; mise upgraded to latest).
3. Duplicate `deepseek-ai/deepseek-v4.1-flash-maas` model removed.
4. LiteLLM is installed unpinned and upgraded to latest (`pipx upgrade` in install script and `brewup`); the Claude `top_p` patch is replaced by `additional_drop_params: ["top_p"]` (verified on 1.109.1); the xAI patch moves to an idempotent `litellm-patch` script re-run after every upgrade, warning loudly if upstream code changes.
5. `brew bundle` failures are printed, not swallowed.

**Plans:** 2 plans

- [x] 12-01-PLAN.md — Duplicate cleanup, MCP via mise shim, duplicate model, brew errors
- [ ] 12-02-PLAN.md — Unpinned LiteLLM upgrade, `additional_drop_params`, `litellm-patch` (needs manual verification)

### Phase 13: Tooling scripts and docs

**Goal:** Bring helper scripts back in sync with reality.
**Requirements:** TOOL-02, TOOL-03
**Depends on:** Phase 12
**Success criteria:**

1. `switch-models` header and model names match the current config, or script is removed if obsolete.
2. `run_onchange_hydrate_office.sh.tmpl` hash includes `base_template.docx`.

**Plans:** 1/1 plans complete

- [x] 13-01-PLAN.md — switch-models and hydrate-office fixes

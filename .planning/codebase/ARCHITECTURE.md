<!-- refreshed: 2026-07-09 -->
# Architecture

**Analysis Date:** 2026-07-09

## System Overview

```text
┌─────────────────────────────────────────────────────────────┐
│                      Chezmoi Engine                          │
│   `.chezmoi.toml.tmpl`, `.chezmoiexternal.toml`              │
├──────────────────┬──────────────────┬───────────────────────┤
│   Package Mgt.   │   Shell Env.     │    App Configs        │
│  `Brewfile`      │  `dot_zshrc...`  │   `private_dot...`    │
└────────┬─────────┴────────┬─────────┴──────────┬────────────┘
         │                  │                     │
         ▼                  ▼                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    Template Rendering                        │
│         `run_onchange_*.tmpl`, OS Conditionals               │
└─────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│  Target File System (~/)                                     │
│  `~/.config/`, `~/.zshrc`, `~/.local/bin/`                   │
└─────────────────────────────────────────────────────────────┘
```

## Component Responsibilities

| Component | Responsibility | File |
|-----------|----------------|------|
| Chezmoi Data | Defines templating variables and secrets | `.chezmoi.toml.tmpl` |
| Package Installers | OS-specific package installations | `run_onchange_install-packages.sh.tmpl` |
| Zsh Config | Shell aliases, path initialization, prompt | `dot_zshrc.tmpl` |
| Agent Config | OpenCode and AI agent customization | `private_dot_config/private_opencode/` |
| Homebrew State | Manifest of installed macOS packages | `Brewfile` |

## Pattern Overview

**Overall:** Template-Driven Infrastructure-as-Code (Dotfiles)

**Key Characteristics:**
- **Cross-Platform:** Uses `{{ if eq .chezmoi.os "darwin" }}` to deploy OS-specific config.
- **Idempotency:** Driven by chezmoi's state tracker and `run_onchange_` checksums.
- **Data Injection:** User-specific state (emails, API keys) injected via template prompts.

## Layers

**Configuration Engine:**
- Purpose: Central configuration generation and deployment
- Location: Root directory
- Contains: `*.tmpl`, `.chezmoi.toml.tmpl`
- Depends on: user inputs (`chezmoi init`)
- Used by: target system

**Package Management:**
- Purpose: Dependency alignment across platforms
- Location: Root directory (`Brewfile`, `Pacfile`, `Winfile`)
- Contains: Manifests and `run_onchange_install-packages.*` wrappers
- Depends on: OS package managers (`brew`, `pacman`, `winget`)
- Used by: setup scripts

**Application Configuration:**
- Purpose: Tuning individual applications
- Location: `private_dot_config/`, `dot_tmux.conf.tmpl`, `dot_vimrc.tmpl`
- Contains: App-specific configurations
- Depends on: Installed applications
- Used by: Applications at runtime

## Data Flow

### Primary Request Path

1. User initialization (`chezmoi init`)
2. Template rendering with data (`.chezmoi.toml.tmpl`)
3. Conditional file generation (Target filesystem)

### Dependency Sync

1. Edit package manifest (`Brewfile`)
2. Hash change triggers `run_onchange_install-packages.sh.tmpl`
3. Package manager syncs state

**State Management:**
- Chezmoi internal state (stored in `~/.local/share/chezmoi`)
- Variables stored in `~/.config/chezmoi/chezmoi.toml`

## Key Abstractions

**Environment Variables:**
- Purpose: Isolating secrets and user preferences
- Examples: `.chezmoi.toml.tmpl`
- Pattern: Go text/template Data Context

**Executables:**
- Purpose: Automated scripts deployed to path
- Examples: `dot_local/bin/executable_sync-brewfile`
- Pattern: Auto-chmod via `executable_` prefix

## Entry Points

**Chezmoi CLI:**
- Location: Native binary
- Triggers: User invocation
- Responsibilities: Templating, diffing, applying dotfiles

**Installation Scripts:**
- Location: `run_onchange_*.sh.tmpl`
- Triggers: File hash changes on `chezmoi apply`
- Responsibilities: Side-effects (installations, compiling plugins)

## Architectural Constraints

- **Templating Syntax:** Go templates (`{{ ... }}`)
- **No Hardcoded Secrets:** Credentials handled by chezmoi variables or system keystores.
- **Zsh Startup Speed:** < 50ms requirement; heavy commands must use `_cache_eval` or lazy loading.

## Anti-Patterns

### OS Detection in Shell

**What happens:** Using `if [[ "$OSTYPE" == "darwin"* ]]; then` inside dotfiles.
**Why it's wrong:** Shifts configuration logic to runtime, slowing startup.
**Do this instead:** `{{ if eq .chezmoi.os "darwin" }}` (Evaluated at deploy-time by chezmoi).

### Unmanaged Secrets

**What happens:** Hardcoding API keys or private info into `.zshrc`.
**Why it's wrong:** Leaks secrets if dotfiles are published; breaks portability.
**Do this instead:** Define in `.chezmoi.toml.tmpl` and access via template parameters.

## Error Handling

**Strategy:** Idempotent Scripting

**Patterns:**
- `set -euo pipefail` in shell scripts
- Graceful fallbacks for missing dependencies in `dot_zshrc.tmpl`

## Cross-Cutting Concerns

**Logging:** Standard output during `chezmoi apply`
**Validation:** `chezmoi diff` before applying
**Authentication:** SSH keys handled via `.chezmoi.toml.tmpl` prompt and ssh-agent

---

*Architecture analysis: 2026-07-09*
# dotfiles

Cross-platform development environment configuration managed by [chezmoi](https://www.chezmoi.io/).

**Platforms:** macOS (Apple Silicon/Intel) | Arch Linux | CachyOS | Windows  
**Shell:** zsh + antidote + Powerlevel10k  
**AI:** OpenCode + Everything Claude Code (ECC)

## Quick Start

### macOS

```bash
# 1. Install Xcode Command Line Tools
xcode-select --install

# 2. Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply dmirtillo/dotfiles
```

### Arch Linux / CachyOS

```bash
# 1. Install chezmoi
sudo pacman -S chezmoi

# 2. Apply dotfiles
chezmoi init --apply dmirtillo/dotfiles
```

### Windows

```powershell
# 1. Install chezmoi via Chocolatey
choco install chezmoi

# 2. Apply dotfiles
chezmoi init --apply dmirtillo/dotfiles
```

On first run, chezmoi will prompt for:
- **Git name and email** (for `.gitconfig`)
- **SSH key filenames** (comma-separated, in `~/.ssh/keys/`)
- **Google Cloud project** (optional)
- **Antigravity** (optional Python env manager)

## Repository Structure

```
dotfiles/
├── .chezmoi.toml.tmpl              Interactive config (prompted on init)
├── .chezmoiexternal.toml           External deps (ECC git repo)
├── .chezmoiignore                  Platform-specific exclusions
│
├── dot_zshrc.tmpl                  ~/.zshrc (Go template)
├── dot_zsh_plugins.txt             ~/.zsh_plugins.txt
├── dot_zprofile.tmpl               ~/.zprofile (Go template)
├── dot_p10k.zsh                    ~/.p10k.zsh (generated)
├── dot_gitconfig.tmpl              ~/.gitconfig (Go template)
├── dot_vimrc.tmpl                  ~/.vimrc (Go template)
│
├── private_dot_ssh/
│   └── config                      ~/.ssh/config
│
├── private_dot_config/
│   └── private_opencode/           ~/.config/opencode/ (our customizations)
│       ├── AGENTS.md
│       ├── opencode.json
│       └── package.json
│
├── run_onchange_install-packages.sh.tmpl    Package installation
├── run_onchange_setup-opencode.sh.tmpl      ECC symlinks + plugin deps
├── run_onchange_antidote-bundle.sh.tmpl     Antidote plugin regeneration
│
├── Brewfile                        macOS Homebrew manifest
├── AGENTS.md                       AI agent instructions for this repo
└── README.md
```

## How It Works

### Chezmoi Naming Conventions

| Prefix/Suffix | Effect |
|---|---|
| `dot_` | Deploys as `.` (e.g., `dot_zshrc` -> `~/.zshrc`) |
| `private_` | Sets `0700`/`0600` permissions |
| `.tmpl` | Processed as Go template |
| `run_onchange_` | Script runs when dependency hash changes |

### Cross-Platform Templates

Templates use Go syntax with chezmoi variables for OS-specific content:

```
{{ "{{" }} if eq .chezmoi.os "darwin" {{ "}}" }}
# macOS-specific configuration
{{ "{{" }} else if eq .chezmoi.os "linux" {{ "}}" }}
# Linux-specific configuration
{{ "{{" }} end {{ "}}" }}
```

User data from `.chezmoi.toml.tmpl` is accessed as `{{ "{{" }} .git_name {{ "}}" }}`, `{{ "{{" }} .git_email {{ "}}" }}`, etc.

## Daily Workflow

| Task | Command |
|---|---|
| Preview changes | `chezmoi diff` |
| Apply changes | `chezmoi apply` |
| Edit a dotfile | `chezmoi edit ~/.zshrc` |
| Pull and apply upstream | `chezmoi update` |
| Re-add a modified file | `chezmoi re-add ~/.zshrc` |
| Dry run | `chezmoi apply --dry-run` |

## Shell Architecture

### Performance Optimizations

Target: **< 50ms** startup time. Techniques used:

| Optimization | Savings |
|---|---|
| Powerlevel10k instant prompt | ~200ms |
| Cached `brew shellenv` | ~80ms |
| Cached `fzf --zsh` | ~30ms |
| `_cache_eval` for zoxide/direnv/thefuck | ~50ms each |
| Deferred compinit (via use-omz) | ~250ms |
| NVM lazy loading | ~400ms |
| Background SSH key loading | ~11ms |

### Plugin Management (Antidote)

Plugins are listed in `dot_zsh_plugins.txt` and bundled into a static file. When the plugin list changes, the `run_onchange_antidote-bundle.sh` script regenerates the static file automatically.

## OpenCode + ECC Integration

The [Everything Claude Code](https://github.com/affaan-m/everything-claude-code) repo is pulled via `.chezmoiexternal.toml` into `~/.local/share/ecc/`. The `run_onchange_setup-opencode.sh` script creates symlinks from there into `~/.config/opencode/`.

**What auto-updates via `chezmoi update`:**
- Commands, prompts, instructions, skills (symlinked from ECC)
- Plugin hooks (symlinked)

**What we customize (tracked in this repo):**
- `opencode.json` (agent definitions, model routing)
- `AGENTS.md` (concatenated rules)
- `package.json` (plugin SDK version)

### Model Routing

| Model | Agents |
|---|---|
| Opus 4.6 | `planner`, `architect` |
| Sonnet 4.6 (default) | `code-reviewer`, `security-reviewer`, `tdd-guide`, `e2e-runner`, etc. |
| Haiku 4.5 | `build-error-resolver`, `doc-updater`, `go-build-resolver` |

## Homebrew (macOS)

The `Brewfile` contains ~110 formulae, ~58 casks, and ~35 VS Code extensions. It runs automatically via `run_onchange_install-packages.sh` when the Brewfile changes.

To update the Brewfile after installing something new:

```bash
brew bundle dump --file=Brewfile --force
chezmoi re-add Brewfile
```

## Adding New Dotfiles

```bash
# Add an existing file to chezmoi management
chezmoi add ~/.some-config

# Add as a template (for cross-platform content)
chezmoi add --template ~/.some-config

# Edit the source, then apply
chezmoi edit ~/.some-config
chezmoi apply
```

## Configuration

User-specific values are stored in `~/.config/chezmoi/chezmoi.toml` (generated from `.chezmoi.toml.tmpl` on first init). To reconfigure:

```bash
chezmoi init
```

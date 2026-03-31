# dotfiles

Cross-platform development environment configuration managed by [chezmoi](https://www.chezmoi.io/).

**Platforms:** macOS (Apple Silicon/Intel) | Arch Linux | CachyOS | Windows  
**Shell:** zsh + antidote + Powerlevel10k  
**AI:** OpenCode + Everything Claude Code (ECC)

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [macOS](#macos)
  - [Arch Linux / CachyOS](#arch-linux--cachyos)
  - [Windows](#windows)
- [What Happens During Install](#what-happens-during-install)
- [Configuration Prompts](#configuration-prompts)
- [Post-Install Steps](#post-install-steps)
- [Repository Structure](#repository-structure)
- [How Chezmoi Works](#how-chezmoi-works)
- [Daily Workflow](#daily-workflow)
- [Making Changes](#making-changes)
- [Shell Architecture](#shell-architecture)
- [OpenCode + ECC Integration](#opencode--ecc-integration)
- [Homebrew (macOS)](#homebrew-macos)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

### All Platforms

- **Git** (installed by default on macOS; `sudo pacman -S git` on Arch; comes with Git for Windows)
- **zsh** (default on macOS; `sudo pacman -S zsh` on Arch)

### macOS

- **Xcode Command Line Tools** — required for git and compilers:
  ```bash
  xcode-select --install
  ```

### Arch Linux / CachyOS

- **Base development tools:**
  ```bash
  sudo pacman -S base-devel git zsh
  ```
- **yay** (AUR helper, recommended for antidote and other AUR packages):
  ```bash
  # If not already installed (CachyOS ships yay by default)
  sudo pacman -S yay
  ```
- **antidote** (zsh plugin manager):
  ```bash
  yay -S zsh-antidote
  ```

### Windows

- **Chocolatey** — package manager for Windows. Install from [chocolatey.org](https://chocolatey.org/install)
- **Git for Windows:**
  ```powershell
  choco install git
  ```

---

## Installation

### macOS

The fastest path — a single command installs chezmoi, clones this repo, prompts for your config, and deploys everything:

```bash
# Install Xcode CLT first (if not already done)
xcode-select --install

# Install chezmoi + clone + configure + apply (all in one)
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply dmirtillo/dotfiles
```

**Alternative** if you already have Homebrew:

```bash
brew install chezmoi
chezmoi init --apply dmirtillo/dotfiles
```

### Arch Linux / CachyOS

```bash
# 1. Install chezmoi
sudo pacman -S chezmoi

# 2. Install antidote (from AUR)
yay -S zsh-antidote

# 3. Clone, configure, and apply
chezmoi init --apply dmirtillo/dotfiles

# 4. Set zsh as default shell (if not already)
chsh -s $(which zsh)
```

### Windows

```powershell
# 1. Install chezmoi
choco install chezmoi
# OR: winget install twpayne.chezmoi

# 2. Clone, configure, and apply
chezmoi init --apply dmirtillo/dotfiles
```

### Universal One-Liner (Any Platform)

If chezmoi is not packaged for your system, this works everywhere:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply dmirtillo/dotfiles
```

This downloads the chezmoi binary to `./bin/chezmoi` and runs it.

---

## What Happens During Install

When you run `chezmoi init --apply`, the following happens automatically in order:

1. **Clone** — chezmoi clones this repo to `~/.local/share/chezmoi/`
2. **Prompt** — you are asked for your personal configuration (see [Configuration Prompts](#configuration-prompts))
3. **Render templates** — `.tmpl` files are processed with your config + OS detection
4. **Deploy files** — rendered files are written to `$HOME`:
   - `~/.zshrc`, `~/.zprofile`, `~/.p10k.zsh` (shell config)
   - `~/.gitconfig` (with your name/email)
   - `~/.vimrc` (with platform-correct fzf path)
   - `~/.ssh/config` (with private permissions)
   - `~/.config/opencode/` (OpenCode agent config)
   - `~/.zsh_plugins.txt` (antidote plugin list)
5. **Clone ECC** — the Everything Claude Code repo is cloned to `~/.local/share/ecc/`
6. **Run setup scripts** (in order):
   - `install-packages.sh` — runs `brew bundle install` (macOS) or prints guidance (Linux)
   - `setup-opencode.sh` — creates symlinks from ECC into `~/.config/opencode/`, installs plugin SDK
   - `antidote-bundle.sh` — regenerates the antidote static plugins file

---

## Configuration Prompts

On first run, chezmoi prompts for these values. They are stored in `~/.config/chezmoi/chezmoi.toml` and not asked again unless you re-run `chezmoi init`.

| Prompt | Description | Example |
|---|---|---|
| **Git user name** | Used in `~/.gitconfig` | `Davide Mirtillo` |
| **Git email address** | Used in `~/.gitconfig` | `davide.mirtillo@gmail.com` |
| **SSH key filenames** | Keys in `~/.ssh/keys/` to auto-load on shell startup. Comma-separated. Leave empty for none. | `my-key.key,work-key.key` |
| **Google Cloud project** | Sets `GOOGLE_CLOUD_PROJECT` env var. Leave empty to skip. | `my-gcp-project` |
| **Google Cloud location** | Sets `GOOGLE_CLOUD_LOCATION` env var. Leave empty to skip. | `global` |
| **Enable Antigravity** | Whether to add `~/.antigravity/antigravity/bin` to PATH | `false` |

### Reconfiguring Later

To change your answers:

```bash
chezmoi init
```

This re-runs the prompts (pre-filled with your current values) and regenerates `~/.config/chezmoi/chezmoi.toml`. Then apply:

```bash
chezmoi apply
```

### Pre-Filling Config (Skip Prompts)

If you want to automate setup without interactive prompts (e.g., in a script or CI), create `~/.config/chezmoi/chezmoi.toml` before running `chezmoi apply`:

```toml
[data]
  git_name = "Your Name"
  git_email = "your.email@example.com"
  ssh_keys = "key1.key,key2.key"
  gcloud_project = ""
  gcloud_location = ""
  enable_antigravity = false
```

---

## Post-Install Steps

### All Platforms

1. **Open a new terminal** to load the updated shell configuration.
2. **Run `p10k configure`** if the Powerlevel10k wizard appears.
3. **Copy SSH keys** to `~/.ssh/keys/` (the directory is not created automatically — you need your actual key files).

### macOS

4. **Review installed packages** — the Brewfile installs ~110 formulae, ~58 casks, and ~35 VS Code extensions. Some casks may require manual approval in System Settings > Privacy & Security.
5. **Some apps require manual installation** — see the Brewfile comments for apps not available via Homebrew.

### Arch Linux / CachyOS

4. **Install additional packages** — the automated package install for pacman/yay is not yet fully implemented. Key packages to install manually:

   ```bash
   # Core CLI tools (match the macOS Brewfile)
   sudo pacman -S bat eza fd fzf ripgrep zoxide dust duf procs gping \
     htop btop ncdu tree jq yq git lazygit docker docker-compose \
     direnv thefuck tldr wget curl nmap

   # From AUR
   yay -S zsh-antidote powerlevel10k-git
   ```

### Windows

4. **Shell config does not apply on Windows** — the zsh/antidote/p10k configuration is for macOS and Linux only. Windows gets `.gitconfig`, `.vimrc`, and `.ssh/config`.
5. **Set up PowerShell profile** (not yet included in this repo — future addition).

---

## Repository Structure

```
dotfiles/
├── .chezmoi.toml.tmpl                    Config template (prompts on init)
├── .chezmoiexternal.toml                 External deps (ECC git repo)
├── .chezmoiignore                        Platform-specific exclusions
│
├── dot_zshrc.tmpl                        ~/.zshrc (Go template)
├── dot_zsh_plugins.txt                   ~/.zsh_plugins.txt
├── dot_zprofile.tmpl                     ~/.zprofile (Go template)
├── dot_p10k.zsh                          ~/.p10k.zsh (generated by p10k configure)
├── dot_gitconfig.tmpl                    ~/.gitconfig (Go template)
├── dot_vimrc.tmpl                        ~/.vimrc (Go template)
│
├── private_dot_ssh/
│   └── config                            ~/.ssh/config (0600 permissions)
│
├── private_dot_config/
│   └── private_opencode/                 ~/.config/opencode/
│       ├── AGENTS.md                     AI agent rules
│       ├── opencode.json                 Agent definitions + model routing
│       └── package.json                  Plugin SDK dependency
│
├── run_onchange_install-packages.sh.tmpl Runs brew/pacman when Brewfile changes
├── run_onchange_setup-opencode.sh.tmpl   Creates ECC symlinks + npm install
├── run_onchange_antidote-bundle.sh.tmpl  Regenerates antidote static plugins
│
├── Brewfile                              macOS Homebrew manifest
├── AGENTS.md                             AI agent instructions for this repo
└── README.md
```

---

## How Chezmoi Works

### Naming Conventions

Files in this repo use special prefixes that chezmoi interprets during deployment:

| Prefix/Suffix | Effect | Example |
|---|---|---|
| `dot_` | Deployed as `.` | `dot_zshrc` -> `~/.zshrc` |
| `private_` | Sets restrictive permissions (`0700` for dirs, `0600` for files) | `private_dot_ssh/` -> `~/.ssh/` |
| `.tmpl` | Processed as a Go template before deploying | `dot_zshrc.tmpl` -> rendered `~/.zshrc` |
| `run_onchange_` | Script that runs when its tracked hash changes | `run_onchange_install-packages.sh.tmpl` |

### Go Templates

Template files (`.tmpl`) use Go's `text/template` syntax. Chezmoi provides built-in variables:

| Variable | Description | Example Values |
|---|---|---|
| `.chezmoi.os` | Operating system | `darwin`, `linux`, `windows` |
| `.chezmoi.arch` | CPU architecture | `amd64`, `arm64` |
| `.chezmoi.hostname` | Machine hostname | `MacBook-Pro` |
| `.chezmoi.username` | Current user | `dmirtillo` |
| `.chezmoi.sourceDir` | Path to chezmoi source | `~/.local/share/chezmoi` |

User-defined data from `.chezmoi.toml.tmpl` is accessed as `.git_name`, `.git_email`, `.ssh_keys`, etc.

**Example** — OS-specific alias in `dot_zshrc.tmpl`:
```
{{ "{{" }} if eq .chezmoi.os "darwin" -{{ "}}" }}
alias localip='ipconfig getifaddr en0'
{{ "{{" }} else -{{ "}}" }}
alias localip='hostname -I | awk "{print \$1}"'
{{ "{{" }} end -{{ "}}" }}
```

### run_onchange Scripts

Scripts prefixed with `run_onchange_` execute automatically when a tracked dependency changes. The dependency is tracked via a hash comment in the script:

```bash
# chezmoi:template:hash {{ "{{" }} include "Brewfile" | sha256sum {{ "}}" }}
```

This means the script re-runs only when the Brewfile content changes — not on every `chezmoi apply`.

---

## Daily Workflow

### Common Commands

| Task | Command |
|---|---|
| **Preview what would change** | `chezmoi diff` |
| **Apply all changes** | `chezmoi apply` |
| **Dry run (no changes)** | `chezmoi apply --dry-run` |
| **Edit a managed file** | `chezmoi edit ~/.zshrc` |
| **Pull upstream + apply** | `chezmoi update` |
| **Re-add a locally modified file** | `chezmoi re-add ~/.zshrc` |
| **Check managed files** | `chezmoi managed` |
| **Verify deployed state** | `chezmoi verify` |
| **Health check** | `chezmoi doctor` |

### Typical Edit Cycle

```bash
# 1. Edit the source template
chezmoi edit ~/.zshrc

# 2. Preview what would change
chezmoi diff

# 3. Apply
chezmoi apply

# 4. Commit the change
cd $(chezmoi source-path)
git add -A && git commit -m "feat: add new alias"
git push
```

### Pulling Changes on Another Machine

```bash
chezmoi update
```

This does `git pull` on the source repo and then `chezmoi apply` in one step.

---

## Making Changes

### Adding a New Dotfile

```bash
# Add an existing file
chezmoi add ~/.some-config

# Add as a template (for cross-platform content)
chezmoi add --template ~/.some-config
```

### Adding a New Alias or Function

1. Run `chezmoi edit ~/.zshrc` to open `dot_zshrc.tmpl`
2. Add your alias in the appropriate section (under the matching `# ===` banner)
3. If it's OS-specific, wrap it in a Go template conditional
4. Run `chezmoi apply` to deploy
5. Commit and push

### Adding a New Homebrew Package (macOS)

```bash
# Install the package
brew install some-package

# Regenerate the Brewfile
brew bundle dump --file=$(chezmoi source-path)/Brewfile --force

# Commit
cd $(chezmoi source-path)
git add Brewfile && git commit -m "chore: add some-package to brewfile"
git push
```

### Adding a New Zsh Plugin

1. Edit `dot_zsh_plugins.txt` (in the source repo or via `chezmoi edit ~/.zsh_plugins.txt`)
2. Run `chezmoi apply` — this triggers `run_onchange_antidote-bundle.sh` automatically
3. Open a new terminal

---

## Shell Architecture

### Performance Optimizations

Target: **< 50ms** shell startup time. Techniques used:

| Optimization | Savings | How |
|---|---|---|
| Powerlevel10k instant prompt | ~200ms | Renders prompt before plugins load |
| Cached `brew shellenv` | ~80ms | Cached to `~/.cache/brew-shellenv.zsh`, regenerates on brew update |
| Cached `fzf --zsh` | ~30ms | Same caching pattern |
| `_cache_eval` helper | ~50ms each | Caches `zoxide init`, `direnv hook`, `thefuck --alias` |
| Deferred compinit | ~250ms | Handled by `use-omz` plugin, not called twice |
| NVM lazy loading | ~400ms | `zsh-nvm` plugin with `NVM_LAZY_LOAD=true` |
| Background SSH key loading | ~11ms | `load_default_ssh_keys &!` |

### Plugin Management (Antidote)

Plugins are listed in `dot_zsh_plugins.txt`. When this file changes, `run_onchange_antidote-bundle.sh` regenerates the static file (`~/.zsh_plugins.zsh`) automatically during `chezmoi apply`.

### Key Aliases

The `.zshrc` template includes ~100 aliases organized by category. Highlights:

| Category | Examples |
|---|---|
| Modern CLI replacements | `ls`=eza, `cat`=bat, `du`=dust, `df`=duf, `ping`=gping, `cd`=zoxide |
| Git | `gst`, `gco`, `gcb`, `glog`, `gwip`, `gundo`, `lg`=lazygit |
| Docker | `d`, `dc`, `dcu`, `dcd`, `dps`, `lzd`=lazydocker |
| Terraform | `tf`, `tfi`, `tfp`, `tfa`, `tfs` |
| Ansible | `ap`, `apv`, `apc`, `av`, `ave`, `avd`, `al` |
| macOS only | `showfiles`, `hidefiles`, `flushdns`, `emptytrash`, `zscaler-start`, `zscaler-kill`, `brewup` |
| Linux only | `update` (yay/pacman), `flushdns` (systemd-resolve) |

---

## OpenCode + ECC Integration

[Everything Claude Code](https://github.com/affaan-m/everything-claude-code) (ECC) provides AI agent prompts, commands, skills, and plugins for OpenCode.

### How It Works

1. **`.chezmoiexternal.toml`** tells chezmoi to clone ECC into `~/.local/share/ecc/`
2. **`run_onchange_setup-opencode.sh`** creates symlinks from the clone into `~/.config/opencode/`:
   - `commands/` -> ECC commands
   - `prompts/` -> ECC agent prompts
   - `instructions/` -> ECC instructions
   - `skills/` -> ECC skills
   - `plugins/ecc-hooks.ts` -> ECC plugin hooks
3. **Our customizations** (`opencode.json`, `AGENTS.md`, `package.json`) are deployed directly by chezmoi from `private_dot_config/private_opencode/`

### Model Routing

Agents are routed to different models based on task complexity:

| Model | Agents | Rationale |
|---|---|---|
| **Gemini 3.1 Pro** | `planner`, `architect` | Deep reasoning for complex planning and architecture |
| **Gemini 3.1 Pro** (default) | `code-reviewer`, `security-reviewer`, `tdd-guide`, `e2e-runner`, `refactor-cleaner`, `go-reviewer`, `database-reviewer` | Best balance for code generation and review |
| **Gemini 3.1 Flash** | `build-error-resolver`, `doc-updater`, `go-build-resolver` | Mechanical fixes and documentation |

### Updating ECC

```bash
chezmoi update
```

This pulls the latest ECC from GitHub and re-runs the setup script.

---

## Homebrew (macOS)

The `Brewfile` contains ~110 formulae, ~58 casks, and ~35 VS Code extensions. It runs automatically via `run_onchange_install-packages.sh` when the Brewfile changes.

### Key Packages by Category

| Category | Packages |
|---|---|
| Shell/Terminal | zsh, antidote, bat, eza, fd, fzf, dust, duf, gping, procs, zoxide, thefuck, tldr, btop |
| DevOps/IaC | ansible, packer, tfswitch |
| Cloud | awscli, azure-cli, gcloud-cli, localstack-cli |
| Containers/K8s | docker, helm, kubernetes-cli, minikube, skaffold, lazydocker |
| Python | python@3.13, python@3.14, black, ruff, mypy, pytest, uv |
| Java | openjdk, groovy, maven, jenv |
| Git | git, lazygit, gh, git-filter-repo |
| AI | opencode, gemini-cli |

---

## Troubleshooting

### Check chezmoi health

```bash
chezmoi doctor
```

This checks for common issues: binary version, config file, source directory, required tools.

### See what chezmoi would change

```bash
chezmoi diff
```

### Verify deployed state matches source

```bash
chezmoi verify
```

Exit code 0 means everything matches. Non-zero means files have drifted.

### Template rendering errors

Test a template without deploying:

```bash
chezmoi execute-template < $(chezmoi source-path)/dot_zshrc.tmpl | head -20
```

### Force re-apply everything

```bash
chezmoi apply --force
```

### Reset to clean state

If something goes wrong, you can re-initialize:

```bash
chezmoi init --apply dmirtillo/dotfiles
```

This re-clones the repo and re-prompts for configuration.

### Shell startup is slow

Measure startup time:

```bash
hyperfine 'zsh -i -c exit'
```

Target is < 50ms. If it's slow, check that `_cache_eval` caches exist:

```bash
ls -la ~/.cache/{brew-shellenv,fzf,zoxide,direnv,thefuck}.zsh
```

If missing, open a new terminal — they regenerate automatically on first load.

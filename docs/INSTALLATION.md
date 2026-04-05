# Installation Guide

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
5. **Install GSD** — Get Shit Done agentic framework is installed globally via `npx`
6. **Run setup scripts** (in order):
   - `install-packages.sh` — runs `brew bundle install` (macOS) or prints guidance (Linux)
   - `setup-opencode.sh` — installs OpenCode plugin SDK and Get Shit Done globally
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

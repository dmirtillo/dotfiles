# dotfiles

Personal macOS development environment configuration. Everything needed to go from a clean macOS install to a fully configured workstation.

**Machine:** Apple Silicon (arm64) | **Shell:** zsh + antidote + Powerlevel10k

## Quick Start (Fresh Machine)

```bash
# 1. Install Xcode Command Line Tools
xcode-select --install

# 2. Clone this repo
git clone https://github.com/dmirtillo/dotfiles.git ~/projects/software/dotfiles

# 3. Run the installer
cd ~/projects/software/dotfiles
./scripts/install.sh

# 4. Open a new terminal and verify
zsh --version
```

The installer will:
- Install Homebrew (if missing)
- Install all formulae, casks, and VS Code extensions from the `Brewfile`
- Symlink all dotfiles to `$HOME`
- Generate the antidote static plugins file
- Set up required directories

## Repository Structure

```
dotfiles/
├── Brewfile                 # All Homebrew formulae, casks, taps, VS Code extensions
├── README.md                # This file
├── git/
│   └── .gitconfig           # Git user config, credential helper, editor
├── scripts/
│   ├── install.sh           # Full setup from scratch
│   └── snapshot.sh          # Sync live dotfiles back into this repo
├── ssh/
│   └── config               # SSH client config (not keys!)
├── vim/
│   └── .vimrc               # Vim configuration
└── zsh/
    ├── .p10k.zsh            # Powerlevel10k theme configuration
    ├── .zprofile             # Login shell config (brew shellenv)
    ├── .zsh_plugins.txt      # Antidote plugin list
    └── .zshrc                # Main shell configuration
```

## Detailed Setup Guide

### Step 1: macOS Basics

After first boot:

1. Sign in to Apple ID
2. Run Software Update: **System Settings > General > Software Update**
3. Install Xcode Command Line Tools:
   ```bash
   xcode-select --install
   ```

### Step 2: Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Add Homebrew to PATH (the installer will tell you this):

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Step 3: Install Everything via Brewfile

```bash
brew bundle install --file=Brewfile
```

This installs:

| Category | Count | Examples |
|----------|------:|---------|
| Taps | 6 | hashicorp, localstack, warrensbox |
| Formulae | ~110 | ansible, awscli, bat, docker, eza, fd, fzf, git, jq, terraform tools, zsh |
| Casks | ~58 | Bitwarden, DBeaver, Discord, Docker Desktop, Firefox, Chrome, IntelliJ, iTerm2, Slack, VS Code |
| VS Code Extensions | ~30 | Python, Terraform, Ansible, Docker, Kubernetes, Java |

### Step 4: Symlink Dotfiles

The install script handles this, but for manual setup:

```bash
# ZSH
ln -sf ~/projects/software/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/projects/software/dotfiles/zsh/.zsh_plugins.txt ~/.zsh_plugins.txt
ln -sf ~/projects/software/dotfiles/zsh/.zprofile ~/.zprofile
ln -sf ~/projects/software/dotfiles/zsh/.p10k.zsh ~/.p10k.zsh

# Git
ln -sf ~/projects/software/dotfiles/git/.gitconfig ~/.gitconfig

# Vim
ln -sf ~/projects/software/dotfiles/vim/.vimrc ~/.vimrc

# SSH (config only)
mkdir -p ~/.ssh && chmod 700 ~/.ssh
ln -sf ~/projects/software/dotfiles/ssh/config ~/.ssh/config
```

### Step 5: Shell Setup

```bash
# Generate antidote static plugins
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.zsh

# Create completions directory
mkdir -p ~/.zsh/completions

# Create cache directory
mkdir -p ~/.cache

# Open a new terminal -- p10k will prompt for configuration on first run
```

### Step 6: SSH Keys

Copy your SSH keys to `~/.ssh/keys/` (these are NOT stored in this repo):

```bash
mkdir -p ~/.ssh/keys
chmod 700 ~/.ssh/keys
# Copy your .key files here
chmod 600 ~/.ssh/keys/*.key
```

SSH host configurations go in `~/.ssh/config.d/` (included by the main config).

### Step 7: Git Configuration

Review and update `~/.gitconfig` with your name and email:

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

## Apps Requiring Manual Installation

These apps are NOT available via Homebrew or are managed outside of it:

| App | Install Method | Notes |
|-----|---------------|-------|
| **Microsoft Office** (Word, Excel, PowerPoint, Outlook, OneNote) | [Microsoft 365 portal](https://portal.office.com) or enterprise MDM | Managed by IT / company license |
| **Microsoft OneDrive** | Bundled with Office or [direct download](https://www.microsoft.com/en-us/microsoft-365/onedrive/download) | |
| **Microsoft Defender** | Enterprise MDM | Security requirement |
| **Windows App** (RDP client) | [Mac App Store](https://apps.apple.com/app/windows-app/id1295203466) | |
| **MIB Browser** | [iReasoning](https://www.ireasoning.com/mibbrowser.shtml) | SNMP MIB browser, no brew cask |
| **Araxis Merge** | `brew install --cask araxis-merge` or [direct](https://www.araxis.com) | Available via brew but installed manually |
| **BetterZip** | `brew install --cask betterzip` or [direct](https://macitbetter.com) | Available via brew but installed manually |
| **NetSpot** | `brew install --cask netspot` or [Mac App Store](https://apps.apple.com/app/netspot-wifi-analyzer/id514951692) | WiFi analyzer |
| **RustDesk** | `brew install --cask rustdesk` or [direct](https://rustdesk.com) | Remote desktop |
| **Sublime Text** | `brew install --cask sublime-text` or [direct](https://www.sublimetext.com) | Available via brew |
| **PDFelement** | [Wondershare](https://pdf.wondershare.com) | PDF editor, no reliable brew cask |
| **Amazon WorkSpaces** | `brew install --cask amazon-workspaces` or [direct](https://clients.amazonworkspaces.com) | VDI client |

To add these to Homebrew management where possible:

```bash
brew install --cask araxis-merge betterzip netspot rustdesk sublime-text amazon-workspaces
```

## Shell Architecture

### Plugin Manager: Antidote

Plugins are listed in `~/.zsh_plugins.txt` (one per line). Antidote generates a static `.zsh_plugins.zsh` file that is sourced on startup. The static file is only regenerated when the plugins list changes.

### Plugins Loaded

| Plugin | Purpose | Loading |
|--------|---------|---------|
| `getantidote/use-omz` | OMZ compatibility layer | Immediate |
| `ohmyzsh/ohmyzsh path:lib` | OMZ core library | Immediate |
| `ohmyzsh/ohmyzsh path:plugins/git` | Git aliases and completions | Immediate |
| `ohmyzsh/ohmyzsh path:plugins/z` | Directory jumping | Immediate |
| `ohmyzsh/ohmyzsh path:plugins/brew` | Brew completions | Immediate |
| `ohmyzsh/ohmyzsh path:plugins/colorize` | Syntax highlighting for files | Immediate |
| `ohmyzsh/ohmyzsh path:plugins/common-aliases` | Common shell aliases | Immediate |
| `ohmyzsh/ohmyzsh path:plugins/iterm2` | iTerm2 integration | Immediate |
| `ohmyzsh/ohmyzsh path:plugins/macos` | macOS utilities | Immediate |
| `ohmyzsh/ohmyzsh path:plugins/zsh-navigation-tools` | Navigation tools | Immediate |
| `zsh-users/zsh-completions` | Extra completions | fpath only |
| `esc/conda-zsh-completion` | Conda completions | fpath only |
| `lukechilds/zsh-nvm` | NVM lazy-loading | Deferred |
| `romkatv/powerlevel10k` | Prompt theme | Immediate |
| `zsh-users/zsh-autosuggestions` | Fish-like suggestions | Deferred |
| `zsh-users/zsh-syntax-highlighting` | Command highlighting | Deferred |

### Performance Optimizations

| Technique | Savings |
|-----------|---------|
| p10k instant prompt at top of `.zshrc` | Perceived instant startup |
| `brew shellenv` cached to `~/.cache/brew-shellenv.zsh` | ~18ms |
| `fzf --zsh` cached to `~/.cache/fzf.zsh` | ~10ms |
| `zoxide`, `direnv`, `thefuck` cached to `~/.cache/*.zsh` | ~1.8s combined |
| VS Code shell integration path hardcoded | ~255ms in VS Code terminals |
| `compinit` deferred via `use-omz` (no duplicate calls) | ~250ms |
| `ZSH_DISABLE_COMPFIX=true` (skip compaudit) | ~16ms |
| `DISABLE_MAGIC_FUNCTIONS=true` | Paste speed improvement |
| SSH keys loaded in background (`&!`) | ~11ms |
| NVM lazy-loaded (only on first `node`/`npm` use) | ~200ms |
| Autosuggestions: `BUFFER_MAX_SIZE=20`, `MANUAL_REBIND=1` | Minor |
| `typeset -U path` (PATH deduplication) | Cleanliness |
| All caches auto-regenerate when binaries update | Zero maintenance |

**Result:** ~70ms shell startup time (benchmarked with `hyperfine`).

### Key Aliases

#### System Update
| Alias | Command |
|-------|---------|
| `brewup` | `brew update && brew upgrade && brew upgrade --cask --greedy && brew cleanup && antidote update` |

#### Modern Tool Replacements
| Alias | Tool | Replaces |
|-------|------|----------|
| `cat` | `bat` | `cat` (with syntax highlighting) |
| `ls`, `ll`, `la` | `eza` | `ls` (with icons and git status) |
| `du` | `dust` | `du` (visual bar charts) |
| `df` | `duf` | `df` (colorful tables) |
| `cd` | `zoxide` | `cd` (learns your directories) |
| `ping` | `gping` | `ping` (graphical plot) |
| `psg` | `procs` | `ps aux \| grep` |
| `search` | `rg` (ripgrep) | `grep -r` |
| `findfile` / `finddir` | `fd` | `find` |

#### Development
| Alias | Expansion |
|-------|-----------|
| `tf`, `tfi`, `tfp`, `tfa` | `terraform`, `terraform init`, `terraform plan`, `terraform apply` |
| `ap`, `apv`, `apc` | `ansible-playbook`, with vault pass, check+diff |
| `av`, `ave`, `avd`, `avv` | `ansible-vault` encrypt/decrypt/view |
| `lg` | `lazygit` (git TUI) |
| `lzd` | `lazydocker` (docker TUI) |
| `dc`, `dcu`, `dcd`, `dcb` | `docker compose` up/down/build |
| `fuck` | `thefuck` (auto-correct previous command) |
| `help` | `tldr` (simplified man pages) |

## Keeping Dotfiles in Sync

### After making changes to your live config:

```bash
cd ~/projects/software/dotfiles
./scripts/snapshot.sh
git add -A && git commit -m "update dotfiles"
git push
```

### On another machine:

```bash
git pull
./scripts/install.sh
```

### If using symlinks (recommended):

Changes to `~/.zshrc` etc. are automatically reflected in the repo since they're symlinks. Just commit and push:

```bash
cd ~/projects/software/dotfiles
git add -A && git commit -m "update config"
git push
```

## Notes

- **SSH keys** are never stored in this repo. Copy them manually.
- **`.gitconfig`** contains email addresses -- review before pushing to a public repo.
- **Brewfile** includes VS Code extensions. They install via `brew bundle` automatically.
- **NVM** is lazy-loaded. First call to `node`, `npm`, or `nvm` triggers the load (~200ms once).
- **Caches** in `~/.cache/` auto-regenerate. No manual maintenance needed after `brew upgrade`.

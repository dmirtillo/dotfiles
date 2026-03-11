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
- Initialize git submodules (ECC)
- Set up OpenCode with ECC agents, commands, skills, and plugin hooks

## Repository Structure

```
dotfiles/
├── .ecc-version             # ECC version and commit SHA tracking
├── .gitmodules              # Git submodule definitions
├── Brewfile                 # All Homebrew formulae, casks, taps, VS Code extensions
├── README.md                # This file
├── git/
│   └── .gitconfig           # Git user config, credential helper, editor
├── opencode/                # OpenCode global config (our customizations)
│   ├── AGENTS.md            # Combined rules (common + TS + Python + Go)
│   ├── opencode.json        # Agent/command definitions, config
│   └── package.json         # Plugin SDK dependency
├── scripts/
│   ├── install.sh           # Full setup from scratch (fresh machine)
│   ├── sync.sh              # Pull repo changes and apply locally (additive)
│   ├── backup.sh            # Create tgz backup of current live dotfiles
│   ├── restore.sh           # Restore dotfiles from a tgz backup
│   ├── snapshot.sh          # Copy live dotfiles back into the repo
│   └── update-ecc.sh        # Update ECC submodule with change analysis
├── ssh/
│   └── config               # SSH client config (not keys!)
├── vendor/
│   └── everything-claude-code/  # ECC git submodule (pinned to specific commit)
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

## Workflow: Development and Deployment

The intended workflow is to develop and test changes in the repo, then deploy them to the local machine using the sync script. Every sync creates a backup first so you can always roll back.

```
  [Edit in repo] --> [git commit + push] --> [sync.sh on target machine]
                                                    |
                                              [auto backup.sh]
                                                    |
                                              [apply changes]
```

### Scripts Overview

| Script | Purpose | When to use |
|--------|---------|-------------|
| `install.sh` | Full setup from scratch | Fresh machine, first-time setup |
| `sync.sh` | Pull + backup + apply changes | After pushing changes to the repo |
| `backup.sh` | Create tgz archive of live config | Before risky changes, periodic safety net |
| `restore.sh` | Restore from a tgz backup | When something breaks, need to roll back |
| `snapshot.sh` | Copy live dotfiles into the repo | When you edited live files instead of repo |
| `update-ecc.sh` | Update ECC submodule | When upstream ECC releases a new version |

### Deploying Changes (sync.sh)

After editing files in the repo and pushing:

```bash
cd ~/projects/software/dotfiles
./scripts/sync.sh
```

This will:
1. `git pull` the latest changes
2. Create a tgz backup of your current live dotfiles (automatic)
3. Compare each dotfile and fix symlinks or replace changed files
4. Install any new Brewfile entries (additive -- never removes packages)
5. Regenerate antidote plugins if `.zsh_plugins.txt` changed
6. Clear stale caches so they auto-regenerate on next shell startup

Options:

```bash
./scripts/sync.sh --dry-run    # Preview what would change, apply nothing
./scripts/sync.sh --no-pull    # Apply local repo state without pulling
./scripts/sync.sh --no-brew    # Skip Brewfile install (dotfiles only)
```

### Backups (backup.sh)

Create a backup at any time:

```bash
./scripts/backup.sh                    # Auto-timestamped
./scripts/backup.sh pre-experiment     # With a label
```

This creates a tgz archive in `~/.dotfiles-backups/` containing:
- All dotfiles (resolved from symlinks, so you get the actual content)
- The generated `.zsh_plugins.zsh` static file
- All tool caches (`~/.cache/*.zsh`)
- A Brewfile snapshot of currently installed packages
- A `MANIFEST.txt` with machine info and file list

Backups are lightweight (~100KB) and self-contained.

### Restoring from Backup (restore.sh)

```bash
./scripts/restore.sh                   # Interactive: pick from a list
./scripts/restore.sh --latest          # Restore the most recent backup
./scripts/restore.sh --list            # List all available backups
./scripts/restore.sh <file.tgz>       # Restore a specific backup
./scripts/restore.sh --latest --dry-run  # Preview without applying
```

What restore does:
- Replaces symlinks with plain file copies from the backup
- Restores tool caches so the shell is immediately functional
- Saves the backup's Brewfile to `~/.dotfiles-backups/Brewfile.restored`
- Does NOT auto-install Brewfile packages (run `brew bundle install --file=<path>` manually)

After restoring, to re-link to the repo:

```bash
./scripts/sync.sh --no-pull
```

### Example Workflows

**Normal development cycle:**
```bash
# 1. Edit dotfiles in the repo
vim ~/projects/software/dotfiles/zsh/.zshrc

# 2. Commit and push
cd ~/projects/software/dotfiles
git add -A && git commit -m "add new alias"
git push

# 3. Changes are live immediately (files are symlinked)
#    Open a new terminal to reload
```

**Testing on the same machine (symlinks make this automatic):**
```bash
# Edit the repo file -- it IS the live file via symlink
vim ~/.zshrc    # This edits the repo file directly

# Commit when happy
cd ~/projects/software/dotfiles
git add -A && git commit -m "tested and working"
git push
```

**Deploying to a second machine:**
```bash
git clone git@github.com:dmirtillo/dotfiles.git ~/projects/software/dotfiles
cd ~/projects/software/dotfiles
./scripts/install.sh   # First time

# Later, to pull updates:
./scripts/sync.sh
```

**Something broke, need to roll back:**
```bash
# List backups
./scripts/restore.sh --list

# Preview what the restore would do
./scripts/restore.sh --latest --dry-run

# Restore
./scripts/restore.sh --latest

# Once stable, re-link to repo
./scripts/sync.sh --no-pull
```

**Periodic backup (add to crontab or run manually):**
```bash
./scripts/backup.sh weekly
```

## OpenCode + ECC (Everything Claude Code)

### What is ECC?

[Everything Claude Code](https://github.com/affaan-m/everything-claude-code) (ECC) is a performance optimization system for AI coding agents. It provides:

| Component | Count | Description |
|-----------|------:|-------------|
| Agents | 12 | Specialized subagents (planner, architect, code-reviewer, security-reviewer, etc.) |
| Commands | 31 | Slash commands (`/plan`, `/tdd`, `/code-review`, `/security`, `/build-fix`, etc.) |
| Skills | 81 | On-demand knowledge packs (coding standards, backend patterns, TDD, etc.) |
| Plugin | 1 | Event-driven hooks (auto-format, typecheck, console.log audit, notifications) |
| Rules | 24 | Coding style, testing, security, and git guidelines (common + 3 languages) |

### Architecture: Submodule + Symlinks

ECC upstream is tracked as a **git submodule** at `vendor/everything-claude-code/`, pinned to a specific commit. This gives us exact version control and clean diffs.

Files are split into two categories:

**Files we own** (in `opencode/`, tracked in our repo):
- `AGENTS.md` -- Combined rules (concatenated from ECC's `rules/common/` + language-specific dirs)
- `opencode.json` -- Agent/command definitions (adapted from ECC's config, no model lock-in)
- `package.json` -- Plugin SDK dependency declaration

**Files from upstream** (symlinked from submodule, auto-updated on `git pull`):
- `commands/` -- 31 command template files
- `prompts/agents/` -- 12 agent system prompt files
- `instructions/` -- Additional instruction files
- `skills/` -- 81 on-demand skill directories
- `plugins/ecc-hooks.ts` -- Plugin hook implementations

```
~/.config/opencode/
  AGENTS.md        -> dotfiles/opencode/AGENTS.md           (ours)
  opencode.json    -> dotfiles/opencode/opencode.json       (ours)
  package.json     -> dotfiles/opencode/package.json        (ours)
  commands/        -> dotfiles/vendor/.../. opencode/commands/  (submodule)
  prompts/         -> dotfiles/vendor/.../.opencode/prompts/    (submodule)
  instructions/    -> dotfiles/vendor/.../.opencode/instructions/ (submodule)
  skills/          -> dotfiles/vendor/.../skills/               (submodule)
  plugins/
    ecc-hooks.ts   -> dotfiles/vendor/.../.opencode/plugins/ecc-hooks.ts (submodule)
  node_modules/    (generated by bun install, not tracked)
  bun.lock         (generated, not tracked)
```

### Updating ECC

When ECC releases a new version, use `update-ecc.sh`:

```bash
# Check for updates (no changes applied)
./scripts/update-ecc.sh --check

# Update submodule and show what changed
./scripts/update-ecc.sh

# Update + regenerate AGENTS.md from upstream rules
./scripts/update-ecc.sh --regen-rules
```

The script:
1. Fetches upstream and shows the commit diff
2. Categorizes changes by impact:
   - `[*]` Auto-updated via symlinks (commands, prompts, plugins, skills, instructions)
   - `[!]` Manual action needed (new agents/commands in opencode.json, rules changes, SDK version bump)
3. Updates the submodule and `.ecc-version` file
4. Optionally regenerates `AGENTS.md` from upstream rules
5. Stages everything for commit

### What auto-updates vs. what needs manual work

| Change Type | Auto-Updated? | Action Needed |
|-------------|:---:|---|
| Agent prompt modified | Yes | None (symlinked) |
| Command template modified | Yes | None (symlinked) |
| Plugin hooks modified | Yes | None (symlinked) |
| New/modified skill | Yes | None (symlinked) |
| Instructions modified | Yes | None (symlinked) |
| New agent added | No | Add to `opencode/opencode.json` |
| New command added | No | Add to `opencode/opencode.json` |
| Rules files changed | No | Run `update-ecc.sh --regen-rules` |
| Plugin SDK version bump | No | Update `opencode/package.json` |

### Key Commands

| Command | Agent | Description |
|---------|-------|-------------|
| `/plan` | planner | Create implementation plan for complex features |
| `/tdd` | tdd-guide | TDD workflow with 80%+ test coverage |
| `/code-review` | code-reviewer | Quality, security, and maintainability review |
| `/security` | security-reviewer | Comprehensive security vulnerability scan |
| `/build-fix` | build-error-resolver | Fix build and TypeScript errors |
| `/e2e` | e2e-runner | Generate Playwright E2E tests |
| `/refactor-clean` | refactor-cleaner | Remove dead code, consolidate duplicates |
| `/learn` | (self) | Extract patterns from current session |
| `/verify` | (self) | Run verification loop |
| `/go-review` | go-reviewer | Go-specific code review |
| `/go-test` | tdd-guide | Go TDD workflow |

### Plugin Hooks

The ECC plugin hooks into OpenCode events:

| Event | Action | Profile |
|-------|--------|---------|
| `file.edited` | Auto-format JS/TS with Prettier, warn about `console.log` | standard+ |
| `tool.execute.after` | Run `tsc --noEmit` after TS file edits | standard+ |
| `tool.execute.before` | Git push reminder, doc file warnings | strict |
| `session.created` | Log session start, check for project context | minimal+ |
| `session.idle` | Audit edited files for `console.log`, macOS notification | minimal+ |
| `shell.env` | Inject `ECC_VERSION`, `PROJECT_ROOT`, `PACKAGE_MANAGER` | always |
| `session.compacting` | Preserve ECC context across compaction | always |

Control strictness via environment variables:
```bash
export ECC_HOOK_PROFILE=standard   # minimal | standard | strict
export ECC_DISABLED_HOOKS="post:edit:typecheck,pre:bash:tmux-reminder"
```

## Notes

- **SSH keys** are never stored in this repo. Copy them manually to `~/.ssh/keys/`.
- **Backups** are stored in `~/.dotfiles-backups/` (not in the repo). Clean old ones manually.
- **Brewfile** includes VS Code extensions. They install via `brew bundle` automatically.
- **NVM** is lazy-loaded. First call to `node`, `npm`, or `nvm` triggers the load (~200ms once).
- **Caches** in `~/.cache/` auto-regenerate. No manual maintenance needed after `brew upgrade`.
- **sync.sh is additive**: it installs new Brewfile entries but never removes existing packages.
- **restore.sh replaces symlinks** with plain files. Run `sync.sh --no-pull` after to re-link.

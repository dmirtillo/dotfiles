# Technology Stack

**Analysis Date:** 2026-07-09

## Languages

**Primary:**
- Go templates - Used across `*.tmpl` files for chezmoi configuration logic
- Shell Script (Bash/Zsh) - Used in `run_onchange_*.sh` lifecycle scripts and shell configuration

**Secondary:**
- Python - Used for running AI proxy tools (`litellm`) via `pipx`
- PowerShell - Used in `run_onchange_*.ps1` lifecycle scripts for Windows

## Runtime

**Environment:**
- Unix-like (macOS / Arch Linux) managed via `chezmoi` conditionals
- Windows (PowerShell)

**Package Manager:**
- `chezmoi` - Cross-platform dotfile synchronization
- `brew` (Homebrew) - macOS system packages (via `Brewfile`)
- `pacman` / `yay` - Arch Linux system packages (via `Pacfile`)
- `mise` - Developer toolchain version manager (Node, Python, Go)
- `pipx` - Isolated Python CLI application manager
- `antidote` - Zsh plugin manager

## Frameworks

**Core:**
- `chezmoi` - Dotfile management and template rendering

**Testing:**
- Not applicable (No dedicated testing framework detected)

**Build/Dev:**
- `make` / `gcc` - System build tools (via `Pacfile` / `Brewfile`)

## Key Dependencies

**Critical:**
- `litellm[proxy]` 1.83.14 - Local OpenAI-compatible proxy for Vertex AI routing
- `google-cloud-aiplatform` - GCP SDK injected into litellm for Claude model access

**Infrastructure:**
- `zsh` - Primary interactive shell
- `tmux` - Terminal multiplexer
- `ghostty` - Terminal emulator

## Configuration

**Environment:**
- Configured interactively via `chezmoi init` and stored in `~/.config/chezmoi/chezmoi.toml`
- Key configs required: `git_name`, `git_email`, `gcloud_project`, `gemini_api_key`, `aws_profile`

**Build:**
- `Brewfile` - macOS Homebrew package manifest
- `Pacfile` - Arch Linux package manifest
- `dot_mise.toml.tmpl` - Toolchain version configurations

## Platform Requirements

**Development:**
- Git, curl (for initial chezmoi bootstrap)

**Production:**
- macOS (via `Brewfile`)
- Arch Linux (via `Pacfile`)
- Windows (via PowerShell scripts)

---

*Stack analysis: 2026-07-09*

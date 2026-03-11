#!/usr/bin/env bash
# =============================================================================
# Platform Detection Library
# Exports variables about the current OS, distro, architecture, and tool paths.
# =============================================================================

# Default to unknown
export DOTFILES_OS="unknown"
export DOTFILES_DISTRO="unknown"
export DOTFILES_ARCH="unknown"
export DOTFILES_PKG_MANAGER="none"
export DOTFILES_HAS_YAY=false
export DOTFILES_BREW_PREFIX=""
export DOTFILES_ANTIDOTE_PATH=""
export DOTFILES_FZF_PATH=""
export DOTFILES_VSCODE_SI_PATH=""

# Detect OS
if [[ "$OSTYPE" == darwin* ]]; then
  export DOTFILES_OS="macos"
  export DOTFILES_DISTRO="macos"
elif [[ "$OSTYPE" == linux* ]]; then
  export DOTFILES_OS="linux"
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    export DOTFILES_DISTRO="$ID"
  fi
fi

# Detect Architecture
arch_name="$(uname -m)"
if [ "$arch_name" = "x86_64" ]; then
  export DOTFILES_ARCH="x86_64"
elif [ "$arch_name" = "arm64" ] || [ "$arch_name" = "aarch64" ]; then
  export DOTFILES_ARCH="arm64"
fi

# Detect Package Manager & Brew Prefix
if [[ "$DOTFILES_OS" == "macos" ]]; then
  export DOTFILES_PKG_MANAGER="brew"
  if [ "$DOTFILES_ARCH" = "arm64" ]; then
    export DOTFILES_BREW_PREFIX="/opt/homebrew"
  else
    export DOTFILES_BREW_PREFIX="/usr/local"
  fi
elif [[ "$DOTFILES_OS" == "linux" ]]; then
  if command -v pacman &>/dev/null; then
    export DOTFILES_PKG_MANAGER="pacman"
    if command -v yay &>/dev/null; then
      export DOTFILES_HAS_YAY=true
    fi
  elif command -v apt-get &>/dev/null; then
    export DOTFILES_PKG_MANAGER="apt"
  fi
  
  # Check if Linuxbrew is installed
  if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    export DOTFILES_BREW_PREFIX="/home/linuxbrew/.linuxbrew"
  fi
fi

# Detect Tool Paths
if [[ "$DOTFILES_OS" == "macos" ]] && [ -n "$DOTFILES_BREW_PREFIX" ]; then
  export DOTFILES_ANTIDOTE_PATH="$DOTFILES_BREW_PREFIX/opt/antidote/share/antidote/antidote.zsh"
  export DOTFILES_FZF_PATH="$DOTFILES_BREW_PREFIX/opt/fzf"
  export DOTFILES_VSCODE_SI_PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration-rc.zsh"
elif [[ "$DOTFILES_OS" == "linux" ]]; then
  # Arch Linux AUR path
  if [ -f "/usr/share/zsh-antidote/antidote.zsh" ]; then
    export DOTFILES_ANTIDOTE_PATH="/usr/share/zsh-antidote/antidote.zsh"
  fi
  
  if [ -d "/usr/share/fzf" ]; then
    export DOTFILES_FZF_PATH="/usr/share/fzf"
  fi
  
  if [ -f "/usr/share/code/resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration-rc.zsh" ]; then
    export DOTFILES_VSCODE_SI_PATH="/usr/share/code/resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration-rc.zsh"
  fi
fi

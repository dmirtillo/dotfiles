#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Dotfiles Snapshot
# Copies current system dotfiles into this repo and regenerates the Brewfile.
# Run this before committing to keep the repo in sync with your live config.
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OC_CONFIG="$HOME/.config/opencode"

# Load platform detection
source "$DOTFILES_DIR/scripts/lib/platform.sh"

echo "Snapshotting current dotfiles into $DOTFILES_DIR ..."

# ZSH files
cp ~/.zshrc "$DOTFILES_DIR/zsh/.zshrc"
cp ~/.zsh_plugins.txt "$DOTFILES_DIR/zsh/.zsh_plugins.txt"
cp ~/.zprofile "$DOTFILES_DIR/zsh/.zprofile"
cp ~/.p10k.zsh "$DOTFILES_DIR/zsh/.p10k.zsh"

# Git config
cp ~/.gitconfig "$DOTFILES_DIR/git/.gitconfig"

# Vim config
cp ~/.vimrc "$DOTFILES_DIR/vim/.vimrc"

# SSH config (not keys)
cp ~/.ssh/config "$DOTFILES_DIR/ssh/config"

# OpenCode config (only files we own -- not ECC submodule content)
if [ -f "$OC_CONFIG/AGENTS.md" ]; then
  cp -L "$OC_CONFIG/AGENTS.md" "$DOTFILES_DIR/opencode/AGENTS.md"
  echo "  [opencode] AGENTS.md"
fi
if [ -f "$OC_CONFIG/opencode.json" ]; then
  cp -L "$OC_CONFIG/opencode.json" "$DOTFILES_DIR/opencode/opencode.json"
  echo "  [opencode] opencode.json"
fi
if [ -f "$OC_CONFIG/package.json" ]; then
  cp -L "$OC_CONFIG/package.json" "$DOTFILES_DIR/opencode/package.json"
  echo "  [opencode] package.json"
fi

# Regenerate Brewfile (macOS only)
if [[ "$DOTFILES_OS" == "macos" ]]; then
  brew bundle dump --file="$DOTFILES_DIR/Brewfile" --force
  echo "  [brew] Brewfile regenerated"
elif [[ "$DOTFILES_OS" == "linux" ]]; then
  echo "  [linux] Packages snapshot deferred to Phase 1"
fi

echo ""
echo "Snapshot complete. Review changes with:"
echo "  cd $DOTFILES_DIR && git diff"

#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Dotfiles Installer
# Symlinks dotfiles and installs dependencies for a fresh macOS setup.
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=================================================="
echo "  Dotfiles Installer"
echo "  Source: $DOTFILES_DIR"
echo "=================================================="
echo ""

# --- Helpers ---
link_file() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -f "$dst" ]; then
    echo "  Backing up existing $dst -> ${dst}.backup"
    mv "$dst" "${dst}.backup"
  fi
  ln -s "$src" "$dst"
  echo "  Linked $dst -> $src"
}

# --- Step 1: Install Homebrew ---
echo "[1/6] Checking Homebrew..."
if ! command -v brew &>/dev/null; then
  echo "  Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "  Homebrew already installed."
fi

# --- Step 2: Install Brewfile packages ---
echo ""
echo "[2/6] Installing Brewfile packages..."
echo "  This may take a while on a fresh machine."
brew bundle install --file="$DOTFILES_DIR/Brewfile" --no-lock
echo "  Done."

# --- Step 3: Symlink dotfiles ---
echo ""
echo "[3/6] Symlinking dotfiles..."

# ZSH
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/zsh/.zsh_plugins.txt" "$HOME/.zsh_plugins.txt"
link_file "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
link_file "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

# Git
link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Vim
link_file "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"

# SSH (config only, not keys)
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
link_file "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"

echo "  Done."

# --- Step 4: Set up ZSH completions directory ---
echo ""
echo "[4/6] Setting up ZSH completions directory..."
mkdir -p "$HOME/.zsh/completions"
echo "  Done."

# --- Step 5: Generate antidote static plugins file ---
echo ""
echo "[5/6] Generating antidote plugins..."
if command -v antidote &>/dev/null || [ -f /opt/homebrew/opt/antidote/share/antidote/antidote.zsh ]; then
  zsh -c 'source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh && antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.zsh'
  echo "  Done."
else
  echo "  WARNING: antidote not found. Run 'brew install antidote' first."
fi

# --- Step 6: Create cache directory ---
echo ""
echo "[6/6] Setting up cache directory..."
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}"
echo "  Done."

echo ""
echo "=================================================="
echo "  Installation complete!"
echo ""
echo "  Next steps:"
echo "    1. Open a new terminal to load the config"
echo "    2. Run 'p10k configure' if prompted"
echo "    3. Copy your SSH keys to ~/.ssh/keys/"
echo "    4. Review ~/.gitconfig and update user info"
echo "    5. See README.md for manual app installs"
echo "=================================================="

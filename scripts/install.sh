#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Dotfiles Installer
# Symlinks dotfiles and installs dependencies for a fresh macOS setup.
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ECC_DIR="$DOTFILES_DIR/vendor/everything-claude-code"
OC_CONFIG="$HOME/.config/opencode"

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

link_dir() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -d "$dst" ]; then
    echo "  Backing up existing $dst -> ${dst}.backup"
    mv "$dst" "${dst}.backup"
  fi
  ln -s "$src" "$dst"
  echo "  Linked $dst -> $src"
}

# --- Step 1: Install Homebrew ---
echo "[1/8] Checking Homebrew..."
if ! command -v brew &>/dev/null; then
  echo "  Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "  Homebrew already installed."
fi

# --- Step 2: Install Brewfile packages ---
echo ""
echo "[2/8] Installing Brewfile packages..."
echo "  This may take a while on a fresh machine."
brew bundle install --file="$DOTFILES_DIR/Brewfile" --no-lock
echo "  Done."

# --- Step 3: Symlink dotfiles ---
echo ""
echo "[3/8] Symlinking dotfiles..."

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
echo "[4/8] Setting up ZSH completions directory..."
mkdir -p "$HOME/.zsh/completions"
echo "  Done."

# --- Step 5: Generate antidote static plugins file ---
echo ""
echo "[5/8] Generating antidote plugins..."
if command -v antidote &>/dev/null || [ -f /opt/homebrew/opt/antidote/share/antidote/antidote.zsh ]; then
  zsh -c 'source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh && antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.zsh'
  echo "  Done."
else
  echo "  WARNING: antidote not found. Run 'brew install antidote' first."
fi

# --- Step 6: Create cache directory ---
echo ""
echo "[6/8] Setting up cache directory..."
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}"
echo "  Done."

# --- Step 7: Initialize git submodules ---
echo ""
echo "[7/8] Initializing git submodules..."
git -C "$DOTFILES_DIR" submodule update --init --recursive 2>&1 | sed 's/^/  /'
echo "  Done."

# --- Step 8: Set up OpenCode + ECC ---
echo ""
echo "[8/8] Setting up OpenCode + ECC (Everything Claude Code)..."

# Create the OpenCode config directory
mkdir -p "$OC_CONFIG"

# Symlink our customized files (we own these)
link_file "$DOTFILES_DIR/opencode/AGENTS.md" "$OC_CONFIG/AGENTS.md"
link_file "$DOTFILES_DIR/opencode/opencode.json" "$OC_CONFIG/opencode.json"
link_file "$DOTFILES_DIR/opencode/package.json" "$OC_CONFIG/package.json"

# Symlink directories from the ECC submodule (upstream content)
link_dir "$ECC_DIR/.opencode/commands" "$OC_CONFIG/commands"
link_dir "$ECC_DIR/.opencode/prompts" "$OC_CONFIG/prompts"
link_dir "$ECC_DIR/.opencode/instructions" "$OC_CONFIG/instructions"
link_dir "$ECC_DIR/skills" "$OC_CONFIG/skills"

# Symlink the plugin file (single file, not directory -- avoid double-loading)
mkdir -p "$OC_CONFIG/plugins"
link_file "$ECC_DIR/.opencode/plugins/ecc-hooks.ts" "$OC_CONFIG/plugins/ecc-hooks.ts"

# Install plugin SDK dependencies
if command -v bun &>/dev/null; then
  echo "  Installing plugin dependencies via bun..."
  (cd "$OC_CONFIG" && bun install 2>&1 | sed 's/^/  /')
elif command -v npm &>/dev/null; then
  echo "  Installing plugin dependencies via npm..."
  (cd "$OC_CONFIG" && npm install 2>&1 | sed 's/^/  /')
else
  echo "  WARNING: Neither bun nor npm found. Install Node.js or Bun to use OpenCode plugins."
fi

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
echo "    6. Run 'opencode' in any project to use the AI agent"
echo "=================================================="

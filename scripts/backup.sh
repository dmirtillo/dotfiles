#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Dotfiles Backup
# Creates a timestamped tgz archive of the current live dotfiles.
# Backups are stored in ~/.dotfiles-backups/ and can be restored with restore.sh
#
# Usage:
#   ./scripts/backup.sh              # Backup with auto-generated timestamp name
#   ./scripts/backup.sh pre-update   # Backup with custom label (e.g., pre-update)
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES_DIR/scripts/lib/platform.sh"

BACKUP_DIR="$HOME/.dotfiles-backups"
LABEL="${1:-}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
OC_CONFIG="$HOME/.config/opencode"

if [ -n "$LABEL" ]; then
  ARCHIVE_NAME="dotfiles-${LABEL}-${TIMESTAMP}.tgz"
else
  ARCHIVE_NAME="dotfiles-${TIMESTAMP}.tgz"
fi

ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

mkdir -p "$BACKUP_DIR"

echo "=================================================="
echo "  Dotfiles Backup"
echo "  Target: $ARCHIVE_PATH"
echo "=================================================="
echo ""

# Collect files into a temp directory to create a clean archive
TMPDIR="$(mktemp -d)"
STAGING="$TMPDIR/dotfiles-backup"
mkdir -p "$STAGING/zsh" "$STAGING/git" "$STAGING/vim" "$STAGING/ssh" "$STAGING/cache" "$STAGING/opencode"

# --- ZSH ---
for f in .zshrc .zsh_plugins.txt .zprofile .p10k.zsh; do
  src="$HOME/$f"
  # Resolve symlinks to get actual content
  if [ -L "$src" ]; then
    cp -L "$src" "$STAGING/zsh/$f"
    echo "  [zsh] $f (from symlink -> $(readlink "$src"))"
  elif [ -f "$src" ]; then
    cp "$src" "$STAGING/zsh/$f"
    echo "  [zsh] $f"
  else
    echo "  [zsh] $f (not found, skipping)"
  fi
done

# Static plugins file (generated, but useful to have in backup)
if [ -f "$HOME/.zsh_plugins.zsh" ]; then
  cp "$HOME/.zsh_plugins.zsh" "$STAGING/zsh/.zsh_plugins.zsh"
  echo "  [zsh] .zsh_plugins.zsh (generated static file)"
fi

# --- Git ---
src="$HOME/.gitconfig"
if [ -L "$src" ]; then
  cp -L "$src" "$STAGING/git/.gitconfig"
  echo "  [git] .gitconfig (from symlink)"
elif [ -f "$src" ]; then
  cp "$src" "$STAGING/git/.gitconfig"
  echo "  [git] .gitconfig"
fi

# --- Vim ---
src="$HOME/.vimrc"
if [ -L "$src" ]; then
  cp -L "$src" "$STAGING/vim/.vimrc"
  echo "  [vim] .vimrc (from symlink)"
elif [ -f "$src" ]; then
  cp "$src" "$STAGING/vim/.vimrc"
  echo "  [vim] .vimrc"
fi

# --- SSH config (not keys!) ---
src="$HOME/.ssh/config"
if [ -L "$src" ]; then
  cp -L "$src" "$STAGING/ssh/config"
  echo "  [ssh] config (from symlink)"
elif [ -f "$src" ]; then
  cp "$src" "$STAGING/ssh/config"
  echo "  [ssh] config"
fi

# --- OpenCode config (our customized files only, not submodule content) ---
for f in AGENTS.md opencode.json package.json; do
  src="$OC_CONFIG/$f"
  if [ -L "$src" ]; then
    cp -L "$src" "$STAGING/opencode/$f"
    echo "  [opencode] $f (from symlink)"
  elif [ -f "$src" ]; then
    cp "$src" "$STAGING/opencode/$f"
    echo "  [opencode] $f"
  fi
done

# --- Tool caches (so restore is immediate, no regen needed) ---
for cache in brew-shellenv.zsh fzf.zsh zoxide.zsh direnv.zsh thefuck.zsh; do
  src="${XDG_CACHE_HOME:-$HOME/.cache}/$cache"
  if [ -f "$src" ]; then
    cp "$src" "$STAGING/cache/$cache"
    echo "  [cache] $cache"
  fi
done

# --- Brewfile snapshot ---
if command -v brew &>/dev/null; then
  brew bundle dump --file="$STAGING/Brewfile" --force 2>/dev/null
  echo "  [brew] Brewfile (current state)"
fi

# --- Metadata ---
if [[ "$DOTFILES_OS" == "macos" ]]; then
  OS_VERSION="$(sw_vers -productVersion 2>/dev/null || echo "unknown")"
elif [[ "$DOTFILES_OS" == "linux" ]]; then
  OS_VERSION="$(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"' 2>/dev/null || echo "unknown")"
else
  OS_VERSION="unknown"
fi

cat > "$STAGING/MANIFEST.txt" <<EOF
Dotfiles Backup
===============
Date:     $(date)
Hostname: $(hostname)
User:     $(whoami)
OS:       $OS_VERSION
Arch:     $DOTFILES_ARCH
Label:    ${LABEL:-"(none)"}
Shell:    $(zsh --version 2>/dev/null || echo "unknown")

Files included:
$(cd "$STAGING" && find . -type f | sort | sed 's|^\./|  |')
EOF
echo "  [meta] MANIFEST.txt"

# --- Create archive ---
echo ""
tar -czf "$ARCHIVE_PATH" -C "$TMPDIR" "dotfiles-backup"
rm -rf "$TMPDIR"

SIZE=$(du -h "$ARCHIVE_PATH" | awk '{print $1}')
echo "Backup complete: $ARCHIVE_PATH ($SIZE)"
echo ""

# --- List recent backups ---
echo "Recent backups:"
ls -1t "$BACKUP_DIR"/*.tgz 2>/dev/null | head -5 | while read f; do
  echo "  $(basename "$f")  ($(du -h "$f" | awk '{print $1}'))"
done

TOTAL=$(ls -1 "$BACKUP_DIR"/*.tgz 2>/dev/null | wc -l | tr -d ' ')
echo ""
echo "Total backups: $TOTAL (in $BACKUP_DIR)"

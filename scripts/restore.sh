#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Dotfiles Restore
# Restores dotfiles from a tgz backup created by backup.sh.
#
# Usage:
#   ./scripts/restore.sh                            # Interactive: pick from list
#   ./scripts/restore.sh <backup-file.tgz>          # Restore specific backup
#   ./scripts/restore.sh --list                      # List available backups
#   ./scripts/restore.sh --latest                    # Restore the most recent backup
#   ./scripts/restore.sh <backup-file.tgz> --dry-run # Show what would be restored
# =============================================================================

BACKUP_DIR="$HOME/.dotfiles-backups"
DRY_RUN=false
ARCHIVE=""
MODE=""

for arg in "$@"; do
  case "$arg" in
    --dry-run)  DRY_RUN=true ;;
    --list)     MODE="list" ;;
    --latest)   MODE="latest" ;;
    --help|-h)
      echo "Usage: restore.sh [<backup.tgz>] [--list] [--latest] [--dry-run]"
      echo ""
      echo "  <backup.tgz>  Path or filename of backup to restore"
      echo "  --list        List available backups"
      echo "  --latest      Restore the most recent backup"
      echo "  --dry-run     Show what would be restored without applying"
      echo ""
      echo "Backup directory: $BACKUP_DIR"
      exit 0
      ;;
    *)
      if [ -f "$arg" ]; then
        ARCHIVE="$arg"
      elif [ -f "$BACKUP_DIR/$arg" ]; then
        ARCHIVE="$BACKUP_DIR/$arg"
      else
        echo "Error: File not found: $arg"
        echo "Use --list to see available backups."
        exit 1
      fi
      ;;
  esac
done

# --- List mode ---
if [ "$MODE" = "list" ]; then
  echo "Available backups in $BACKUP_DIR:"
  echo ""
  if ls "$BACKUP_DIR"/*.tgz &>/dev/null; then
    ls -1t "$BACKUP_DIR"/*.tgz | while read f; do
      size=$(du -h "$f" | awk '{print $1}')
      name=$(basename "$f")
      # Extract date from MANIFEST if possible
      echo "  $name  ($size)"
    done
    echo ""
    TOTAL=$(ls -1 "$BACKUP_DIR"/*.tgz | wc -l | tr -d ' ')
    echo "Total: $TOTAL backup(s)"
  else
    echo "  No backups found."
  fi
  exit 0
fi

# --- Latest mode ---
if [ "$MODE" = "latest" ]; then
  ARCHIVE=$(ls -1t "$BACKUP_DIR"/*.tgz 2>/dev/null | head -1)
  if [ -z "$ARCHIVE" ]; then
    echo "No backups found in $BACKUP_DIR"
    exit 1
  fi
  echo "Using latest backup: $(basename "$ARCHIVE")"
fi

# --- Interactive selection if no archive specified ---
if [ -z "$ARCHIVE" ]; then
  if ! ls "$BACKUP_DIR"/*.tgz &>/dev/null; then
    echo "No backups found in $BACKUP_DIR"
    echo "Create one with: ./scripts/backup.sh"
    exit 1
  fi

  echo "Available backups:"
  echo ""
  mapfile -t BACKUPS < <(ls -1t "$BACKUP_DIR"/*.tgz)
  for i in "${!BACKUPS[@]}"; do
    name=$(basename "${BACKUPS[$i]}")
    size=$(du -h "${BACKUPS[$i]}" | awk '{print $1}')
    echo "  [$((i+1))] $name  ($size)"
  done
  echo ""
  read -rp "Select backup number (1-${#BACKUPS[@]}): " selection

  if [[ ! "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt "${#BACKUPS[@]}" ]; then
    echo "Invalid selection."
    exit 1
  fi

  ARCHIVE="${BACKUPS[$((selection-1))]}"
  echo ""
fi

echo "=================================================="
echo "  Dotfiles Restore"
echo "  From: $(basename "$ARCHIVE")"
echo "  Mode: $(if $DRY_RUN; then echo "DRY RUN"; else echo "LIVE"; fi)"
echo "=================================================="
echo ""

# --- Extract to temp directory ---
TMPDIR="$(mktemp -d)"
tar -xzf "$ARCHIVE" -C "$TMPDIR"

EXTRACTED="$TMPDIR/dotfiles-backup"
if [ ! -d "$EXTRACTED" ]; then
  echo "Error: Unexpected archive structure. Expected dotfiles-backup/ directory."
  rm -rf "$TMPDIR"
  exit 1
fi

# --- Show manifest ---
if [ -f "$EXTRACTED/MANIFEST.txt" ]; then
  echo "Backup info:"
  sed 's/^/  /' "$EXTRACTED/MANIFEST.txt" | head -8
  echo ""
fi

# --- Restore files ---
echo "Restoring files..."

restore_file() {
  local src="$1" dst="$2" label="$3"

  if [ ! -f "$src" ]; then
    return
  fi

  if [ -L "$dst" ]; then
    if $DRY_RUN; then
      echo "  [replace] $label (current: symlink -> $(readlink "$dst"))"
    else
      rm "$dst"
      cp "$src" "$dst"
      echo "  [restored] $label (symlink replaced with file)"
    fi
  elif [ -f "$dst" ]; then
    if diff -q "$src" "$dst" &>/dev/null; then
      echo "  [ok]      $label (identical, no change needed)"
    else
      if $DRY_RUN; then
        echo "  [replace] $label (content differs)"
        diff --color=auto -u "$dst" "$src" 2>/dev/null | head -10 | sed 's/^/             /'
      else
        cp "$src" "$dst"
        echo "  [restored] $label"
      fi
    fi
  else
    if $DRY_RUN; then
      echo "  [create]  $label (does not exist locally)"
    else
      mkdir -p "$(dirname "$dst")"
      cp "$src" "$dst"
      echo "  [created] $label"
    fi
  fi
}

# ZSH
restore_file "$EXTRACTED/zsh/.zshrc"            "$HOME/.zshrc"            ".zshrc"
restore_file "$EXTRACTED/zsh/.zsh_plugins.txt"   "$HOME/.zsh_plugins.txt"  ".zsh_plugins.txt"
restore_file "$EXTRACTED/zsh/.zprofile"           "$HOME/.zprofile"         ".zprofile"
restore_file "$EXTRACTED/zsh/.p10k.zsh"           "$HOME/.p10k.zsh"         ".p10k.zsh"
restore_file "$EXTRACTED/zsh/.zsh_plugins.zsh"   "$HOME/.zsh_plugins.zsh"  ".zsh_plugins.zsh (static)"

# Git
restore_file "$EXTRACTED/git/.gitconfig"         "$HOME/.gitconfig"        ".gitconfig"

# Vim
restore_file "$EXTRACTED/vim/.vimrc"             "$HOME/.vimrc"            ".vimrc"

# SSH
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
restore_file "$EXTRACTED/ssh/config"             "$HOME/.ssh/config"       ".ssh/config"

# Caches
echo ""
echo "Restoring caches..."
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
mkdir -p "$CACHE_DIR"
for cache in brew-shellenv.zsh fzf.zsh zoxide.zsh direnv.zsh thefuck.zsh; do
  restore_file "$EXTRACTED/cache/$cache" "$CACHE_DIR/$cache" "cache/$cache"
done

# Brewfile
if [ -f "$EXTRACTED/Brewfile" ]; then
  echo ""
  echo "Brewfile from backup:"
  echo "  $(wc -l < "$EXTRACTED/Brewfile" | tr -d ' ') entries"
  if $DRY_RUN; then
    echo "  (dry-run) Would not install Brewfile. Use install.sh or sync.sh for that."
  else
    echo "  Saved to $BACKUP_DIR/Brewfile.restored"
    cp "$EXTRACTED/Brewfile" "$BACKUP_DIR/Brewfile.restored"
    echo "  To install: brew bundle install --file=$BACKUP_DIR/Brewfile.restored"
  fi
fi

# --- Cleanup ---
rm -rf "$TMPDIR"

echo ""
echo "=================================================="
if $DRY_RUN; then
  echo "  Dry run complete. No changes were made."
  echo "  Run without --dry-run to apply."
else
  echo "  Restore complete!"
  echo ""
  echo "  Note: Restore replaces symlinks with plain files."
  echo "  To re-link to the repo, run: ./scripts/sync.sh --no-pull"
  echo ""
  echo "  Open a new terminal to load the restored config."
fi
echo "=================================================="

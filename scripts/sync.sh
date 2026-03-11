#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Dotfiles Sync (Deploy from repo to local machine)
#
# Pulls latest changes from the remote repo and applies them locally.
# Additive: installs new Brewfile entries without removing existing ones.
# Always creates a tgz backup before making any changes.
#
# Usage:
#   ./scripts/sync.sh              # Pull + backup + apply all
#   ./scripts/sync.sh --no-pull    # Skip git pull (use local repo state)
#   ./scripts/sync.sh --no-brew    # Skip Brewfile sync
#   ./scripts/sync.sh --dry-run    # Show what would change, don't apply
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"

DO_PULL=true
DO_BREW=true
DRY_RUN=false

for arg in "$@"; do
  case "$arg" in
    --no-pull) DO_PULL=false ;;
    --no-brew) DO_BREW=false ;;
    --dry-run) DRY_RUN=true ;;
    --help|-h)
      echo "Usage: sync.sh [--no-pull] [--no-brew] [--dry-run]"
      echo ""
      echo "  --no-pull   Skip git pull (apply from local repo state)"
      echo "  --no-brew   Skip Brewfile install (dotfiles only)"
      echo "  --dry-run   Show what would change without applying"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg (use --help for usage)"
      exit 1
      ;;
  esac
done

echo "=================================================="
echo "  Dotfiles Sync"
echo "  Repo: $DOTFILES_DIR"
echo "  Mode: $(if $DRY_RUN; then echo "DRY RUN"; else echo "LIVE"; fi)"
echo "=================================================="
echo ""

# --- Step 1: Pull latest from remote ---
if $DO_PULL; then
  echo "[1/5] Pulling latest changes..."
  if $DRY_RUN; then
    echo "  (dry-run) Would run: git pull"
    git -C "$DOTFILES_DIR" fetch --dry-run 2>&1 | sed 's/^/  /'
  else
    git -C "$DOTFILES_DIR" pull --ff-only 2>&1 | sed 's/^/  /'
  fi
else
  echo "[1/5] Skipping git pull (--no-pull)"
fi
echo ""

# --- Step 2: Create backup before applying changes ---
echo "[2/5] Creating backup of current local dotfiles..."
if $DRY_RUN; then
  echo "  (dry-run) Would create backup via backup.sh"
else
  "$SCRIPTS_DIR/backup.sh" "pre-sync" 2>&1 | sed 's/^/  /'
fi
echo ""

# --- Step 3: Diff and apply dotfiles ---
echo "[3/5] Syncing dotfiles..."

# Define file mappings: repo_path -> home_path
declare -a FILE_MAP=(
  "zsh/.zshrc|$HOME/.zshrc"
  "zsh/.zsh_plugins.txt|$HOME/.zsh_plugins.txt"
  "zsh/.zprofile|$HOME/.zprofile"
  "zsh/.p10k.zsh|$HOME/.p10k.zsh"
  "git/.gitconfig|$HOME/.gitconfig"
  "vim/.vimrc|$HOME/.vimrc"
  "ssh/config|$HOME/.ssh/config"
)

CHANGES=0
for mapping in "${FILE_MAP[@]}"; do
  repo_rel="${mapping%%|*}"
  home_path="${mapping##*|}"
  repo_path="$DOTFILES_DIR/$repo_rel"

  if [ ! -f "$repo_path" ]; then
    echo "  [skip] $repo_rel (not in repo)"
    continue
  fi

  # Resolve symlink target for comparison
  if [ -L "$home_path" ]; then
    link_target="$(readlink "$home_path")"
    if [ "$link_target" = "$repo_path" ]; then
      echo "  [ok]   $repo_rel (symlinked)"
      continue
    else
      echo "  [fix]  $repo_rel -> symlink points to $link_target, should be $repo_path"
      CHANGES=$((CHANGES + 1))
      if ! $DRY_RUN; then
        rm "$home_path"
        ln -s "$repo_path" "$home_path"
        echo "         Re-linked."
      fi
    fi
  elif [ -f "$home_path" ]; then
    # File exists but is not a symlink -- compare content
    if diff -q "$repo_path" "$home_path" &>/dev/null; then
      echo "  [ok]   $repo_rel (identical copy)"
    else
      echo "  [diff] $repo_rel (local differs from repo)"
      CHANGES=$((CHANGES + 1))
      if $DRY_RUN; then
        diff --color=auto -u "$home_path" "$repo_path" 2>/dev/null | head -20 | sed 's/^/         /'
        echo "         ... (use without --dry-run to apply)"
      else
        # Replace file with symlink to repo
        mv "$home_path" "${home_path}.replaced-by-sync"
        ln -s "$repo_path" "$home_path"
        echo "         Backed up old file and symlinked to repo."
      fi
    fi
  else
    # File doesn't exist locally
    echo "  [new]  $repo_rel (creating symlink)"
    CHANGES=$((CHANGES + 1))
    if ! $DRY_RUN; then
      mkdir -p "$(dirname "$home_path")"
      ln -s "$repo_path" "$home_path"
      echo "         Created symlink."
    fi
  fi
done

echo ""
echo "  $CHANGES file(s) changed."
echo ""

# --- Step 4: Brewfile (additive install) ---
if $DO_BREW; then
  echo "[4/5] Installing new Brewfile entries (additive)..."
  if $DRY_RUN; then
    echo "  (dry-run) Would run: brew bundle install --file=Brewfile --no-lock"
    echo "  Checking what would be installed:"
    brew bundle check --file="$DOTFILES_DIR/Brewfile" 2>&1 | sed 's/^/  /' || true
  else
    brew bundle install --file="$DOTFILES_DIR/Brewfile" --no-lock 2>&1 | sed 's/^/  /'
  fi
else
  echo "[4/5] Skipping Brewfile sync (--no-brew)"
fi
echo ""

# --- Step 5: Regenerate antidote plugins if .zsh_plugins.txt changed ---
echo "[5/5] Checking antidote plugins..."
PLUGINS_SRC="$DOTFILES_DIR/zsh/.zsh_plugins.txt"
PLUGINS_STATIC="$HOME/.zsh_plugins.zsh"

if [ ! -f "$PLUGINS_STATIC" ] || [ "$PLUGINS_SRC" -nt "$PLUGINS_STATIC" ]; then
  echo "  Plugins list changed, regenerating static file..."
  if $DRY_RUN; then
    echo "  (dry-run) Would regenerate .zsh_plugins.zsh"
  else
    if [ -f /opt/homebrew/opt/antidote/share/antidote/antidote.zsh ]; then
      zsh -c 'source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh && antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.zsh' 2>&1 | sed 's/^/  /'
      echo "  Done."
    else
      echo "  WARNING: antidote not found. Install with: brew install antidote"
    fi
  fi
else
  echo "  Plugins unchanged, no regeneration needed."
fi

# --- Clear stale caches so they regenerate on next shell startup ---
if ! $DRY_RUN && [ "$CHANGES" -gt 0 ]; then
  echo ""
  echo "Clearing tool caches (will auto-regenerate on next shell startup)..."
  rm -f "${XDG_CACHE_HOME:-$HOME/.cache}"/{brew-shellenv,fzf,zoxide,direnv,thefuck}.zsh 2>/dev/null
  rm -f "$HOME/.zshrc.zwc" "$HOME/.zcompdump"* 2>/dev/null
  echo "  Done."
fi

echo ""
echo "=================================================="
if $DRY_RUN; then
  echo "  Dry run complete. No changes were made."
  echo "  Run without --dry-run to apply."
else
  echo "  Sync complete!"
  echo ""
  echo "  Open a new terminal to load the updated config."
  echo "  Backup stored in: ~/.dotfiles-backups/"
fi
echo "=================================================="

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
#   ./scripts/sync.sh --no-brew    # Skip package sync
#   ./scripts/sync.sh --dry-run    # Show what would change, don't apply
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"
ECC_DIR="$DOTFILES_DIR/vendor/everything-claude-code"
OC_CONFIG="$HOME/.config/opencode"

# Load platform detection
source "$DOTFILES_DIR/scripts/lib/platform.sh"

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
  echo "[1/7] Pulling latest changes..."
  if $DRY_RUN; then
    echo "  (dry-run) Would run: git pull --recurse-submodules"
    git -C "$DOTFILES_DIR" fetch --dry-run 2>&1 | sed 's/^/  /'
  else
    git -C "$DOTFILES_DIR" pull --ff-only --recurse-submodules 2>&1 | sed 's/^/  /'
    git -C "$DOTFILES_DIR" submodule update --init --recursive 2>&1 | sed 's/^/  /'
  fi
else
  echo "[1/7] Skipping git pull (--no-pull)"
fi
echo ""

# --- Step 2: Create backup before applying changes ---
echo "[2/7] Creating backup of current local dotfiles..."
if $DRY_RUN; then
  echo "  (dry-run) Would create backup via backup.sh"
else
  "$SCRIPTS_DIR/backup.sh" "pre-sync" 2>&1 | sed 's/^/  /'
fi
echo ""

# --- Step 3: Diff and apply dotfiles ---
echo "[3/7] Syncing dotfiles..."

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

# --- Step 4: Sync OpenCode + ECC configuration ---
echo "[4/7] Syncing OpenCode + ECC configuration..."

mkdir -p "$OC_CONFIG" "$OC_CONFIG/plugins"

# File symlinks (our customized files)
declare -a OC_FILE_MAP=(
  "opencode/AGENTS.md|$OC_CONFIG/AGENTS.md"
  "opencode/opencode.json|$OC_CONFIG/opencode.json"
  "opencode/package.json|$OC_CONFIG/package.json"
)

# File symlink from ECC submodule
OC_FILE_MAP+=(
  "vendor/everything-claude-code/.opencode/plugins/ecc-hooks.ts|$OC_CONFIG/plugins/ecc-hooks.ts"
)

for mapping in "${OC_FILE_MAP[@]}"; do
  repo_rel="${mapping%%|*}"
  target_path="${mapping##*|}"
  repo_path="$DOTFILES_DIR/$repo_rel"

  if [ ! -f "$repo_path" ]; then
    echo "  [skip] $repo_rel (not in repo)"
    continue
  fi

  if [ -L "$target_path" ]; then
    link_target="$(readlink "$target_path")"
    if [ "$link_target" = "$repo_path" ]; then
      echo "  [ok]   $repo_rel (symlinked)"
      continue
    else
      echo "  [fix]  $repo_rel -> $link_target, should be $repo_path"
      CHANGES=$((CHANGES + 1))
      if ! $DRY_RUN; then
        rm "$target_path"
        ln -s "$repo_path" "$target_path"
        echo "         Re-linked."
      fi
    fi
  elif [ -f "$target_path" ]; then
    echo "  [fix]  $repo_rel (replacing file with symlink)"
    CHANGES=$((CHANGES + 1))
    if ! $DRY_RUN; then
      mv "$target_path" "${target_path}.replaced-by-sync"
      ln -s "$repo_path" "$target_path"
      echo "         Backed up old file and symlinked to repo."
    fi
  else
    echo "  [new]  $repo_rel (creating symlink)"
    CHANGES=$((CHANGES + 1))
    if ! $DRY_RUN; then
      mkdir -p "$(dirname "$target_path")"
      ln -s "$repo_path" "$target_path"
      echo "         Created symlink."
    fi
  fi
done

# Directory symlinks from ECC submodule
declare -a OC_DIR_MAP=(
  "vendor/everything-claude-code/.opencode/commands|$OC_CONFIG/commands"
  "vendor/everything-claude-code/.opencode/prompts|$OC_CONFIG/prompts"
  "vendor/everything-claude-code/.opencode/instructions|$OC_CONFIG/instructions"
  "vendor/everything-claude-code/skills|$OC_CONFIG/skills"
)

for mapping in "${OC_DIR_MAP[@]}"; do
  repo_rel="${mapping%%|*}"
  target_path="${mapping##*|}"
  repo_path="$DOTFILES_DIR/$repo_rel"

  if [ ! -d "$repo_path" ]; then
    echo "  [skip] $repo_rel (not in repo)"
    continue
  fi

  if [ -L "$target_path" ]; then
    link_target="$(readlink "$target_path")"
    if [ "$link_target" = "$repo_path" ]; then
      echo "  [ok]   $repo_rel/ (symlinked)"
      continue
    else
      echo "  [fix]  $repo_rel/ -> $link_target, should be $repo_path"
      CHANGES=$((CHANGES + 1))
      if ! $DRY_RUN; then
        rm "$target_path"
        ln -s "$repo_path" "$target_path"
        echo "         Re-linked."
      fi
    fi
  elif [ -d "$target_path" ]; then
    echo "  [fix]  $repo_rel/ (replacing directory with symlink)"
    CHANGES=$((CHANGES + 1))
    if ! $DRY_RUN; then
      mv "$target_path" "${target_path}.replaced-by-sync"
      ln -s "$repo_path" "$target_path"
      echo "         Backed up old directory and symlinked to repo."
    fi
  else
    echo "  [new]  $repo_rel/ (creating symlink)"
    CHANGES=$((CHANGES + 1))
    if ! $DRY_RUN; then
      ln -s "$repo_path" "$target_path"
      echo "         Created symlink."
    fi
  fi
done

# Install plugin SDK dependencies if needed
if ! $DRY_RUN && [ ! -d "$OC_CONFIG/node_modules/@opencode-ai" ]; then
  echo "  Installing OpenCode plugin dependencies..."
  if command -v bun &>/dev/null; then
    (cd "$OC_CONFIG" && bun install 2>&1 | sed 's/^/  /')
  elif command -v npm &>/dev/null; then
    (cd "$OC_CONFIG" && npm install 2>&1 | sed 's/^/  /')
  else
    echo "  WARNING: Neither bun nor npm found. Plugins may not work."
  fi
fi

echo ""

# --- Step 5: Package sync (additive install) ---
if $DO_BREW; then
  echo "[5/7] Installing new packages (additive)..."
  if [[ "$DOTFILES_OS" == "macos" ]]; then
    if $DRY_RUN; then
      echo "  (dry-run) Would run: brew bundle install --file=Brewfile --no-lock"
      echo "  Checking what would be installed:"
      brew bundle check --file="$DOTFILES_DIR/Brewfile" 2>&1 | sed 's/^/  /' || true
    else
      brew bundle install --file="$DOTFILES_DIR/Brewfile" --no-lock 2>&1 | sed 's/^/  /'
    fi
  else
    echo "  (Linux package sync deferred to Phase 1)"
  fi
else
  echo "[5/7] Skipping package sync (--no-brew)"
fi
echo ""

# --- Step 6: Regenerate antidote plugins if .zsh_plugins.txt changed ---
echo "[6/7] Checking antidote plugins..."
PLUGINS_SRC="$DOTFILES_DIR/zsh/.zsh_plugins.txt"
PLUGINS_STATIC="$HOME/.zsh_plugins.zsh"

if [ ! -f "$PLUGINS_STATIC" ] || [ "$PLUGINS_SRC" -nt "$PLUGINS_STATIC" ]; then
  echo "  Plugins list changed, regenerating static file..."
  if $DRY_RUN; then
    echo "  (dry-run) Would regenerate .zsh_plugins.zsh"
  else
    if [ -n "$DOTFILES_ANTIDOTE_PATH" ] && [ -f "$DOTFILES_ANTIDOTE_PATH" ]; then
      zsh -c "source $DOTFILES_ANTIDOTE_PATH && antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.zsh" 2>&1 | sed 's/^/  /'
      echo "  Done."
    else
      echo "  WARNING: antidote not found at $DOTFILES_ANTIDOTE_PATH"
    fi
  fi
else
  echo "  Plugins unchanged, no regeneration needed."
fi

# --- Step 7: Check for ECC submodule updates ---
echo ""
echo "[7/7] Checking ECC submodule status..."
if [ -d "$ECC_DIR/.git" ] || [ -f "$ECC_DIR/.git" ]; then
  ECC_LOCAL="$(git -C "$ECC_DIR" rev-parse --short HEAD 2>/dev/null || echo "unknown")"
  echo "  ECC pinned at commit: $ECC_LOCAL"
  if [ -f "$DOTFILES_DIR/.ecc-version" ]; then
    echo "  ECC version: $(sed -n '1p' "$DOTFILES_DIR/.ecc-version")"
  fi
  echo "  To check for upstream updates: ./scripts/update-ecc.sh --check"
else
  echo "  WARNING: ECC submodule not initialized. Run: git submodule update --init"
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

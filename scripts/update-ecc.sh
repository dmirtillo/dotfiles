#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# ECC (Everything Claude Code) Updater
#
# Updates the ECC git submodule to the latest upstream version and reports
# what changed. After updating, review the diff and decide whether to:
#   - Re-generate AGENTS.md rules (if upstream rules changed)
#   - Add new agents/commands to opencode.json (if upstream added them)
#   - Update the @opencode-ai/plugin SDK version (if required)
#
# Usage:
#   ./scripts/update-ecc.sh              # Update and show diff
#   ./scripts/update-ecc.sh --check      # Check for updates without applying
#   ./scripts/update-ecc.sh --regen-rules # Update + regenerate AGENTS.md from rules
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ECC_DIR="$DOTFILES_DIR/vendor/everything-claude-code"
OC_DIR="$DOTFILES_DIR/opencode"
VERSION_FILE="$DOTFILES_DIR/.ecc-version"

CHECK_ONLY=false
REGEN_RULES=false

for arg in "$@"; do
  case "$arg" in
    --check) CHECK_ONLY=true ;;
    --regen-rules) REGEN_RULES=true ;;
    --help|-h)
      echo "Usage: update-ecc.sh [--check] [--regen-rules]"
      echo ""
      echo "  --check        Check for updates without applying"
      echo "  --regen-rules  Update + regenerate AGENTS.md from upstream rules"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg (use --help for usage)"
      exit 1
      ;;
  esac
done

echo "=================================================="
echo "  ECC Updater"
echo "  Submodule: $ECC_DIR"
echo "=================================================="
echo ""

# --- Read current version ---
CURRENT_VERSION="unknown"
CURRENT_COMMIT="unknown"
if [ -f "$VERSION_FILE" ]; then
  CURRENT_VERSION="$(sed -n '1p' "$VERSION_FILE")"
  CURRENT_COMMIT="$(sed -n '2p' "$VERSION_FILE")"
fi

echo "Current ECC version: $CURRENT_VERSION (commit: $CURRENT_COMMIT)"
echo ""

# --- Fetch upstream ---
echo "[1/5] Fetching upstream changes..."
git -C "$ECC_DIR" fetch origin 2>&1 | sed 's/^/  /'

LOCAL_COMMIT="$(git -C "$ECC_DIR" rev-parse HEAD)"
REMOTE_COMMIT="$(git -C "$ECC_DIR" rev-parse origin/main)"

if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ]; then
  echo "  Already up to date."
  echo ""
  echo "=================================================="
  echo "  No updates available."
  echo "=================================================="
  exit 0
fi

# --- Show what changed ---
echo ""
echo "[2/5] Changes since $CURRENT_COMMIT:"
echo ""

COMMITS_BEHIND="$(git -C "$ECC_DIR" rev-list --count HEAD..origin/main)"
echo "  $COMMITS_BEHIND commit(s) behind origin/main"
echo ""

echo "  Changed files:"
git -C "$ECC_DIR" diff --stat HEAD..origin/main 2>/dev/null | sed 's/^/    /'
echo ""

# --- Check specific areas that affect our installation ---
echo "[3/5] Analyzing impact on our installation..."
echo ""

RULES_CHANGED=false
if git -C "$ECC_DIR" diff --name-only HEAD..origin/main | grep -q '^rules/'; then
  RULES_CHANGED=true
  echo "  [!] Rules files changed upstream:"
  git -C "$ECC_DIR" diff --name-only HEAD..origin/main | grep '^rules/' | sed 's/^/      /'
  echo "      Action: Run update-ecc.sh --regen-rules to rebuild AGENTS.md"
fi

AGENTS_CHANGED=false
if git -C "$ECC_DIR" diff --name-only HEAD..origin/main | grep -q '^\.opencode/opencode\.json'; then
  AGENTS_CHANGED=true
  echo "  [!] opencode.json changed upstream (may have new agents/commands)"
  echo "      Action: Review and manually add new entries to opencode/opencode.json"
fi

if git -C "$ECC_DIR" diff --name-only HEAD..origin/main | grep -q '^\.opencode/prompts/'; then
  echo "  [*] Agent prompts changed (auto-updated via symlinks)"
fi

if git -C "$ECC_DIR" diff --name-only HEAD..origin/main | grep -q '^\.opencode/commands/'; then
  echo "  [*] Command templates changed (auto-updated via symlinks)"
fi

if git -C "$ECC_DIR" diff --name-only HEAD..origin/main | grep -q '^\.opencode/plugins/'; then
  echo "  [*] Plugin hooks changed (auto-updated via symlinks)"
fi

NEW_SKILLS="$(git -C "$ECC_DIR" diff --name-only HEAD..origin/main | grep '^skills/' | sed 's|skills/\([^/]*\)/.*|\1|' | sort -u || true)"
if [ -n "$NEW_SKILLS" ]; then
  echo "  [*] Skills changed/added (auto-updated via symlinks):"
  echo "$NEW_SKILLS" | sed 's/^/      /'
fi

if git -C "$ECC_DIR" diff --name-only HEAD..origin/main | grep -q '^\.opencode/package\.json'; then
  echo "  [!] ECC package.json changed (may need SDK version bump)"
  echo "      Action: Check if @opencode-ai/plugin version needs updating"
fi

if git -C "$ECC_DIR" diff --name-only HEAD..origin/main | grep -q '^\.opencode/instructions/'; then
  echo "  [*] Instructions changed (auto-updated via symlinks)"
fi

echo ""

if $CHECK_ONLY; then
  echo "=================================================="
  echo "  Check complete. Run without --check to apply updates."
  echo "=================================================="
  exit 0
fi

# --- Apply update ---
echo "[4/5] Updating submodule to latest..."
git -C "$ECC_DIR" checkout main 2>/dev/null
git -C "$ECC_DIR" pull origin main 2>&1 | sed 's/^/  /'

NEW_VERSION="$(python3 -c "import json; print(json.load(open('$ECC_DIR/package.json'))['version'])" 2>/dev/null || echo "unknown")"
NEW_COMMIT="$(git -C "$ECC_DIR" rev-parse --short HEAD)"

echo "$NEW_VERSION" > "$VERSION_FILE"
echo "$NEW_COMMIT" >> "$VERSION_FILE"

echo "  Updated: $CURRENT_VERSION ($CURRENT_COMMIT) -> $NEW_VERSION ($NEW_COMMIT)"
echo ""

# --- Regenerate rules if requested ---
if $REGEN_RULES || $RULES_CHANGED; then
  echo "[5/5] Regenerating AGENTS.md from upstream rules..."

  cp "$OC_DIR/AGENTS.md" "$OC_DIR/AGENTS.md.pre-update"

  {
    cat "$ECC_DIR/rules/common/"*.md
    echo ""
    echo "# TypeScript Rules"
    echo ""
    cat "$ECC_DIR/rules/typescript/"*.md
    echo ""
    echo "# Python Rules"
    echo ""
    cat "$ECC_DIR/rules/python/"*.md
    echo ""
    echo "# Go Rules"
    echo ""
    cat "$ECC_DIR/rules/golang/"*.md
  } > "$OC_DIR/AGENTS.md"

  echo "  AGENTS.md regenerated from upstream rules."
  echo "  Previous version saved as AGENTS.md.pre-update"
  echo "  Review with: diff opencode/AGENTS.md.pre-update opencode/AGENTS.md"
else
  echo "[5/5] Rules unchanged, skipping AGENTS.md regeneration."
fi

echo ""

git -C "$DOTFILES_DIR" add vendor/everything-claude-code .ecc-version
if $REGEN_RULES || $RULES_CHANGED; then
  git -C "$DOTFILES_DIR" add opencode/AGENTS.md
fi

echo "=================================================="
echo "  ECC updated to v$NEW_VERSION ($NEW_COMMIT)"
echo ""
echo "  Staged changes (review before committing):"
git -C "$DOTFILES_DIR" diff --cached --stat 2>/dev/null | sed 's/^/    /'
echo ""
if $AGENTS_CHANGED; then
  echo "  MANUAL ACTION NEEDED:"
  echo "    Review upstream opencode.json for new agents/commands:"
  echo "    diff opencode/opencode.json vendor/everything-claude-code/.opencode/opencode.json"
  echo ""
fi
echo "  When ready, commit with:"
echo "    git commit -m \"chore: update ECC to v$NEW_VERSION\""
echo "=================================================="

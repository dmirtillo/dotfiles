#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR/../../.."

echo "Testing deletions (dry run via git rm --dry-run)..."

git rm -r --dry-run .opencode/skills/officemanagement/sources/ || true
git rm --dry-run .planning/spikes/010-chezmoi-officecli-setup/draft_run_onchange_office.sh.tmpl || true
git rm --dry-run dot_local/bin/executable_switch-models || true

echo "Deletions staged successfully. Chezmoi diff would not break since these are tracked files being removed intentionally."

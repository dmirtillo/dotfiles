#!/usr/bin/env bash
set -e

echo "1. Syncing Brewfile from system state (to ensure no drift before updates)..."
sync-brewfile

echo "2. Updating system packages (brew update && brew upgrade)..."
# brew update && brew upgrade # commented out for speed during testing

echo "3. Updating chezmoi (git pull)..."
# chezmoi update # commented out for testing

echo "4. Updating opencode SDK in chezmoi template..."
(
  cd "$(chezmoi source-path)/private_dot_config/private_opencode"
  npm install @opencode-ai/plugin@latest --save-exact
)

echo "5. Applying chezmoi to trigger GSD & plugin updates..."
# chezmoi apply # commented out to avoid polluting live env during spike

echo "6. Syncing Brewfile again to capture any new deps..."
sync-brewfile

echo "System update complete."

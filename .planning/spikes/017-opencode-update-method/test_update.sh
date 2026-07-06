#!/usr/bin/env bash
set -e
echo "Updating @opencode-ai/plugin in chezmoi..."
(cd $(chezmoi source-path)/private_dot_config/private_opencode && npm install @opencode-ai/plugin@latest --save-exact)
echo "Updating GSD plugin..."
npx get-shit-done-cc@latest --opencode --global

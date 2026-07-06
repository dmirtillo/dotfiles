#!/usr/bin/env bash
set -e

echo "Checking before uninstall..."
ls -ld ~/.config/opencode/get-shit-done || true
ls -ld ~/.config/opencode/prompts || true

echo "Running uninstall..."
npx get-shit-done-cc@latest --opencode --global --uninstall

echo "Checking after uninstall..."
ls -ld ~/.config/opencode/get-shit-done || echo "get-shit-done directory removed successfully."

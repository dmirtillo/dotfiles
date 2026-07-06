#!/usr/bin/env bash
set -e

echo "Running install..."
npx @opengsd/gsd-core@latest --opencode --global

echo "Checking after install..."
ls -ld ~/.config/opencode/get-shit-done || exit 1
echo "GSD core installed successfully."

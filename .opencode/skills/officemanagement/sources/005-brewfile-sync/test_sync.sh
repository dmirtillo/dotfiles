#!/usr/bin/env bash

DUMMY_BREWFILE=".planning/spikes/005-brewfile-sync/DummyBrewfile"

# Copy the real Brewfile
cp Brewfile "$DUMMY_BREWFILE"

echo "Original Dummy Brewfile (first 10 lines):"
head -n 10 "$DUMMY_BREWFILE"

echo -e "\nRunning brew bundle dump to update the dummy Brewfile..."
brew bundle dump --file="$DUMMY_BREWFILE" --force

echo -e "\nUpdated Dummy Brewfile (first 10 lines):"
head -n 10 "$DUMMY_BREWFILE"

echo -e "\nDiff:"
git diff --no-index Brewfile "$DUMMY_BREWFILE" || true

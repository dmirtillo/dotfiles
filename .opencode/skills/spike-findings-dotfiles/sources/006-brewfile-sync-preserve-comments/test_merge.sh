#!/usr/bin/env bash

TARGET_BREWFILE=".planning/spikes/006-brewfile-sync-preserve-comments/TargetBrewfile"
DUMP_FILE=".planning/spikes/006-brewfile-sync-preserve-comments/DumpBrewfile"
MERGED_FILE=".planning/spikes/006-brewfile-sync-preserve-comments/MergedBrewfile"

# Copy original to target
cp Brewfile "$TARGET_BREWFILE"
cp "$TARGET_BREWFILE" "$MERGED_FILE"

echo "Running brew bundle dump..."
brew bundle dump --file="$DUMP_FILE" --force

echo "Merging new dependencies..."

# Append section header if it doesn't exist
if ! grep -q "# NEWLY INSTALLED (UNCATEGORIZED)" "$MERGED_FILE"; then
  echo -e "\n# =============================================================================" >> "$MERGED_FILE"
  echo "# NEWLY INSTALLED (UNCATEGORIZED)" >> "$MERGED_FILE"
  echo "# =============================================================================" >> "$MERGED_FILE"
fi

# Find items in dump that aren't in the original
# We use regex to extract just the package line (ignoring trailing comments if any)
while read -r line; do
  # Skip empty lines
  [ -z "$line" ] && continue
  
  # Check if this exact line (or at least the core command, e.g., 'brew "jq"') exists in the original
  # Escaping quotes for grep
  escaped_line=$(echo "$line" | sed 's/"/\\"/g' | sed 's/\./\\./g')
  
  if ! grep -q "^$escaped_line" "$TARGET_BREWFILE"; then
    echo "Found new dependency: $line"
    echo "$line" >> "$MERGED_FILE"
  fi
done < "$DUMP_FILE"

echo -e "\nDiff between original and merged:"
git diff --no-index "$TARGET_BREWFILE" "$MERGED_FILE" || true

#!/usr/bin/env bash

# Test script for improving sync-brewfile
# Features needed:
# 1. Add packages UNDER the Uncategorized header if it exists.
# 2. Report packages in Brewfile that are NOT on the system.

BREWFILE="Brewfile.tmp"
cp "$(chezmoi source-path)/Brewfile" "$BREWFILE"

DUMP_FILE=$(mktemp)
MISSING_FILE=$(mktemp)
ORPHAN_FILE=$(mktemp)

trap 'rm -f "$DUMP_FILE" "$MISSING_FILE" "$ORPHAN_FILE" "$BREWFILE"' EXIT

echo "Generating current system dump..."
brew bundle dump --file=- 2>/dev/null > "$DUMP_FILE"

echo "Comparing..."
awk '
  NR==FNR {
    # System dump
    if (match($0, /^(tap|brew|cask|mas|vscode)[ \t]+("|\047)([^"\047]+)("|\047)/)) {
       type = $1
       match($0, /("|\047)([^"\047]+)("|\047)/)
       name = substr($0, RSTART+1, RLENGTH-2)
       sys[type ":" name] = $0
    }
    next
  }
  {
    # Tracked Brewfile
    line = $0
    sub(/#.*/, "", line)
    if (match(line, /^[ \t]*(tap|brew|cask|mas|vscode)[ \t]+("|\047)([^"\047]+)("|\047)/)) {
       type = $1
       match(line, /("|\047)([^"\047]+)("|\047)/)
       name = substr(line, RSTART+1, RLENGTH-2)
       tracked[type ":" name] = 1
       
       if (!(type ":" name in sys)) {
          print $0 > "'"$ORPHAN_FILE"'"
       }
    }
  }
  END {
    for (k in sys) {
       if (!(k in tracked)) {
          print sys[k] > "'"$MISSING_FILE"'"
       }
    }
  }
' "$DUMP_FILE" "$BREWFILE"

echo "Missing packages (on system, not in Brewfile):"
cat "$MISSING_FILE"
echo "Orphaned packages (in Brewfile, not on system):"
cat "$ORPHAN_FILE"

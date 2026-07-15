#!/bin/bash
set -e

FILE="test_hybrid.pptx"
echo "1. Creating $FILE"
officecli create "$FILE" > /dev/null
officecli add "$FILE" / --type slide > /dev/null
officecli add "$FILE" "/slide[1]" --type shape --prop text="Title Slide" --prop name="Title" > /dev/null
officecli add "$FILE" "/slide[1]" --type shape --prop text="Subtitle text here" --prop name="Subtitle" > /dev/null
officecli close "$FILE" > /dev/null

echo "2. Reading via Markitdown"
uvx --with 'markitdown[all]' markitdown "$FILE" > extracted.md
cat extracted.md | grep "Subtitle"

echo "3. AI decides to change the subtitle background color to red (structural edit)"
TARGET_TEXT="Subtitle text here"

echo "4. Finding DOM path using officecli query"
DOM_PATH=$(python3 .planning/spikes/044-officecli-markitdown-rework/query_wrapper.py "$FILE" "$TARGET_TEXT")
echo "   Found path: $DOM_PATH"

echo "5. Executing structural edit via officecli set"
officecli set "$FILE" "$DOM_PATH" --prop fill=FF0000 > /dev/null
officecli close "$FILE" > /dev/null

echo "6. Verifying edit via officecli query"
officecli query "$FILE" "$DOM_PATH" --json | grep -A 5 -B 5 "FF0000"

# Cleanup
rm -f "$FILE" extracted.md
echo "SUCCESS!"

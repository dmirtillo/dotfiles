#!/bin/bash

BASE_DOC=".planning/spikes/040-officecli-template-hydration/base_template.docx"
OUT_DOC=".planning/spikes/040-officecli-template-hydration/hydrated.docx"

echo "Creating base template..."
officecli create "$BASE_DOC"
officecli set "$BASE_DOC" /body --type paragraph --prop "text=Hello, {{ USER_NAME }}! Your ID is {{ USER_ID }}."
officecli close "$BASE_DOC"

echo "Hydrating template..."
cp "$BASE_DOC" "$OUT_DOC"
officecli set "$OUT_DOC" / --prop "find={{ USER_NAME }}" --prop "replace=Alice"
officecli set "$OUT_DOC" / --prop "find={{ USER_ID }}" --prop "replace=12345"
officecli close "$OUT_DOC"

echo "Validating hydrated document..."
uv run markitdown "$OUT_DOC"

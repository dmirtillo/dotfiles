#!/bin/bash
DOC_PATH=".planning/spikes/037-concurrent-officecli-resident-mode/concurrent.docx"
officecli create "$DOC_PATH"
officecli set "$DOC_PATH" / --prop "text=Base"
officecli close "$DOC_PATH"

echo "Running concurrent writes..."

# Run 10 writes in parallel
for i in {1..10}; do
  officecli add "$DOC_PATH" /body --type paragraph --prop "text=Concurrent Write $i" &
done

wait
echo "All concurrent writes finished. Flushing..."
officecli close "$DOC_PATH"

echo "Validating output with markitdown:"
uv run markitdown "$DOC_PATH"

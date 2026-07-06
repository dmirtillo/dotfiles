#!/bin/bash
# Mock an agent session executing a task against dummy.docx using the hybrid read/write pattern

echo "Starting Agent Session Simulation..."

# 1. READ phase using markitdown
echo "=== Step 1: Agent calls markitdown ==="
uv run markitdown .planning/spikes/036-full-skill-replacement-e2e/test_docs/dummy.docx
echo ""

# 2. WRITE phase using officecli
echo "=== Step 2: Agent edits the document via officecli ==="
officecli set .planning/spikes/036-full-skill-replacement-e2e/test_docs/dummy.docx /body/p[1] --prop "text=Edited Document Text from Agent"
echo ""

# 3. CLOSE phase (Required for markitdown hybrid pattern)
echo "=== Step 3: Agent runs officecli close ==="
officecli close .planning/spikes/036-full-skill-replacement-e2e/test_docs/dummy.docx
echo ""

# 4. VERIFY phase using markitdown again
echo "=== Step 4: Agent calls markitdown to verify ==="
uv run markitdown .planning/spikes/036-full-skill-replacement-e2e/test_docs/dummy.docx
echo ""

echo "Test complete."

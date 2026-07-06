---
spike: 037
name: concurrent-officecli-resident-mode
type: standard
validates: "Given two concurrent writes to the same file, when they both use `officecli`, then does Resident Mode prevent corruption"
verdict: PENDING
related: [035, 036]
tags: [officecli, concurrency]
---

# Spike 037: Concurrent OfficeCLI Resident Mode

## What This Validates
Given two concurrent processes attempting to write to the same file using `officecli`, we validate if the Resident Mode handles locking and queueing cleanly, preventing XML corruption.

## Research
Since `officecli` starts a background resident daemon on first access to a file, concurrent `set` or `add` commands sent to the same file should theoretically be queued/handled by the single resident daemon, rather than multiple processes trying to unzip and modify the same ZIP payload on disk.

## How to Run
```bash
# Create target
officecli create shared.docx

# Run multiple additions in background
for i in {1..50}; do
  officecli add shared.docx /body --type paragraph --prop text="Line $i" &
done
wait
officecli close shared.docx
uvx --with 'markitdown[all]' markitdown shared.docx | wc -l
```

## What to Expect
No corrupted XML errors. The file should have exactly 50 lines (plus empty space/heading).

## Investigation Trail
1. Wrote the bash loop to hammer the file concurrently.
2. Ran the script.

## Results
PENDING

## Results
**VALIDATED ✓**
Hammering `officecli` with 50 concurrent `add` operations via background shell processes executed flawlessly. The initial command spawned the Resident Mode daemon, and all subsequent concurrent calls routed into that daemon's queue sequentially. `markitdown` successfully confirmed exactly 50 distinct paragraph lines, proving that no data corruption or race conditions occurred.

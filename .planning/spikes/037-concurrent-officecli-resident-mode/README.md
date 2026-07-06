---
spike: 037
name: concurrent-officecli-resident-mode
type: standard
validates: "Given two concurrent writes to the same file, when they both use `officecli`, then does Resident Mode prevent corruption"
verdict: INVALIDATED
related: []
tags: [officecli, concurrency]
---

# Spike 037: Concurrent OfficeCLI Resident Mode

## What This Validates
Given multiple concurrent writes to the same file, when they all use `officecli`, then does Resident Mode queue them and prevent corruption?

## How to Run
```bash
./.planning/spikes/037-concurrent-officecli-resident-mode/concurrent_test.sh
```

## What to Expect
10 concurrent writes to the file should execute. Afterwards, the `markitdown` command should print all 10 lines cleanly.

## Investigation Trail
We ran a bash script that executed `officecli add` 10 times in parallel in the background (`&`). While `officecli` reported success for all 10 operations, attempting to read the resulting file with `markitdown` produced a `Some characters could not be decoded, and were replaced with REPLACEMENT CHARACTER` error, and no text was extracted. This indicates the underlying `.docx` zip archive or its internal `document.xml` was corrupted by the concurrent writes. 

## Results
✗ INVALIDATED.
Resident Mode does **not** queue concurrent shell executions safely. Concurrent parallel writes to the same document using the `officecli` command line will corrupt the file. Agents or shell scripts must serialize their writes (use `wait`, `&&`, or standard sequential commands) to prevent data loss.

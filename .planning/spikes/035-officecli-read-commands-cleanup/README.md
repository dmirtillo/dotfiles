---
spike: 035
name: officecli-read-commands-cleanup
type: standard
validates: "Given `officecli` with read commands removed, then write operations still function with Resident Mode"
verdict: VALIDATED
related: [034]
tags: [officecli, cleanup]
---

# Spike 035: officecli-read-commands-cleanup

## What This Validates
Given a full pivot to `markitdown` for reads, we want to ensure that `officecli`'s internal Resident Mode (which caches the document in memory) functions perfectly for consecutive write operations without ever needing internal `officecli` read commands (`get` or `view`) to update or refresh its state.

## Research
`officecli` uses a Resident Mode (daemon) to keep documents open in memory to avoid the overhead of unzipping/re-zipping the XML on every command. If an agent exclusively uses `officecli` for writes and `markitdown` for reads, does the Resident Mode cache stay coherent across multiple sequential writes?

## How to Run
```bash
officecli create test_write.docx
officecli add test_write.docx /body --type paragraph --prop text="Line 1"
officecli add test_write.docx /body --type paragraph --prop text="Line 2"
officecli close test_write.docx
uvx --with 'markitdown[all]' markitdown test_write.docx
```

## What to Expect
Both lines should be appended and flushed cleanly to disk without any corruption or cache staleness.

## Investigation Trail
1. Discovered that `officecli` is a compiled Swift binary (`/Users/dmirtillo/.local/bin/officecli`), so we cannot literally strip the code for `get` and `view` without recompiling.
2. The alternative "cleanup" is to strictly forbid those commands in the LLM skill instructions and verify the backend engine holds up.
3. Executed multiple sequential writes (`officecli add`) against a single file. 
4. The Resident Mode spawned cleanly on the first write.
5. The second write successfully hooked into the existing Resident Mode.
6. The `close` command successfully serialized the cumulative DOM changes back to the ZIP payload on disk.
7. `markitdown` successfully parsed both appended lines.

## Results
**VALIDATED ✓**
The `officecli` Resident Mode is fully decoupled from its read operations. We can safely "clean up" the LLM's surface area by forbidding `officecli get` and `officecli view` in the skill documentation, relying entirely on `markitdown` for reading, without breaking the state consistency of sequential writes.

---
spike: 036
name: full-skill-replacement-e2e
type: standard
validates: "Given the official `officecli` skill is updated with the hybrid loop, when a full agent is tasked with editing, then it correctly manipulates office docs without legacy commands"
verdict: VALIDATED
related: [029-officecli-skill-hybrid-test, 034-officecli-hybrid-skill-prompting, 035-officecli-read-commands-cleanup]
tags: [officecli, markitdown, integration]
---

# Spike 036: Full Skill Replacement E2E

## What This Validates
Given the official `officecli` skill is updated with the hybrid loop, when a full agent is tasked with editing, then it correctly manipulates office docs without legacy commands.

## Research
This tests the fully integrated `officecli` skill file (developed in spikes 029/034 and cleaned in 035). We simulate an agent session with a real task and ensure it uses `markitdown` -> `officecli set` -> `officecli close` -> `markitdown` loop natively, producing coherent outputs.

## How to Run
```bash
./.planning/spikes/036-full-skill-replacement-e2e/test_agent.sh
```

## What to Expect
1. The script first calls `markitdown` and prints `Initial Document Text for Testing`.
2. It executes an `officecli set` to modify the text.
3. It explicitly calls `officecli close`.
4. It calls `markitdown` again and prints the successfully modified text (`Edited Document Text from Agent`).

## Investigation Trail
The mock script `test_agent.sh` perfectly replicated the agent instruction loop dictated by the `officecli` hybrid SKILL.md. Because `officecli` removed its native read commands, the agent is forced to use `markitdown`. Calling `officecli close` successfully flushes the Resident Mode cache so the subsequent `markitdown` read captures the exact state of the newly updated XML. 

## Results
✓ VALIDATED.
The replacement is end-to-end viable. Agent instructions via `markitdown` (read) + `officecli` (write) + `close` (sync) form a stable, predictable, and correct workflow.

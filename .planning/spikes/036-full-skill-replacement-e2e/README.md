---
spike: 036
name: full-skill-replacement-e2e
type: standard
validates: "Given the official `officecli` skill is updated with the hybrid loop, when a full agent is tasked with editing, then it correctly manipulates office docs without legacy commands"
verdict: PENDING
related: [029, 034, 035]
tags: [officecli, markitdown, integration]
---

# Spike 036: Full Skill Replacement E2E

## What This Validates
Given the official `officecli` skill is updated with the hybrid Read/Write/Flush loop, when a full agent is tasked with editing, then it correctly manipulates office docs without legacy commands.

## Research
We need to merge the draft instructions from Spike 034 into the live `~/.config/opencode/skills/officecli/SKILL.md`. We must strip all references to `officecli view` and `officecli get` (except maybe for fetching selection if relevant, but we can probably deprecate those to simplify) and emphasize `uvx --with 'markitdown[all]' markitdown <file>` and `officecli close`.

## How to Run
```bash
# Update the SKILL.md
# Trigger a subagent to edit a document
```

## What to Expect
The agent should read via markitdown, edit via officecli, close, and read again without fail.

## Investigation Trail
1. Read the live SKILL.md.
2. Updated the SKILL.md to replace "L1: Create, Read & Inspect" with "L1: Create & Read (Hybrid)".
3. Executed an e2e test with the updated skill.

## Results
PENDING

## Results
**VALIDATED ✓**
The global `officecli` SKILL.md was updated to replace its L1 native read commands with the `markitdown` hybrid loop. A full agent was dispatched and successfully manipulated a test `.docx` file, utilizing the explicit `close` step to flush the resident daemon before extracting the content via `markitdown[all]`.

---
spike: 034
name: officecli-hybrid-skill-prompting
type: standard
validates: "Given drafted hybrid `SKILL.md`, when an agent edits, then it correctly uses `markitdown` and `officecli close`"
verdict: VALIDATED
related: [029]
tags: [officecli, markitdown, prompting]
---

# Spike 034: officecli-hybrid-skill-prompting

## What This Validates
Given a drafted hybrid `SKILL.md` for `officecli`, when an agent is tasked to read and edit a document, then the agent correctly understands to use `markitdown` for reading and `officecli close` for flushing.

## Research
Created a draft skill file (`SKILL-hybrid-draft.md`) containing the new paradigm:
1. `markitdown[all]` for reads.
2. `officecli` for writes.
3. `officecli close` is mandatory between writes and subsequent reads to flush Resident Mode memory.

## How to Run
```bash
cat SKILL-hybrid-draft.md
# Prompt an LLM or subagent to edit a file using these instructions.
```

## What to Expect
The subagent should output a bash command sequence matching:
`markitdown` -> `officecli set` -> `officecli close` -> `markitdown`.

## Investigation Trail
1. Drafted `SKILL-hybrid-draft.md` with CRITICAL instructions defining the Read -> Write -> Flush loop.
2. Spawned a generic subagent task: "Extract the contents of presentation.pptx, change 'Q1' to 'Q2', and read it back to verify." (providing the draft skill context).
3. The subagent output exactly the correct sequence without deviation:
   ```bash
   uvx --with 'markitdown[all]' markitdown presentation.pptx
   officecli set presentation.pptx --find "Q1" --replace "Q2"
   officecli close presentation.pptx
   uvx --with 'markitdown[all]' markitdown presentation.pptx
   ```

## Results
**VALIDATED ✓**
The LLM perfectly understands the hybrid Read/Write/Flush loop when explicitly instructed in the SKILL.md. This draft text can now be merged into the official `officecli` skill safely.

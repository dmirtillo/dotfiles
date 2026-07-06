---
spike: 036
name: full-skill-replacement-e2e
type: standard
validates: "Given the official `officecli` skill is updated with the hybrid loop, when a full agent is tasked with editing, then it correctly manipulates office docs without legacy commands"
verdict: PENDING
related: [029-officecli-skill-hybrid-test, 034-officecli-hybrid-skill-prompting, 035-officecli-read-commands-cleanup]
tags: [officecli, markitdown, integration]
---

# Spike 036: Full Skill Replacement E2E

## What This Validates
Given the official `officecli` skill is updated with the hybrid loop, when a full agent is tasked with editing, then it correctly manipulates office docs without legacy commands.

## Research
This tests the fully integrated `officecli` skill file (developed in spikes 029/034 and cleaned in 035). We need to launch an agent session with a real task and ensure it uses `markitdown` -> `officecli set` -> `officecli close` -> `markitdown` loop natively.

## How to Run
N/A

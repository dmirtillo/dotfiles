---
spike: 029
name: officecli-skill-hybrid-test
type: standard
validates: "Given the existing `officecli` GSD skill, when tasked to extract and edit a document, then it successfully uses the `markitdown` hybrid approach without error"
verdict: PARTIAL
related: [008, 009, 010, 011, 012, 013, 014]
tags: [officecli, markitdown, integration]
---

# Spike 029: OfficeCLI Skill Hybrid Test

## What This Validates
Given the existing `officecli` GSD skill, when tasked to extract and edit a document, then it successfully uses the `markitdown` hybrid approach without error.

## Research
- The hybrid approach involves writing to Office docs using `officecli` and reading them using `markitdown`.
- We reviewed the global `officecli` GSD skill documentation (`~/.config/opencode/skills/officecli/SKILL.md`).
- We also reviewed `CONVENTIONS.md` which details how to invoke `markitdown[all]` via `uvx` and mentions the mandatory `officecli close` step.

## How to Run
```bash
cd .planning/spikes/029-officecli-skill-hybrid-test
officecli create doc.docx
officecli add doc.docx /body --type paragraph --prop text="Executive Summary" --prop style=Heading1
officecli close doc.docx
uvx --with 'markitdown[all]' markitdown doc.docx
```

## What to Expect
- Document is created and written using `officecli`.
- Changes are flushed via `close`.
- Document is correctly parsed into Markdown by `markitdown`.

## Investigation Trail
1. Read the global `officecli` SKILL.md. Discovered that the skill **entirely lacks** any mention of `markitdown` or the hybrid approach. It still recommends using `officecli get` and `officecli view` for all reads.
2. Created a test document using `officecli create` and `officecli add`.
3. Ran `uvx --from markitdown markitdown doc.docx`. This threw a `MissingDependencyException` due to missing `[docx]` or `[all]` extras, confirming the pitfall outlined in `CONVENTIONS.md`.
4. Re-ran with `uvx --with 'markitdown[all]' markitdown doc.docx`, which successfully extracted the `# Executive Summary` text.

## Results

**⚠ PARTIAL**

The hybrid mechanism (write with `officecli`, flush with `officecli close`, read with `markitdown[all]`) works perfectly at the technical level. However, the `officecli` GSD skill itself has not been updated to adopt or document this approach. As it stands, an agent loading the `officecli` skill will default to native `officecli` view commands and will fail to use `markitdown`, or if instructed to use it, might trip over the missing `[all]` dependency. The SKILL.md requires a rewrite to fully embrace the hybrid pattern.
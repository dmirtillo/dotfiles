---
spike: 041
name: gemini-ponytail-install
type: standard
validates: "Given Gemini CLI, when ponytail is installed via extension URL, then it is recognized and loaded"
verdict: VALIDATED
related: []
tags: [gemini, ponytail]
---

# Spike 041: Gemini Ponytail Install

## What This Validates
Given Gemini CLI, when ponytail is installed via extension URL, then it is recognized and loaded.

## How to Run
```bash
gemini extensions install https://github.com/DietrichGebert/ponytail --consent
gemini -p "list available skills, particularly checking for ponytail skills."
```

## What to Expect
The installation succeeds without interactive prompts (thanks to `--consent`) and the Gemini CLI subsequently acknowledges the availability of `ponytail`, `ponytail-review`, `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, and `ponytail-help`.

## Investigation Trail
We first tried `gemini extensions install` without the `--consent` flag which timed out after waiting for interactive confirmation. Once `--consent` was added, it installed version `4.8.4` from the github release correctly. The `gemini extensions list` command verified its presence. Finally, executing `gemini -p "list available skills..."` correctly loaded the extension skills into the agent context, confirming the installation is functional.

## Results
✓ VALIDATED. 
Gemini CLI loads the ponytail extension successfully. The issue "ponytail still doesnt load into gemini" does not persist on this clean install when using the `--consent` flag and running via `gemini -p`. 

---
spike: 016
name: ponytail-gemini-config
type: standard
validates: "Given Gemini CLI, when ponytail is installed via extensions, then Gemini CLI correctly loads ponytail hooks/instructions"
verdict: VALIDATED
related: []
tags: [gemini-cli, ponytail, extension]
---

# Spike 016: Ponytail Gemini Configuration

## What This Validates
Given Gemini CLI, when ponytail is installed via extensions, then Gemini CLI correctly loads ponytail hooks/instructions

## Research
Ponytail README states that Gemini CLI can install ponytail via:
`gemini extensions install https://github.com/DietrichGebert/ponytail`
This copies the skills and integrates it into the `~/.gemini/` configurations.

## How to Run
```bash
echo "Y" | gemini extensions install https://github.com/DietrichGebert/ponytail
gemini extensions list
```

## What to Expect
Gemini CLI lists `ponytail` as an installed and enabled extension, and its skills (ponytail, ponytail-review, etc.) are available.

## Investigation Trail
1. Checked if `gemini` CLI exists (v0.46.0).
2. Checked if `ponytail` was already installed with `gemini extensions list` (it was not).
3. Executed `echo "Y" | gemini extensions install https://github.com/DietrichGebert/ponytail` to install it.
4. Extension installed successfully and enabled.

## Results
VALIDATED. Ponytail is successfully installed and configured for Gemini CLI via the extensions system.

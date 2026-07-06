---
spike: 015
name: ponytail-opencode-config
type: standard
validates: "Given OpenCode config, when ponytail is added as a plugin, then OpenCode correctly loads the ponytail hooks/instructions"
verdict: VALIDATED
related: []
tags: [opencode, ponytail, plugin]
---

# Spike 015: Ponytail OpenCode Configuration

## What This Validates
Given OpenCode config, when ponytail is added as a plugin, then OpenCode correctly loads the ponytail hooks/instructions

## Research
Ponytail instructions mention that OpenCode uses `~/.config/opencode/opencode.json` where it should include `"plugin": ["@dietrichgebert/ponytail"]`. The plugin should be installed in `~/.config/opencode/node_modules/@dietrichgebert/ponytail`.

## How to Run
```bash
cat ~/.config/opencode/opencode.json | grep ponytail
ls -l ~/.config/opencode/node_modules/@dietrichgebert/ponytail
```

## What to Expect
Output confirming ponytail is configured in opencode.json and the package exists.

## Investigation Trail
1. Checked `~/.config/opencode/opencode.json` - found `"plugin": ["@dietrichgebert/ponytail"]`
2. Verified `node_modules` existence in `~/.config/opencode/`
3. Verified OpenCode currently has the `ponytail` skill loaded based on my own runtime instructions (`<available_skills>`).

## Results
VALIDATED. Ponytail is successfully configured for OpenCode and actively loaded.

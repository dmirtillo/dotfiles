---
spike: 032
name: gsd-core-skill-collision
type: standard
validates: "Given custom `officecli` skill, when `gsd-core` updates, then custom modifications are preserved"
verdict: VALIDATED
related: [022, 029]
tags: [gsd-core, officecli, collision]
---

# Spike 032: gsd-core-skill-collision

## What This Validates
Given a customized `officecli` skill in `~/.config/opencode/skills/`, when `npx @opengsd/gsd-core@latest` runs, then the custom modifications are preserved.

## Research
Tested the `npx @opengsd/gsd-core@latest` installer using a sandboxed `--config-dir` to observe its behavior on pre-existing skills and custom skill directories.

## How to Run
```bash
# Create custom skill
mkdir -p test-config/skills/officecli
echo "Custom Content" > test-config/skills/officecli/SKILL.md

# Run installer
npx @opengsd/gsd-core@latest --opencode --global --config-dir "$(pwd)/test-config"

# Verify custom skill is preserved
cat test-config/skills/officecli/SKILL.md
```

## What to Expect
The installer should not overwrite the `officecli` skill.

## Investigation Trail
1. Created a sandbox directory with a fake `officecli/SKILL.md` containing `Custom Content`.
2. Executed `npx @opengsd/gsd-core@latest` into that sandbox.
3. Observed that the installer output stated: `preserved 1 user baseline file`.
4. The `officecli/SKILL.md` file remained unmodified.
5. Further investigation revealed that `gsd-core` does not actually bundle an `officecli` skill at all; it only bundles `gsd-*` prefixed skills. Thus, any skill directory like `officecli` is completely ignored by the installer and left intact.

## Results
**VALIDATED ✓**
Custom modifications to the `officecli` skill are 100% safe from collisions with `gsd-core` updates. The core installer ignores non-`gsd-*` skills entirely.

---
spike: 033
name: uv-mise-path-integration
type: standard
validates: "Given `mise` and `uv tool`, when a script runs, then `markitdown` is found without PATH conflicts"
verdict: VALIDATED
related: [010, 030]
tags: [mise, uv, path]
---

# Spike 033: uv-mise-path-integration

## What This Validates
Given `mise` and `uv tool`, when a script runs, `markitdown` is correctly found in PATH without conflicts, and it retains the `[all]` extras required to parse Office documents.

## Research
`mise`'s shims (`~/.local/share/mise/shims`) are prepended to the PATH before `~/.local/bin` (where `uv tool install` places binaries). If `mise` manages `pipx:markitdown`, it intercepts the `markitdown` command. 

## How to Run
```bash
# Test mise failure
mise use -g pipx:'markitdown[all]'
markitdown test.docx # Fails with MissingDependencyException

# Fix via uv
mise rm pipx:markitdown
uv tool install --force "markitdown[all]"
markitdown test.docx # Succeeds
```

## What to Expect
`mise` strips package extras (`[all]`) when installing Python CLI tools via its `pipx` backend. `uv tool install` correctly processes them.

## Investigation Trail
1. Checked `$PATH`. `~/.local/share/mise/shims` has priority over `~/.local/bin`.
2. Discovered `pipx:markitdown` was registered in `~/.config/mise/config.toml`.
3. Ran `markitdown test.docx` while managed by `mise`. It crashed with `MissingDependencyException` for `[docx]`, proving `mise` ignored the `[all]` extras.
4. Attempted `mise use -g pipx:'markitdown[all]'`. `mise` stripped the brackets and reinstalled vanilla `markitdown`.
5. Uninstalled `pipx:markitdown` from `mise` completely.
6. Reinstalled via `uv tool install --force "markitdown[all]"`.
7. `which markitdown` fell through the `mise` shims and cleanly resolved to `/Users/dmirtillo/.local/bin/markitdown`.
8. `markitdown test.docx` successfully read the file without missing dependencies.

## Results
**VALIDATED ✓**
Do NOT use `mise` to manage Python CLI tools that require bracketed extras (like `markitdown[all]`). Remove them from `mise` and use `uv tool install "package[extra]"`. The shell PATH will seamlessly fall back to `~/.local/bin` when no `mise` shim exists, avoiding all conflicts.

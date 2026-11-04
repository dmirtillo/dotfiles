---
phase: quick
date: 2026-11-04
status: complete
---

# Quick Task: Install Craft app suite (macOS + Linux) and wire MCP servers

## Task

Remove the `artcraft-launcher` cask, install GridCraft, PdfCraft, WordCraft, DeckCraft and PhotoCraft (the Photoshop equivalent) individually via Homebrew cask, add the same apps as AUR packages for Arch Linux, and configure every available Craft MCP server in OpenCode.

## Findings

- Casks exist for all five apps: `gridcraft`, `pdfcraft`, `wordcraft`, `deckcraft`, `photocraft`.
- "Photoshop" maps to `photocraft` (PhotoCraft image editor) — there is no `photoshop` cask.
- CLI/MCP formulae exist for four of the five: `gridcraft-cli`, `pdfcraft-cli`, `wordcraft-cli`, `photocraft-cli`.
- **DeckCraft ships no CLI/MCP server** — `deckcraft-cli` does not exist as a formula. DeckCraft is app-only.
- AUR packages exist for all five apps: `gridcraft`, `pdfcraft`, `wordcraft`, `deckcraft`, `photocraft` (no `-cli` variants on AUR).
- The CLIs resolve to `/opt/homebrew/bin/<name>-cli` on macOS and `/usr/bin/<name>-cli` on Arch (via AUR), so the config resolves per-platform.

## Files changed

- `Brewfile` — added `pdfcraft-cli`, `photocraft-cli`, `wordcraft-cli` formulae; added `gridcraft`, `pdfcraft`, `wordcraft`, `deckcraft`, `photocraft` casks; `artcraft-launcher` was never tracked here (installed manually) so only the live uninstall applies.
- `Pacfile` — added the five AUR app packages under a new Craft App Suite section.
- `run_onchange_setup-opencode.sh.tmpl` — replaced the single hardcoded gridcraft MCP block with a loop registering `gridcraft`, `pdfcraft`, `wordcraft` and `photocraft` MCP servers, resolving each binary across Homebrew prefixes and PATH.

## Applied

- `brew uninstall --cask artcraft-launcher`
- `brew install --cask gridcraft pdfcraft wordcraft deckcraft photocraft`
- `brew install pdfcraft-cli wordcraft-cli photocraft-cli gridcraft-cli`
- `chezmoi apply` — regenerated `~/.config/opencode/opencode.json`; all four Craft MCP servers loaded successfully in OpenCode.

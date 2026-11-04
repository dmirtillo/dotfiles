---
phase: quick
quick_id: 261104-craft
status: complete
date: 2026-11-04
---

# Summary: Craft app suite install + MCP wiring

## Outcome

All requested apps installed and every available Craft MCP server is live in OpenCode.

## Done

1. **Removed** `artcraft-launcher` cask (`brew uninstall --cask artcraft-launcher`).
2. **Installed** five app casks: `gridcraft`, `pdfcraft`, `wordcraft`, `deckcraft`, `photocraft`. The stale `/Applications/*Craft.app` bundles left by the launcher were moved aside so cask could adopt fresh installs.
3. **Installed** the three missing CLI/MCP formulae: `pdfcraft-cli`, `wordcraft-cli`, `photocraft-cli` (gridcraft-cli already present).
4. **Brewfile** tracks the three new CLI formulae and all five casks.
5. **Pacfile** now lists the five AUR packages (`gridcraft`, `pdfcraft`, `wordcraft`, `deckcraft`, `photocraft`) so Arch Linux resolves them via `yay`.
6. **opencode.json** (via `run_onchange_setup-opencode.sh.tmpl`) registers four MCP servers — `gridcraft`, `pdfcraft`, `wordcraft`, `photocraft` — each resolving its CLI across `/opt/homebrew/bin`, `/usr/local/bin` and PATH. `chezmoi apply` verified all four load.

## Deliberate exclusions

- **DeckCraft MCP:** no `deckcraft-cli` exists (formula or AUR). DeckCraft has no CLI/MCP server, so nothing to register. Revisit if ArtCraft ships one.
- **AUR CLI packages:** AUR only carries the apps, not `-cli` variants, so the Linux MCP servers use the app-bundled CLI on PATH if present; otherwise the servers are simply absent. Add AUR `-cli` packages when they appear.

## Verification

- `brew list --cask` shows the five apps, no `artcraft-launcher`.
- `~/.config/opencode/opencode.json` contains the four Craft MCP entries with resolved `/opt/homebrew/bin/*-cli` paths.
- OpenCode loaded 22 gridcraft, 184 pdfcraft, 17 wordcraft and 26 photocraft tools at session start.

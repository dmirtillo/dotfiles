---
status: complete
date: 2026-09-14
commit: 22e115d
---

# Quick Task: Audit Tools Installed with uv and Migrate to AUR / mise

Audited tools installed via `uv tool` and evaluated AUR vs `mise` packaging.

## Audit Findings
1. **`markitdown`**:
   - **AUR (Priority)**: `aur/markitdown-bin` is available (version 0.1.7-1). It builds an isolated venv with all extras (`[all]`) included and symlinks `/usr/bin/markitdown`.
   - **`mise`**: Confirmed constraint documented in Spike 030/033: `mise`'s `pipx:` backend strips bracketed extras (`[all]`), causing `MissingDependencyException` on Word/PowerPoint files. Therefore, `mise` is unsuitable for `markitdown`.
   - **Decision**: Added `markitdown-bin` to AUR section in `Pacfile`.
2. **`litellm`**:
   - A dangling, broken environment for `litellm` existed in `~/.local/share/uv/tools/` (uninstalled via `uv tool uninstall litellm`).
   - `litellm` is already properly packaged and installed via AUR (`/usr/bin/litellm` from `aur/litellm`) and listed in `Pacfile`.
3. **No other global tools** were installed under `uv tool`.

## Dotfiles Updates
- **`Pacfile`**: Added `markitdown-bin` under `# AUR`.
- **`run_onchange_install-packages.sh.tmpl`**: Changed `markitdown` setup to be an optional fallback only if `markitdown` is not already provided by system/AUR packages.

## Verification
- `yay -Si markitdown-bin` verified package availability and PKGBUILD correctness.
- Cleaned up dangling `litellm` venv in `uv`.

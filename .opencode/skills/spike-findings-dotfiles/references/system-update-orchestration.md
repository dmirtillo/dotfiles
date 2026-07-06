# System Update Orchestration

## Requirements

- Ensure no local state is lost during updates (Brewfile sync must happen before and after updates).
- Orchestrated updates should follow a 5-step sequence: Pre-Sync Brewfile -> System Update -> Chezmoi Update -> Component Version Bumps -> Chezmoi Apply -> Post-Sync Brewfile.
- The `sync-brewfile` logic should explicitly identify missing packages (to append) and orphaned packages (to alert the user), rather than blindly appending to the end of the file.

## How to Build It

The update flow should be wrapped in a single, coherent bash script that executes these 5 steps securely:

1. **Pre-Sync Brewfile**: Run `sync-brewfile`. This guarantees that any local `brew install` commands run manually since the last sync are safely captured into the tracked `Brewfile`.
2. **System Update**: Run `brew update && brew upgrade`.
3. **Chezmoi Source Update**: Run `chezmoi update` to fetch latest dotfiles templates.
4. **Component Bumps**: Update the `@opencode-ai/plugin` SDK inside the chezmoi source directory (this modifies `package.json`). 
   ```bash
   (cd $(chezmoi source-path)/private_dot_config/private_opencode && npm install @opencode-ai/plugin@latest --save-exact)
   ```
5. **Chezmoi Apply**: Run `chezmoi apply`. This triggers `run_onchange_setup-opencode.sh.tmpl` because the `package.json` SHA hash changed, automatically updating the GSD tool logic via `npm install` and `npx @opengsd/gsd-core@latest`.
6. **Post-Sync Brewfile**: Run `sync-brewfile` again to capture any new dependencies pulled during the update.

**Robust `sync-brewfile` logic:**
Use the `awk` script developed in Spike 018 that compares the `brew bundle dump --file=-` output against the tracked `Brewfile` line by line, appending missing packages to `# NEWLY INSTALLED (UNCATEGORIZED)` and listing out "orphaned" packages.

## What to Avoid

- **Blind Appends**: Do not append missing Brew packages to the absolute EOF without checking for the `# NEWLY INSTALLED` header.
- **Overwriting Comments**: Do not use `brew bundle dump --file=Brewfile --force` directly on the tracked Brewfile, as this completely destroys all user comments, structural headers, and custom organization (as seen in Spike 005).
- **Silent Orphans**: Do not ignore packages that are in the tracked `Brewfile` but have been removed from the system. The sync script should surface these orphans for pruning.
- **Manual SDK Updates**: Do not run `npm install` directly in `~/.config/opencode` for updates, as `chezmoi apply` will overwrite or ignore this state unless the source `package.json` is updated.

## Constraints

- The OpenCode SDK component must be updated via its `package.json` in the chezmoi source directory to ensure the `run_onchange` trigger detects the update correctly.

## Origin

Synthesized from spikes: 017, 018, 019, 020
Source files available in: sources/017-opencode-update-method/, sources/018-sync-brewfile-review/, sources/019-orchestrated-update-flow/, sources/020-workflow-docs-generation/

# GSD Core Migration

## Requirements

- Ensure the migration from `get-shit-done-cc` to `@opengsd/gsd-core` is clean and does not leave orphaned files.
- Ensure automated installation and orchestration scripts correctly invoke the new installer.
- Ensure the structural shift in the configuration directory (from `get-shit-done` to `gsd-core`) is accounted for in all references.

## How to Build It

1. **Clean Uninstallation:** Always use the old installer's uninstall command to cleanly scrub the system before shifting to the new one.
   ```bash
   npx get-shit-done-cc@latest --opencode --global --uninstall
   ```
2. **Installation:** Use the new scoped package name with identical flags.
   ```bash
   npx @opengsd/gsd-core@latest --opencode --global
   ```
3. **Chezmoi Orchestration:** Update all `.tmpl` setup scripts (like `run_onchange_setup-opencode.sh.tmpl` and `run_onchange_setup-antigravity.sh.tmpl`) to invoke the new package.
4. **Reference Updates:** Any documentation or scripts pointing to `~/.config/opencode/get-shit-done` must be updated to point to `~/.config/opencode/gsd-core`.

## What to Avoid

- **Manual Deletion:** Do not attempt to manually delete the old `get-shit-done` folder or commands. Using the provided `--uninstall` flag properly removes hooks, commands, and `opencode.json` modifications safely.
- **Legacy References:** Avoid leaving references to `get-shit-done-cc` in documentation or setup scripts, as they will pull deprecated code.

## Constraints

- The new `@opengsd/gsd-core` package natively replaces the functionality of `get-shit-done-cc`.
- The `command/` and `skills/` directories in the `.config` path function exactly the same, but internal assets (like workflows) are relocated.

## Origin

Synthesized from spikes: 021, 022, 023, 024
Source files available in: sources/021-uninstall-old-gsd/, sources/022-install-new-gsd-core/, sources/023-gsd-core-compatibility/, sources/024-chezmoi-orchestration-update/

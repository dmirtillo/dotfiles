# OpenCode & GSD Configuration

## Requirements

- Provide smooth updates and correct hook integration for the OpenCode environment.
- Ensure GSD core updates do not overwrite custom skill folders.

## How to Build It

1. Use `npx @opengsd/gsd-core@latest --opencode --global` to install the modern GSD toolchain.
2. The installer will replace the old `get-shit-done-cc` structure, shifting files from `~/.config/opencode/get-shit-done/` to `~/.config/opencode/gsd-core/`.
3. Custom skills (like `officecli` or `ponytail`) placed directly in `~/.config/opencode/skills/` are fully preserved during `gsd-core` updates; the core installer only touches `gsd-*` prefixed skills.
4. `ponytail` can be installed via its plugin format in OpenCode `opencode.json` (`"plugin": ["@dietrichgebert/ponytail"]`) or via Gemini CLI's extensions manager.

## What to Avoid

- Do not manually delete the `gsd-*` skill folders to perform updates; rely on the `@opengsd/gsd-core` installer.
- Ensure the old `get-shit-done-cc` is cleanly uninstalled using its `--uninstall` flag before transitioning to `@opengsd/gsd-core`.

## Constraints

- Update sequences for GSD rely on the `npm` cache and global installation mechanisms inside `~/.config/opencode/`.

## Origin

Synthesized from spikes: 015, 016, 017, 021, 022, 023, 032
Source files available in: sources/015-ponytail-opencode-config/, sources/016-ponytail-gemini-config/, sources/017-opencode-update-method/, sources/021-uninstall-old-gsd/, sources/022-install-new-gsd-core/, sources/023-gsd-core-compatibility/, sources/032-gsd-core-skill-collision/

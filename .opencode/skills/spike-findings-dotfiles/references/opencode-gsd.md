# OpenCode & GSD Configuration

## Requirements

- Provide smooth updates and correct MCP integration for OpenCode v2 and Gemini CLI.
- Ensure GSD core updates do not overwrite custom skill folders.
- Avoid tracking static `opencode.json` in git; synthesize configuration and MCP servers dynamically via Chezmoi apply.

## How to Build It

1. Use `npx @opengsd/gsd-core@latest --opencode --global` to stage workflows, commands, and skills.
2. In OpenCode v2, GSD operates as an MCP server using `gsd-mcp-server` (`npx -y -p @opengsd/gsd-core gsd-mcp-server`).
3. In Gemini CLI, GSD is registered as an MCP server under `mcpServers.gsd` in `~/.gemini/settings.json`.
4. Chezmoi's `run_onchange_setup-opencode.sh.tmpl` automatically ensures `~/.config/opencode/opencode.json` contains:
   - Google AI Studio provider for Gemini models
   - LiteLLM proxy provider (`http://localhost:4000/v1`) for Claude and Grok models
   - MCP servers: `gcp-cost`, `aws-pricing`, and `gsd`
   - Permissions for GSD operations
5. Obsolete OpenCode v1 plugins (like `plugins/gsd-core.js` and `plugins/ecc-hooks.ts`) are removed automatically during setup to avoid OpenCode v2 plugin loader crashes.

## What to Avoid

- Do not commit `~/.config/opencode/opencode.json` or plugin files to the dotfiles repository. Keep them in `.chezmoiignore` and configure them through `run_onchange_setup-opencode.sh.tmpl`.
- Do not keep OpenCode v1 CommonJS plugins (`module.exports = { server }`) or v1 hook files in `~/.config/opencode/plugins/`. OpenCode v2 requires the new `export default { id, setup(ctx) }` plugin shape.
- Do not manually delete `gsd-*` skill folders; rely on the `@opengsd/gsd-core` installer.

## Constraints

- OpenCode v2 loads plugins strictly using the v2 specification (`id` and `setup`/`effect`). Plugins that still use v1 exports must be loaded via v2 adapters or installed when updated upstream.
- MCP servers in OpenCode can also be managed dynamically with `opencode mcp add --global <name> -- <command...>`.

## Origin

Synthesized from spikes: 015, 016, 017, 021, 022, 023, 032, and OpenCode v2 migration.

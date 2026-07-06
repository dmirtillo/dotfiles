# Ponytail CLI Configuration

## Requirements

- Clients like OpenCode and Gemini CLI cannot "implicitly" inherit tools configured on the LiteLLM proxy without code modifications. (Note: this is related to MCP, but important context for CLI extensions).

## How to Build It

To install and configure the Ponytail agent extension for the primary CLIs:

**OpenCode CLI**
OpenCode uses a JSON configuration file. Add `@dietrichgebert/ponytail` to the `plugin` array.

1. Open `~/.config/opencode/opencode.json`
2. Add the plugin:
```json
{
  "plugin": [
    "@dietrichgebert/ponytail"
  ]
}
```
OpenCode will automatically load the ponytail skill and its associated instructions.

**Gemini CLI**
Gemini CLI uses a built-in extension manager.

1. Run the installation command:
```bash
echo "Y" | gemini extensions install https://github.com/DietrichGebert/ponytail
```
This automatically downloads the skills, registers them in `~/.gemini/skills/`, and enables them.

## What to Avoid

- Do not attempt to manually copy the `SKILL.md` files for Ponytail. Use the native extension mechanisms (OpenCode `plugin` array, Gemini `extensions install` command) so that updates and lifecycle hooks (like `ponytail-mode-tracker.js`) function correctly.

## Constraints

- OpenCode expects the plugin to exist in its own `node_modules` directory (`~/.config/opencode/node_modules/@dietrichgebert/ponytail`).
- Gemini CLI requires user confirmation (the `[Y/n]` prompt) when installing extensions from GitHub, hence the `echo "Y" | ...` in automated setups.

## Origin

Synthesized from spikes: 015, 016
Source files available in: sources/015-ponytail-opencode-config/, sources/016-ponytail-gemini-config/

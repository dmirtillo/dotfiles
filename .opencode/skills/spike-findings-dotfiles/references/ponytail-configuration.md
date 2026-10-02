# Ponytail CLI Configuration

## Requirements

- Provide lazy senior developer principles and instructions across supported AI harnesses (Gemini CLI, Antigravity, and OpenCode).
- Extensions and plugins must be installed and managed from upstream sources rather than committed as static vendor files in the dotfiles git repository.

## How to Build It

**Gemini CLI**
Gemini CLI uses a built-in extension manager:

1. Install non-interactively with `--consent`:
```bash
gemini extensions install https://github.com/DietrichGebert/ponytail --consent
```
2. Automatically handled during `chezmoi apply` via `run_onchange_setup-gemini.sh.tmpl`.
3. Verify status with:
```bash
gemini extensions list
```

**OpenCode CLI**
1. In OpenCode v2, plugins are added dynamically from source:
```bash
opencode plugin add <package>
```
2. Note: Upstream `@dietrichgebert/ponytail` on npm is currently structured for OpenCode v1. Do not hardcode `"plugin": ["@dietrichgebert/ponytail"]` in `opencode.json` until upstream publishes an OpenCode v2-compatible export (`export default { id, setup }`).
3. Mode persistence is stored in `~/.config/opencode/.ponytail-active` (e.g. `full`, `lite`, `ultra`, `off`).

**Antigravity CLI**
Handled during setup via:
```bash
agy plugin install https://github.com/DietrichGebert/ponytail
```

## What to Avoid

- Do not commit plugin implementation files or vendor copies into the dotfiles repository.
- Do not track `opencode.json` or `plugins/` in git; manage them via Chezmoi setup scripts and native CLI extension commands.

## Origin

Synthesized from spikes: 015, 016, 041, 042, and OpenCode v2 transition.

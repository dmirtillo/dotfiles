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
1. In OpenCode v2, plugins use the `{ id, setup(ctx) }` lifecycle. Upstream `@dietrichgebert/ponytail` on npm is currently structured for OpenCode v1 (PR #962 pending).
2. To provide full Ponytail integration in OpenCode v2 without hardcoding broken v1 plugin entries into `opencode.json`:
   - `@dietrichgebert/ponytail` is installed in `~/.config/opencode/node_modules/`
   - An OpenCode v2 plugin bridge is deployed at `~/.config/opencode/plugins/ponytail.ts` (automatically handled by `run_onchange_setup-opencode.sh.tmpl`), registering commands (`/ponytail`), skills, and the system prompt injection hook.
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

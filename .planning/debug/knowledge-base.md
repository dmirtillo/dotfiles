# GSD Debug Knowledge Base

Resolved debug sessions. Used by `gsd-debugger` to surface known-pattern hypotheses at the start of new investigations.

---

## litellm-anthropic-tool-calling-error — 400 UnsupportedParamsError from LiteLLM Anthropic proxy
- **Date:** 2026-04-15
- **Error patterns:** 400 litellm.UnsupportedParamsError, Anthropic doesn't support tool calling without tools= param, modify_params, litellm_settings
- **Root cause:** LiteLLM proxying request to Anthropic with tool choice but no tools defined.
- **Fix:** Add `litellm_settings: modify_params: true` to litellm proxy `config.yaml`.
- **Files changed:** private_dot_config/private_litellm/config.yaml.tmpl
---
## chezmoi-apply-tfswitch-error — `chezmoi apply` failing on tfswitch formula and OpenCode package.json diff
- **Date:** 2026-04-16
- **Error patterns:** Error: No available formula with the name "warrensbox/tap/tfswitch", package.json has changed since chezmoi last wrote it
- **Root cause:** The `warrensbox/tap/tfswitch` formula was removed by the maintainer and migrated to a Cask. Additionally, the local OpenCode plugin auto-updated to a newer version than what dotfiles tracked.
- **Fix:** Removed the `tfswitch` formula from `Brewfile` (kept only the cask) and updated `package.json` in the dotfiles repo to the newer version.
- **Files changed:** Brewfile, private_dot_config/private_opencode/package.json
---

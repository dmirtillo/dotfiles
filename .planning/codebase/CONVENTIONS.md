# Coding Conventions

**Analysis Date:** 2026-07-09

## Naming Patterns

**Files:**
- Chezmoi managed files: `dot_name.tmpl` (e.g., `dot_zshrc.tmpl`)
- Private/secured files: `private_dot_name.tmpl` (e.g., `private_dot_config/`)
- Event-triggered scripts: `run_onchange_[when]_[name].sh.tmpl` (e.g., `run_onchange_after_trust-mise.sh.tmpl`)
- Spike/Skill tests: `test_[name].sh` (e.g., `test_merge.sh`)

**Functions:**
- Shell functions use lowercase with dashes or underscores, without the `function` keyword: `mkcd()`, `extract()`, `office-read()`
- No parameters in signature definitions.

**Variables:**
- Local shell variables: lowercase (e.g., `local file="$1"`)
- Environment/Global variables: UPPERCASE (e.g., `TARGET_BREWFILE`, `HISTSIZE`)

## Code Style

**Organization:**
- Heavy use of banner comments to group logic. E.g., `# ============================================================================`
- Zsh plugin loading is centralized in `dot_zsh_plugins.txt` rather than directly in `dot_zshrc.tmpl`

**Performance Optimizations:**
- Strict performance budget (<100ms startup).
- `_cache_eval` is used to cache slow init commands (`zoxide`, `direnv`).
- Lazy loading for tools (e.g., NVM is lazy-loaded).
- Use of `&!` to background slow operations like SSH key loading.
- `mise` is used via `--shims` instead of shell hooks.

**Chezmoi Templating:**
- OS detection using Go template logic: `{{ if eq .chezmoi.os "darwin" }}` instead of shell conditionals.
- Re-run triggers use checksums: `# chezmoi:template:hash {{ include "dot_mise.toml.tmpl" | sha256sum }}`.

## Error Handling

**Patterns:**
- Bash scripts typically start with strict mode: `set -euo pipefail`
- Optional or volatile commands use silent fallback: `2>/dev/null || true`
- Simple input validation in functions: `if [[ -z "$file" ]]; then echo "Usage..."; return 1; fi`

## Comments

**When to Comment:**
- Performance metrics and justifications are highly documented (e.g., in `dot_zshrc.tmpl` header).
- Explanations for *why* a pattern is used over another (e.g., `WHY NOT mise activate zsh`).

---

*Convention analysis: 2026-07-09*

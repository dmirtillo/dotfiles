# Codebase Concerns

**Analysis Date:** 2026-07-09

## Tech Debt

**Ad-hoc Root Scripts:**
- Issue: Several throwaway scripts for manipulating `.planning/` files exist in the project root. They use macOS-specific `sed -i ''` and clutter the directory.
- Files: `test_office_read.sh`, `update_roadmap.sh`, `fix_roadmap.sh`, `fix_state.sh`
- Impact: Clutter, undocumented state manipulations, not cross-platform.
- Fix approach: Delete these scripts if they were one-offs, or move them to a `scripts/` or `bin/` directory with proper cross-platform support.

**LiteLLM Vertex AI Patching:**
- Issue: A fragile `sed` command manually patches a Python file inside a pipx virtual environment to drop `top_p` arguments for Claude Vertex AI models.
- Files: `run_onchange_install-packages.sh.tmpl`
- Impact: If LiteLLM updates the `transformation.py` file, the `sed` substitution will fail silently and break Vertex AI Claude models.
- Fix approach: Fork LiteLLM, submit an upstream PR, or use a proper `diff`/`patch` file that fails loudly when context lines don't match.

## Known Bugs

**Interactive SSH Key Loading:**
- Symptoms: If an SSH key requires a passphrase, it will fail to prompt correctly because the load function runs asynchronously.
- Files: `dot_zshrc.tmpl` (inside `load_default_ssh_keys &!`)
- Trigger: Starting `zsh` when an un-added SSH key with a passphrase is in the `.chezmoi.toml.tmpl` `ssh_keys` list.
- Workaround: The user must manually run `ssh-add` in the foreground for passphrase-protected keys.

**Arch Linux Partial Upgrades:**
- Symptoms: Potential system breakage from installing software against an upgraded sync database while local system packages remain outdated.
- Files: `run_onchange_install-packages.sh.tmpl`
- Trigger: The script runs `sudo pacman -Sy` followed by `yay -S --needed`. 
- Workaround: Change `sudo pacman -Sy` to `sudo pacman -Syu` to ensure full system upgrade before package installations, preventing partial upgrade scenarios.

## Security Considerations

**Zsh Completions Audit Disabled:**
- Risk: Malicious scripts or altered file permissions on `~/.zsh/completions` might inject executable code during shell tab-completion.
- Files: `dot_zshrc.tmpl` (`export ZSH_DISABLE_COMPFIX=true`)
- Current mitigation: Relies on the assumption that it's a single-user machine.
- Recommendations: Accept the ~16ms startup penalty, or implement a background check that periodically runs `compaudit` without blocking shell startup.

## Fragile Areas

**Go Templates without CI/Validation:**
- Files: `dot_zshrc.tmpl`, `.chezmoi.toml.tmpl`, `run_onchange_install-packages.sh.tmpl`
- Why fragile: Go template syntax errors prevent `chezmoi apply` from completing. There is no GitHub Actions CI or pre-commit hook running `chezmoi execute-template`.
- Safe modification: Always run `chezmoi diff` or `chezmoi apply --dry-run` locally before committing.
- Test coverage: Missing entirely.

**Hardcoded Python Versions in Pipx:**
- Files: `run_onchange_install-packages.sh.tmpl`
- Why fragile: Explicitly passes `--python python3.13` for LiteLLM. When the OS updates the default Python or removes 3.13, the script will crash.
- Safe modification: Remove the strict python version or use a tool like `mise` or `pyenv` to ensure the exact python runtime is always available independently of the OS package manager.

## Test Coverage Gaps

**Chezmoi Deployment Logic:**
- What's not tested: The conditional OS logic (`{{ if eq .chezmoi.os "darwin" }}`) across macOS and Linux.
- Files: `dot_zshrc.tmpl`, `run_onchange_install-packages.sh.tmpl`
- Risk: A typo in the Linux branch could go unnoticed by the author (who appears to primarily use macOS, given the `mktemp` Apple-specific hacks and macOS focus in `.planning` specs).
- Priority: Medium. Could be mitigated with basic Dockerized GitHub Actions validating the templates for both OS targets.

---

*Concerns audit: 2026-07-09*
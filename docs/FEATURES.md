# Features & Architecture

## Shell Architecture
### Performance Optimizations

Target: **< 50ms** shell startup time. Techniques used:

| Optimization | Savings | How |
|---|---|---|
| Powerlevel10k instant prompt | ~200ms | Renders prompt before plugins load |
| Cached `brew shellenv` | ~80ms | Cached to `~/.cache/brew-shellenv.zsh`, regenerates on brew update |
| Cached `fzf --zsh` | ~30ms | Same caching pattern |
| `_cache_eval` helper | ~50ms each | Caches `zoxide init`, `direnv hook`, `thefuck --alias` |
| Deferred compinit | ~250ms | Handled by `use-omz` plugin, not called twice |
| NVM lazy loading | ~400ms | `zsh-nvm` plugin with `NVM_LAZY_LOAD=true` |
| Background SSH key loading | ~11ms | `load_default_ssh_keys &!` |

### Plugin Management (Antidote)

Plugins are listed in `dot_zsh_plugins.txt`. When this file changes, `run_onchange_antidote-bundle.sh` regenerates the static file (`~/.zsh_plugins.zsh`) automatically during `chezmoi apply`.

### Key Aliases

The `.zshrc` template includes ~100 aliases organized by category. Highlights:

| Category | Examples |
|---|---|
| Modern CLI replacements | `ls`=eza, `cat`=bat, `du`=dust, `df`=duf, `ping`=gping, `cd`=zoxide |
| Git | `gst`, `gco`, `gcb`, `glog`, `gwip`, `gundo`, `lg`=lazygit |
| Docker | `d`, `dc`, `dcu`, `dcd`, `dps`, `lzd`=lazydocker |
| Terraform | `tf`, `tfi`, `tfp`, `tfa`, `tfs` |
| Ansible | `ap`, `apv`, `apc`, `av`, `ave`, `avd`, `al` |
| macOS only | `showfiles`, `hidefiles`, `flushdns`, `emptytrash`, `zscaler-start`, `zscaler-kill`, `brewup` |
| Linux only | `update` (yay/pacman), `flushdns` (systemd-resolve) |

---

## OpenCode \+ GSD Integration
[Get Shit Done](https://github.com/affaan-m/get-shit-done-cc) (GSD) provides AI agent prompts, commands, skills, and workflows for OpenCode.

### How It Works

1. **`run_onchange_setup-opencode.sh`** installs GSD globally via `npx get-shit-done-cc@latest --opencode --global`
2. **Our customizations** (`opencode.json`, `AGENTS.md`, `package.json`) are deployed directly by chezmoi from `private_dot_config/private_opencode/`

### Model Routing

Agents are routed to different models based on task complexity:

| Model | Agents | Rationale |
|---|---|---|
| **Gemini 3.1 Pro** | `planner`, `architect`, `gsd-*` | Deep reasoning for complex planning and architecture |
| **Gemini 3.1 Pro** (default) | `code-reviewer`, `security-reviewer`, `tdd-guide`, `e2e-runner`, `refactor-cleaner` | Best balance for code generation and review |
| **Gemini 3.1 Flash** | `build-error-resolver`, `doc-updater` | Mechanical fixes and documentation |

### Updating GSD

```bash
chezmoi apply
```

This triggers the setup script to run `npx get-shit-done-cc@latest` again, ensuring you have the latest features and fixes.

---

## How Chezmoi Works
### Naming Conventions

Files in this repo use special prefixes that chezmoi interprets during deployment:

| Prefix/Suffix | Effect | Example |
|---|---|---|
| `dot_` | Deployed as `.` | `dot_zshrc` -> `~/.zshrc` |
| `private_` | Sets restrictive permissions (`0700` for dirs, `0600` for files) | `private_dot_ssh/` -> `~/.ssh/` |
| `.tmpl` | Processed as a Go template before deploying | `dot_zshrc.tmpl` -> rendered `~/.zshrc` |
| `run_onchange_` | Script that runs when its tracked hash changes | `run_onchange_install-packages.sh.tmpl` |

### Go Templates

Template files (`.tmpl`) use Go's `text/template` syntax. Chezmoi provides built-in variables:

| Variable | Description | Example Values |
|---|---|---|
| `.chezmoi.os` | Operating system | `darwin`, `linux`, `windows` |
| `.chezmoi.arch` | CPU architecture | `amd64`, `arm64` |
| `.chezmoi.hostname` | Machine hostname | `MacBook-Pro` |
| `.chezmoi.username` | Current user | `dmirtillo` |
| `.chezmoi.sourceDir` | Path to chezmoi source | `~/.local/share/chezmoi` |

User-defined data from `.chezmoi.toml.tmpl` is accessed as `.git_name`, `.git_email`, `.ssh_keys`, etc.

**Example** — OS-specific alias in `dot_zshrc.tmpl`:
```
{{ "{{" }} if eq .chezmoi.os "darwin" -{{ "}}" }}
alias localip='ipconfig getifaddr en0'
{{ "{{" }} else -{{ "}}" }}
alias localip='hostname -I | awk "{print \$1}"'
{{ "{{" }} end -{{ "}}" }}
```

### run_onchange Scripts

Scripts prefixed with `run_onchange_` execute automatically when a tracked dependency changes. The dependency is tracked via a hash comment in the script:

```bash
# chezmoi:template:hash {{ "{{" }} include "Brewfile" | sha256sum {{ "}}" }}
```

This means the script re-runs only when the Brewfile content changes — not on every `chezmoi apply`.

---

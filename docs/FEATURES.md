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

## OpenCode + GSD Integration
[Get Shit Done](https://github.com/open-gsd/gsd-core) (GSD) provides AI agent prompts, commands, skills, and workflows for OpenCode.

### How It Works

1. **`run_onchange_setup-opencode.sh`** installs GSD globally via `npx @opengsd/gsd-core@latest --opencode --global` and removes obsolete V1 plugin bridges.
2. **Dynamic Configuration:** Rather than tracking static `opencode.json` files in git, `run_onchange_setup-opencode.sh` synthesizes providers, permissions, and Model Context Protocol (MCP) servers (`gcp-cost`, `aws-pricing`, `gsd`) automatically using Chezmoi secret variables (`gemini_api_key`, `gcloud_project`, etc.).
3. **Plugins & Hooks:** Managed directly via native CLI commands (`opencode plugin add`) rather than being versioned in dotfiles, avoiding runtime conflicts across OpenCode versions.

### Model Routing & Providers

Models are configured via Google AI Studio and a local LiteLLM proxy:

| Provider / Model | Route | Usage |
|---|---|---|
| **Gemini 3.8 Flash** | Google AI Studio direct (`@ai-sdk/google`) | Default primary & small model; fast, high-context generation |
| **Claude Sonnet 5** | LiteLLM (`localhost:4000/v1` via Vertex AI) | Complex feature implementation, TDD, and code review |
| **Claude Opus 5.5** | LiteLLM (`localhost:4000/v1` via Vertex AI) | Deep architectural reasoning and planning |
| **xAI Grok 4.6** | LiteLLM (`localhost:4000/v1` via Vertex AI) | Alternative fast reasoning and verification |

### Model Context Protocol (MCP)

OpenCode and Gemini CLI connect to standardized local MCP servers:
- **`gcp-cost`**: Live Google Cloud cost analysis and SKU pricing.
- **`aws-pricing`**: AWS Pricing API and Bedrock architecture patterns.
- **`gsd`**: Get Shit Done MCP server (`npx -y -p @opengsd/gsd-core gsd-mcp-server`) exposing command routing and state management tools.

### Updating GSD

```bash
chezmoi apply
```

This triggers the setup script to run `npx @opengsd/gsd-core@latest` again, ensuring you have the latest features and fixes.

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

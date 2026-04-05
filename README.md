# dotfiles

Cross-platform development environment configuration managed by [chezmoi](https://www.chezmoi.io/).

**Platforms:** macOS (Apple Silicon/Intel) | Arch Linux | CachyOS | Windows  
**Shell:** zsh + antidote + Powerlevel10k  
**AI:** OpenCode + Get Shit Done (GSD)

---

## Documentation

The documentation for this repository is broken out into specific guides:

- [**Installation**](docs/INSTALLATION.md) — Prerequisites, installation steps, configuration prompts, and post-install steps.
- [**Features & Architecture**](docs/FEATURES.md) — Shell architecture, chezmoi internals, and OpenCode + GSD integration.
- [**Tools**](docs/TOOLS.md) — High-level overview of installed packages and core CLI tools.
- [**Daily Workflow / Cheatsheet**](docs/CHEATSHEET.md) — Common commands and typical edit cycles.
- [**Making Changes**](docs/CONTRIBUTING.md) — Repository structure and how to add new aliases, packages, or plugins.
- [**Troubleshooting**](docs/TROUBLESHOOTING.md) — Help with common issues, slow startup times, and chezmoi health checks.

---

## Quick Start (macOS / Linux)

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply dmirtillo/dotfiles
```

See [INSTALLATION.md](docs/INSTALLATION.md) for detailed platform-specific instructions.

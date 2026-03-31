# Modules Codemap

**Last Updated:** 2026-03-31

| Module | Purpose | Location |
|--------|---------|----------|
| Bootstrapping | System configuration scripts | `run_onchange_*.sh.tmpl` |
| Core Configs | Application/User configuration | `private_dot_config/` |
| Binaries | Custom CLI scripts | `dot_local/bin/` |
| System | OS-specific agents/settings | `private_Library/`, `dot_termux` |

## Public API/Templates

- All `dot_` and `private_dot_` files act as templates for `~`.

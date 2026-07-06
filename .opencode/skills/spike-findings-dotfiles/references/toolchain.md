# Toolchain & Shimming

## Requirements

- Rely on modern tools (`mise`, `uv`) rather than duplicating package management logic.
- Avoid PATH conflicts between different binary sources.

## How to Build It

1. Use `mise use -g <backend>:<package>` (e.g., `npm:@opengsd/gsd-core@latest`) to globally manage CLI tools. `mise` automatically creates lightweight shims in `~/.local/share/mise/shims`.
2. This approach allows chezmoi scripts to be vastly simplified, removing brittle hooks and `npm install -g` logic.
3. For Python tools requiring extras (like `markitdown[all]`), use `uv tool install` directly. The `~/.local/bin` path will correctly serve as a fallback without `mise` shim interference, since `mise` prioritizes its own shims but allows passthrough.

## What to Avoid

- Do not use `mise` for `pipx` packages that require extras. It strips `[all]` syntax internally. Use `uv` instead.

## Constraints

- `mise` shim paths take precedence over `~/.local/bin`.

## Origin

Synthesized from spikes: 030, 033
Source files available in: sources/030-mise-global-tools/, sources/033-uv-mise-path-integration/

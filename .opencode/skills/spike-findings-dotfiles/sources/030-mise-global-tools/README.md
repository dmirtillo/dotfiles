---
spike: 030
name: mise-global-tools
type: standard
validates: "Given `mise`, when configuring global tools (`mise use -g`), then they are correctly shimmed and available to chezmoi scripts without complex path management"
verdict: VALIDATED
related: [022, 025]
tags: [mise, tools, chezmoi]
---

# Spike 030: Mise Global Tools

## What This Validates
Given `mise`, when configuring global tools (`mise use -g`), then they are correctly shimmed and available to chezmoi scripts without complex path management.

## Research
Currently, we rely on disparate package managers for global CLI tools (e.g., `npm install -g` for `gsd-core`, `pipx install` for `litellm` and `markitdown`). We want to centralize these under `mise` using its native package backends (`npm:`, `pipx:`).

## How to Run
```bash
mise use -g npm:@opengsd/gsd-core@latest
mise use -g pipx:markitdown@latest
```

## What to Expect
- Tools are installed correctly.
- Shims are generated in `~/.local/share/mise/shims`.
- Tools are executable from the global PATH without requiring hook-based shell initialization.

## Investigation Trail
1. Tested `npm:` backend: `mise use -g npm:@opengsd/gsd-core@latest`. The tool installed flawlessly, and the `gsd-tools` shim was instantly available in `~/.local/share/mise/shims`. This allows us to remove the brittle `npm install` logic from the `chezmoi` install scripts.
2. Tested `pipx:` backend: `mise use -g pipx:markitdown`. It successfully delegated to `uv tool install` (since `uv` is installed) and created the shim.
3. Tested `pipx:` backend with extras: `mise use -g 'pipx:markitdown[all]@latest'`. **Failure mode:** The `pipx:` backend parser in `mise` strips bracketed extras. It successfully installed `markitdown`, but omitted the `[all]` extra, rendering it incapable of reading `.docx` and `.pptx` files.

## Results

**✓ VALIDATED**

`mise` works exceptionally well for replacing `npm -g` for global JavaScript tools like `@opengsd/gsd-core`. The `mise` shims are reliable and zero-cost at startup.

**Constraint Discovered**: `mise`'s `pipx:` backend does not natively support Python package extras (`[all]`) in the package string. For complex Python tools like `markitdown` and `litellm[proxy]`, we must continue using native `uv tool install` directly to `~/.local/bin` to ensure the required extras are properly resolved.
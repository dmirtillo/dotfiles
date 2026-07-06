# Chezmoi Orchestration

## Requirements

(None strictly applicable to chezmoi internals)

## How to Build It

1. **Unified Configuration Drift Prevention:**
   Combine opencode skill updates, Homebrew syncing, and global JS/Python dependencies under `run_onchange_*.sh.tmpl` scripts in the `chezmoi` structure.
   
2. **Template Hydration for Binary Files:**
   Chezmoi cannot natively template `.docx` or `.pptx` files. To bypass this, store a generic `base.docx` in the repo with text placeholders like `{{ NAME }}`. Hydrate this template during deployment via a `run_onchange_` script:
   ```bash
   # inside run_onchange_hydrate.sh.tmpl
   cp base.docx target.docx
   officecli set target.docx / --find "{{ NAME }}" --replace "{{ .chezmoi.username }}"
   officecli close target.docx
   ```

3. **GSD Core Upgrades:**
   Use the `@opengsd/gsd-core` namespace. Standard installation (`npx @opengsd/gsd-core@latest`) seamlessly replaces legacy `get-shit-done-cc` installations without clobbering user-defined custom skills (like `officecli`).

## What to Avoid

- **Avoid direct manual modifications to Brewfile:** Rely on the `sync-brewfile` scripts that merge states to preserve comments.

## Constraints

- `.tmpl` execution inside chezmoi operates perfectly with external tools as long as the tools (`officecli`) are available on the PATH beforehand.

## Origin

Synthesized from spikes: 010, 019, 020, 024, 040
Source files available in: sources/040-officecli-template-hydration/

# Performance & Auditing

## Requirements

(No strict architecture requirements for this block, focuses on process)

## How to Build It

1. **Zsh Startup Validation:**
   Shell initialization must remain under `<50ms`. Ensure all heavy tool initializations (like `brew`, `nvm`, `zoxide`) use `_cache_eval` or lazy loading.
   ```bash
   # Test it
   time zsh -i -c exit
   ```

2. **Continuous Ponytail Auditing:**
   Use the `ponytail-audit` skill to continuously evaluate the dotfiles repo for over-engineering and dead code.
   ```bash
   # In opencode
   /ponytail-audit
   ```

3. **Safe Execution Limits:**
   When designing workflows that invoke subagents or third-party extraction tools, assume a hard **120-second timeout**.

## What to Avoid

- **Avoid heavy plugins:** Do not add synchronous loading plugins to `.zshrc`.
- **Avoid naive OCR:** As discovered in Spike 039, multimodal LLM parsing of images embedded in documents scales linearly and will blow past execution timeouts if run blindly.

## Constraints

- MarkItDown OCR is sequential and adds ~3s per image.

## Origin

Synthesized from spikes: 028, 031, 039
Source files available in: sources/028-ponytail-audit-validation/, sources/031-zsh-startup-profiling/, sources/039-markitdown-cost-profiling/

# Updating Everything Claude Code (ECC)

This document explains the architecture of the local "Everything Claude Code" (ECC) integration within this dotfiles repository and how to apply major upstream updates.

## Architecture & Integration Strategy

ECC is not installed as a monolithic package. Instead, it is treated as a modular upstream dependency. This dotfiles repo uses a hybrid approach: **Symlinking static upstream files** while **overriding critical configurations locally**.

1. **Upstream Source:** `chezmoi` uses `.chezmoiexternal.toml` to clone the pristine remote repository (`https://github.com/affaan-m/everything-claude-code.git`) into `~/.local/share/ecc`.
2. **Symlinking (The Setup Script):** The script `run_onchange_setup-opencode.sh.tmpl` runs automatically. It symlinks the heavy, frequently updated directories directly from the upstream clone into `~/.config/opencode/`:
   - `commands/`
   - `prompts/`
   - `instructions/`
   - `skills/`
   - `plugins/ecc-hooks.ts`
3. **Local Overrides:** The local directory `private_dot_config/private_opencode/` provides the personalized configurations that *override* the upstream defaults. These are injected as templates by `chezmoi` directly into `~/.config/opencode/`.

---

## The Local Modifications (Diff against Upstream)

If the upstream ECC structure changes drastically, here is what was modified locally to make it work in this environment:

### 1. `opencode.json.tmpl` (Core Routing & Config)
- **Model Overrides:** Changed the default `model` to `google/gemini-3.1-pro-preview` and `small_model` to `google/gemini-3.1-flash-lite-preview`.
- **Subagent Routing:** Hardcoded specific Gemini/Flash models for subagents (e.g., `planner` uses Pro, `doc-updater` uses Flash Lite), overriding the upstream defaults which use `anthropic/claude-opus-4-5`.
- **Provider Injection:** Added a custom `provider` block to securely route `google/` models via `@ai-sdk/google` using the `chezmoi` secret `{{ .gemini_api_key }}`. It also sets up a local proxy for `litellm/` models via Vertex AI (`http://localhost:4000/v1`).
- **Custom Commands:** Maintained additional custom commands like `harness-audit`, `loop-start`, `loop-status`, `model-route`, `quality-gate`.

### 2. Upstream Rule Loading (No More Monolith)
- We no longer maintain a giant concatenated `AGENTS.md` file locally.
- Instead, the setup script (`run_onchange_setup-opencode.sh.tmpl`) symlinks `AGENTS.md` and `CONTRIBUTING.md` directly from the pristine upstream repo into `~/.config/opencode/`.
- `opencode.json.tmpl` loads these rules modularly via the `"instructions"` array, ensuring ECC updates flow in automatically without text-merging.

### 3. `package.json`
- Stripped all publishing/NPM boilerplate from the upstream `ecc-universal` package. It only keeps the explicit `@opencode-ai/plugin` dependency to avoid conflicts during `bun/npm install`.

---

## How to Update ECC

When a major upstream update to `everything-claude-code` is released, follow these steps to integrate the changes safely:

1. **Update the External Clone**
   Run `chezmoi update`. This will `git pull` the latest upstream `main` branch into `~/.local/share/ecc`.

2. **Check for Structural Upstream Changes**
   Review the upstream repo. Did they rename `.opencode/`? Did they change how `skills/` or `prompts/` are organized? 
   - If yes, update `run_onchange_setup-opencode.sh.tmpl` to reflect the new directory paths.

3. **Diff the Core Configurations**
   To see what new settings or agents were added upstream that you might want to adopt, run these local diffs:
   ```bash
   diff -u ~/.local/share/ecc/.opencode/opencode.json ~/.local/share/chezmoi/private_dot_config/private_opencode/opencode.json.tmpl
   diff -u ~/.local/share/ecc/AGENTS.md ~/.local/share/chezmoi/private_dot_config/private_opencode/AGENTS.md
   ```

4. **Merge New Upstream Features**
   - **New Subagents:** If upstream added a new subagent to `opencode.json`, copy it into your local `opencode.json.tmpl`, but *remember to change its model* to `google/gemini-...`.
   - **Instructions Array:** Check if the upstream `opencode.json` added new skills to the `"instructions"` array, and copy those additions over to your local array.

5. **Apply and Test**
   Run `chezmoi apply` to redeploy the templates and re-run the symlink setup script. Test OpenCode to ensure the new agents and commands load successfully.

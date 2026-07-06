# Coherent System Update Workflow

This document defines the unified, coherent workflow for updating all components of the system, including local packages (Homebrew), configuration templates (Chezmoi), and external plugins (OpenCode / GSD).

## The Orchestrated Sequence

The update flow is designed to be run as a single script that guarantees no local state is lost and all components align.

1. **Pre-Sync Brewfile**
   - **Command:** `sync-brewfile`
   - **Why:** Captures any local `brew install` commands run manually since the last sync. Ensures the tracked `Brewfile` represents the true system state *before* updates begin.

2. **System Packages Update**
   - **Command:** `brew update && brew upgrade`
   - **Why:** Updates all Homebrew packages, including the core `opencode` CLI (which is tapped via Homebrew).

3. **Chezmoi Source Update**
   - **Command:** `chezmoi update`
   - **Why:** Pulls the latest dotfile templates from the upstream git repository.

4. **Component Version Bumps (OpenCode SDK)**
   - **Command:** `(cd $(chezmoi source-path)/private_dot_config/private_opencode && npm install @opencode-ai/plugin@latest --save-exact)`
   - **Why:** Updates the `package.json` tracked inside the Chezmoi source repository.

5. **Chezmoi Apply (The Trigger)**
   - **Command:** `chezmoi apply`
   - **Why:** This is the magic step. Because the `package.json` (from Step 4) changed, its SHA hash changes. The `run_onchange_setup-opencode.sh.tmpl` script detects this hash change and automatically triggers:
     - `npm install` (to install the new SDK)
     - `npx get-shit-done-cc@latest --opencode --global` (to fetch and install the latest GSD logic)

6. **Post-Sync Brewfile**
   - **Command:** `sync-brewfile`
   - **Why:** Final sweep to ensure any new dependencies added during the upgrade phase are securely tracked in the `Brewfile`.

## Managing `sync-brewfile` Drift

The `sync-brewfile` script has been designed to:
- **Append missing packages:** Found on the system but not in `Brewfile`.
- **Identify orphaned packages:** Found in `Brewfile` but uninstalled from the system (these should be manually pruned or commented out to prevent re-installation).
- **Preserve structure:** The script appends *without* destroying existing comments or formatting.

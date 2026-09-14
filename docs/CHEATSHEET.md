# Daily Workflow & Cheatsheet

## Daily Workflow
### Common Commands

| Task | Command |
|---|---|
| **Preview what would change** | `chezmoi diff` |
| **Apply all changes** | `chezmoi apply` |
| **Dry run (no changes)** | `chezmoi apply --dry-run` |
| **Edit a managed file** | `chezmoi edit ~/.zshrc` |
| **Pull upstream + apply** | `chezmoi update` |
| **Re-add a locally modified file** | `chezmoi re-add ~/.zshrc` |
| **Check managed files** | `chezmoi managed` |
| **Verify deployed state** | `chezmoi verify` |
| **Health check** | `chezmoi doctor` |

### Typical Edit Cycle

```bash
# 1. Edit the source template
chezmoi edit ~/.zshrc

# 2. Preview what would change
chezmoi diff

# 3. Apply
chezmoi apply

# 4. Commit the change
cd $(chezmoi source-path)
git add -A && git commit -m "feat: add new alias"
git push
```

### Pulling Changes on Another Machine

```bash
chezmoi update
```

This does `git pull` on the source repo and then `chezmoi apply` in one step.

---

## Services & AI

### LiteLLM Proxy
The LiteLLM proxy runs on port 4000 (via macOS LaunchAgent or Linux systemd user service). It handles routing for Claude models via Vertex AI.

#### macOS (LaunchAgent)
| Task | Command |
|---|---|
| **Restart (Quickest)** | `launchctl kickstart -k gui/$(id -u)/com.litellm.proxy` |
| **Stop** | `launchctl unload ~/Library/LaunchAgents/com.litellm.proxy.plist` |
| **Start** | `launchctl load ~/Library/LaunchAgents/com.litellm.proxy.plist` |
| **Tail Logs** | `tail -f ~/.local/share/litellm/proxy.log` |
| **Tail Errors** | `tail -f ~/.local/share/litellm/proxy.err` |

#### Linux (systemd user service)
| Task | Command |
|---|---|
| **Status** | `systemctl --user status litellm` |
| **Start** | `systemctl --user start litellm` |
| **Stop** | `systemctl --user stop litellm` |
| **Restart** | `systemctl --user restart litellm` |
| **Enable on Boot** | `systemctl --user enable --now litellm` |
| **Tail Logs** | `journalctl --user -u litellm -f` or `tail -f ~/.local/share/litellm/proxy.log` |

### OpenCode Models
Switch between Gemini (Direct) and Anthropic (via LiteLLM Proxy) modes:

| Task | Command |
|---|---|
| **Switch to Gemini** | `switch-models gemini` |
| **Switch to Anthropic** | `switch-models anthropic` |
| **Check Status** | `switch-models status` |

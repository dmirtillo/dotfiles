---
status: resolved
trigger: "im trying to understand why tmuxai plugin still checks for gemini 3.1 flash where i asked to update to 3.5\n\nalso this \n\n❯ chezmoi update && chezmoi apply\nThere is no tracking information for the current branch.\nPlease specify which branch you want to rebase against.\nSee git-pull(1) for details.\n\n    git pull <remote> <branch>\n\nIf you wish to set tracking information for this branch you can do so with:\n\n    git branch --set-upstream-to=origin/<branch> main\n\nchezmoi: git: exit status 1"
---

# Debug Session: tmuxai-gemini-model-and-chezmoi-git

## Symptoms
- **Expected behavior:** i should be able to just use the tmuxai plugin
- **Actual behavior:** i get an error 404 telling me 3.1 fast is not available
- **Error messages:** Failed to get response from AI: gemini API error: Error 404, Message: This model models/gemini-3.1-flash-lite-preview is no longer available. Please update your code to use a newer model for the latest features and improvements., Status: NOT_FOUND, Details: []
- **Timeline:** i asked this morning to update to 3.5 flash due to release
- **Reproduction:** just use tmuxai inside tmux

## Resolution
- **root_cause:** The local git repo's `main` branch lost its tracking information, which broke `chezmoi update`. Because of this, the commit that updated the model to `gemini-3.5-flash` was never deployed via `chezmoi apply`, leaving the old `gemini-3.1-flash-lite-preview` active. Additionally, `chezmoi apply` was failing due to an undefined `.aws_profile` variable in `opencode.json.tmpl`.
- **fix:** Set the upstream tracking branch (`git branch --set-upstream-to=origin/main main`), fixed `opencode.json.tmpl` to use `hasKey . "aws_profile"`, and forcibly applied the chezmoi config to sync `~/.config/tmuxai/config.yaml`.

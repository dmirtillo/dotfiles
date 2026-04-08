# GSD Debug Knowledge Base

Resolved debug sessions. Used by `gsd-debugger` to surface known-pattern hypotheses at the start of new investigations.

---

## termuxai-no-output-active-panel — Commands and output not displayed on active termux panel via tmuxai shortcut
- **Date:** 2026-04-08
- **Error patterns:** no commands, no output, active termux panel, not displayed
- **Root cause:** The `tmuxai` shortcut in `dot_tmux.conf.tmpl` launched `tmuxai` without specifying `--exec-pane`. As a result, `tmuxai` auto-selected or auto-created an execution pane instead of using the pane the user was actively working in. The user avoided passing the pane ID because `run-shell` (needed to evaluate `#{pane_id}`) failed with `exit 127` when `tmux ` was omitted from the inner `split-window` command.
- **Fix:** Modified `dot_tmux.conf.tmpl` to use `bind a run-shell 'tmux split-window -h -p 35 "{{ .chezmoi.homeDir }}/.local/bin/tmuxai --exec-pane #{pane_id}"'`, ensuring `tmuxai` receives the ID of the active pane.
- **Files changed:** dot_tmux.conf.tmpl
---
## tmux-ghostty-zsh-antidote-errors — missing antidote cache files cause zsh plugin errors
- **Date:** 2026-04-08
- **Error patterns:** no such file or directory, command not found, zsh-defer, add-zsh-hook, compdef, antidote cache
- **Root cause:** macOS periodically purges `~/Library/Caches`, which wipes out the downloaded antidote plugins. Since `~/.zshrc` only checked if `.zsh_plugins.zsh` was older than `.zsh_plugins.txt` (which wasn't true), it blindly sourced a static file pointing to missing directories, causing undefined command errors like `compdef` and `zsh-defer`.
- **Fix:** Modified `dot_zshrc.tmpl` to also verify the existence of the `_antidote_home` cache directory (`~/Library/Caches/antidote` on macOS, `~/.cache/antidote` on Linux). If it is missing, `antidote bundle` is forcefully triggered to redownload the plugins and rebuild the static file.
- **Files changed:** dot_zshrc.tmpl
---

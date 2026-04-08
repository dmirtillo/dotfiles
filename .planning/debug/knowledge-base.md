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

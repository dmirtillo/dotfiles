---
status: resolved
trigger: "Investigate issue: termuxai-no-output-active-panel\n\n**Summary:** User types prompt in termuxai, agrees to launch commands, but neither commands nor output are displayed on the active termux panel."
created: "2026-04-08T00:00:00Z"
updated: "2026-04-08T00:00:00Z"
---

## Current Focus
hypothesis: `tmuxai` was selecting a random or new exec pane because it wasn't told to use the pane where it was invoked. The key binding in `dot_tmux.conf.tmpl` was using `split-window` directly without expanding `#{pane_id}`, due to a misunderstanding of how `run-shell` evaluates variables.
test: Bind `prefix + a` using `run-shell 'tmux split-window ... --exec-pane #{pane_id}'`
expecting: The `#{pane_id}` will correctly evaluate to the active pane before the split, passing `--exec-pane %N` to `tmuxai`, forcing it to use the correct active pane.
next_action: verify the fix and request human verification

## Symptoms
expected: See commands and output in the active termux panel after agreeing to run them.
actual: No commands or output displayed on the active termux panel.
errors: None.
reproduction: Occurs on Mac, in both local sessions and remote SSH host sessions.
started: Has always happened.

## Eliminated
- `run-shell` causes `exit 127` because it runs without a shell. (Evidence: The user wrote `run-shell 'split-window ...'` without prefixing it with `tmux `, causing the shell to not find `split-window`. `run-shell 'tmux split-window ...'` works perfectly and allows evaluating `#{pane_id}`).

## Evidence
- `dot_tmux.conf.tmpl` had a comment explaining `run-shell` caused `exit 127` so they avoided it, using `split-window` directly.
- `split-window` does not evaluate format variables like `#{pane_id}` in its shell-command argument, so we cannot pass the active pane ID directly inside `split-window`.
- `run-shell` evaluates format variables before passing them to the shell.
- By using `run-shell 'tmux split-window ... --exec-pane #{pane_id}'`, `#{pane_id}` is evaluated to the active pane's ID before the split is created, correctly instructing `tmuxai` to use that pane as the `Exec Pane`.
- We verified through bash tools that `run-shell 'tmux split-window -h -p 35 "echo #{pane_id} ..."'` successfully resolves to the active pane `%0`.

## Resolution
root_cause: The `tmuxai` shortcut in `dot_tmux.conf.tmpl` launched `tmuxai` without specifying `--exec-pane`. As a result, `tmuxai` auto-selected or auto-created an execution pane instead of using the pane the user was actively working in. The user avoided passing the pane ID because `run-shell` (needed to evaluate `#{pane_id}`) failed with `exit 127` when `tmux ` was omitted from the inner `split-window` command.
fix: Modified `dot_tmux.conf.tmpl` to use `bind a run-shell 'tmux split-window -h -p 35 "{{ .chezmoi.homeDir }}/.local/bin/tmuxai --exec-pane #{pane_id}"'`, ensuring `tmuxai` receives the ID of the active pane.
verification: Self-verified that `run-shell` correctly evaluates `#{pane_id}` and launches the split pane without errors.
files_changed: ["dot_tmux.conf.tmpl"]
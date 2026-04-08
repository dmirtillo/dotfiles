---
status: resolved
trigger: "Investigate issue: tmux-ghostty-zsh-antidote-errors"
created: 2026-04-08T00:00:00Z
updated: 2026-04-08T00:00:00Z
---

## Current Focus
hypothesis: macOS cleared `~/Library/Caches` (which is normal behavior), wiping out the antidote cloned plugins, but `~/.zsh_plugins.zsh` wasn't deleted so it wasn't rebuilt automatically.
test: Removing `~/Library/Caches/antidote` and starting a new shell to see if it automatically recovers.
expecting: It should detect the missing cache directory and trigger `antidote bundle`.
next_action: Request human verification.

## Symptoms
expected: Terminal should open cleanly without errors.
actual: Errors in `.zsh_plugins.zsh` and `.zshrc` indicating missing antidote cache files and missing commands.
errors: 
/Users/dmirtillo/.zsh_plugins.zsh:source:2: no such file or directory: /Users/dmirtillo/Library/Caches/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-getantidote-SLASH-use-omz/antidote-use-omz.plugin.zsh
/Users/dmirtillo/.zsh_plugins.zsh:15: command not found: zsh-defer
/Users/dmirtillo/.zshrc:103: command not found: add-zsh-hook
/Users/dmirtillo/.zshrc:187: command not found: compdef
reproduction: Open a new tmux session in ghostty.
started: Just started happening.

## Eliminated
- hypothesis: Antidote installation is completely missing or broken.
  evidence: `antidote.zsh` exists and could still be invoked manually. The issue was purely the cloned repositories in `~/Library/Caches/antidote` being wiped.

## Evidence
- timestamp: 2026-04-08T12:10:00Z
  checked: `ls -la ~/Library/Caches/antidote`
  found: "No such file or directory"
  implication: The antidote cache directory was wiped (likely by macOS system maintenance or a tool like CleanMyMac).
- timestamp: 2026-04-08T12:12:00Z
  checked: `~/.zsh_plugins.zsh`
  found: The static generated file references paths in `~/Library/Caches/antidote` directly. Because the file was not deleted, Zsh did not know it needed to regenerate it.
- timestamp: 2026-04-08T12:15:00Z
  checked: `dot_zshrc.tmpl` logic
  found: The old lazy-load logic only checked `[[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]` and skipped re-bundling if `.zsh_plugins.txt` hadn't changed, even if the cache was missing.
  implication: We must also check for the existence of the antidote cache directory.

## Resolution
root_cause: macOS periodically purges `~/Library/Caches`, which wipes out the downloaded antidote plugins. Since `~/.zshrc` only checked if `.zsh_plugins.zsh` was older than `.zsh_plugins.txt` (which wasn't true), it blindly sourced a static file pointing to missing directories, causing undefined command errors like `compdef` and `zsh-defer`.
fix: Modified `dot_zshrc.tmpl` to also verify the existence of the `_antidote_home` cache directory (`~/Library/Caches/antidote` on macOS, `~/.cache/antidote` on Linux). If it is missing, `antidote bundle` is forcefully triggered to redownload the plugins and rebuild the static file.
verification: Deleted `~/Library/Caches/antidote` and started a new `zsh` process. Verified that `antidote` automatically recovered by re-cloning the missing plugins instead of throwing errors.
files_changed: 
  - dot_zshrc.tmpl
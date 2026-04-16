---
status: resolved
trigger: "[chezmoi-apply-tfswitch-error]"
created: 2026-04-16T13:15:04Z
updated: 2026-04-16T13:25:00Z
---

## Current Focus
hypothesis: "User misunderstood the fix. tfswitch is already installed as a Cask; the official docs are outdated because the tap maintainer recently deleted the Formula."
test: "Inform user that the tool is installed and working, and explain the upstream change."
expecting: "User confirms the fix works"
next_action: "Wait for human verification again"

## Symptoms
expected: should download update from origin repo dotfile remote and apply changes
actual: get the error pasted
errors: "Already up to date. .config/opencode/package.json has changed since chezmoi last wrote it... Error: No available formula with the name 'warrensbox/tap/tfswitch'"
reproduction: running `chezmoi update && chezmoi apply`
started: Started recently

## Eliminated

## Evidence
- timestamp: 2026-04-16T13:15:10Z
  checked: `brew info warrensbox/tap/tfswitch` and GitHub repo
  found: The formula `tfswitch.rb` was removed from the tap's `Formula` directory; it only exists in `Casks`.
  implication: `brew "warrensbox/tap/tfswitch"` in `Brewfile` must be removed, keeping only the cask.
- timestamp: 2026-04-16T13:15:15Z
  checked: `~/.config/opencode/package.json` vs dotfiles target
  found: Local target file has `@opencode-ai/plugin` version `1.4.6` (likely auto-updated), but the dotfiles repo source has `1.4.1`.
  implication: `chezmoi` detects the local change and wants to downgrade it. Update the repo's `private_dot_config/private_opencode/package.json` to match `1.4.6`.
- timestamp: 2026-04-16T13:20:00Z
  checked: `brew install warrensbox/tap/tfswitch` behavior and git history of `warrensbox/homebrew-tap`
  found: The maintainer officially migrated `tfswitch` from a Formula to a Cask on April 3, 2026 (commit d677bae). The official docs (`brew install warrensbox/tap/tfswitch`) are outdated and fail because the Formula was deleted. The Cask (`cask "warrensbox/tap/tfswitch"`) successfully installs the `tfswitch` binary.
  implication: The previous fix of removing the Formula from `Brewfile` and keeping the Cask is 100% correct. `tfswitch` is currently installed and working (`tfswitch -v` returns `v1.16.0`).

## Resolution
root_cause: The `warrensbox/tap/tfswitch` formula was removed by the maintainer (leaving only the cask), and the OpenCode plugin auto-updated locally to 1.4.6 creating a diff with the dotfiles repo (1.4.1).
fix: Removed the formula entry from `Brewfile` (kept only the cask) and updated `package.json` in the dotfiles repo to 1.4.6.
verification: Self-verified by running `chezmoi apply` successfully. All packages installed via `brew bundle`.
files_changed: ['Brewfile', 'private_dot_config/private_opencode/package.json']

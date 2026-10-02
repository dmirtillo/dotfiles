---
status: resolved
trigger: |
  DATA_START
  gemini cli and gsd installation debug on arch

  ❯ ssh frocetti
  root@frocetti ~ # su - dmirtillo
  ❯ yay -Syyu --devel
  ...
  npm error code EALLOWREMOTE
  npm error Fetching packages of type "remote" have been disabled
  npm error Refusing to fetch "@google/genai@https://registry.npmjs.org/@google/genai/-/genai-1.30.0.tgz"
  ...
  Error: installOpencodeFamilySkills: destDir "/home/dmirtillo/.config/opencode/skills" contains a symlink escaping the install root "/home/dmirtillo/.config/opencode" — refusing to write
  ...
  chezmoi: setup-opencode.sh: exit status 1
  DATA_END
---

# Debug Session: gemini-cli-gsd-install

## Symptoms
- **Expected behavior**: `yay` successfully builds and installs `gemini-cli-git`, and `chezmoi apply` completes `gsd-core` installation without errors.
- **Actual behavior**: `gemini-cli-git` fails to build due to npm refusing to fetch a remote package. `chezmoi apply` fails installing `gsd-core` because it detects a symlink in `~/.config/opencode/skills` that escapes the install root.
- **Error messages**:
  1. `npm error Fetching packages of type "remote" have been disabled` and `npm error Refusing to fetch "@google/genai@https://registry.npmjs.org/@google/genai/-/genai-1.30.0.tgz"`
  2. `Error: installOpencodeFamilySkills: destDir "/home/dmirtillo/.config/opencode/skills" contains a symlink escaping the install root "/home/dmirtillo/.config/opencode" — refusing to write`
- **Timeline**: Current installation attempt on Arch Linux.
- **Reproduction**: Run `yay -Syyu --devel` followed by `chezmoi update && chezmoi apply`.

## Resolution
- **root_cause**: 1) npm v12 blocks fetching remote URLs when there's an active internal registry mapping (like `@google` to `wombat-dressing-room`), causing `gemini-cli-git` to fail. 2) `gsd-core` explicitly rejects symlinks escaping the install root (`~/.config/opencode`) for security.
- **fix**: 1) Replaced `gemini-cli-git` (AUR) with `gemini-cli` (official repo) in `Pacfile`. 2) Updated `run_onchange_setup-opencode.sh.tmpl` to temporarily store symlink targets, replace them with real directories during `gsd-core` install, and then copy files back and restore the symlinks.

## Evidence
- timestamp: 2026-07-21T10:26:00
  content: Session created from user trace

## Eliminated
- Hypothesis about general network failure.

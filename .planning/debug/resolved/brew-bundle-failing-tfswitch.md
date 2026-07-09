---
status: resolved
trigger: brew bundle is failing on 'warrensbox/tap/tfswitch' during chezmoi apply. Read BREW_DEBUG_REPORT.md for the error. Investigate the failure and fix it in the Brewfile, either by repairing the tap or replacing tfswitch with a working alternative like tfenv or mise.
---
# Debug Session: brew-bundle-failing-tfswitch

## Symptoms
- **Expected behavior**: `brew bundle` completes successfully during `chezmoi apply`.
- **Actual behavior**: `brew bundle` fails on `warrensbox/tap/tfswitch`.
- **Error messages**: See `BREW_DEBUG_REPORT.md`
- **Timeline**: Started during recent dotfiles update.
- **Reproduction**: Run `brew bundle install --file=Brewfile` or `chezmoi apply`

## Current Focus
**Hypothesis**: tfswitch formula was deprecated/removed by maintainer and is redundant since `mise` natively manages terraform versions.
**Next Action**: Debug complete.

## Evidence
- `brew bundle` error reported on `warrensbox/tap/tfswitch`.
- `mise` is already used in dotfiles and natively handles `.terraform-version`.
- `tfswitch` is redundant per `CONVENTIONS.md`.

## Eliminated
- Repairing `tfswitch` tap or configuring it as a cask (deleted entirely to prevent shell bloat).

## Resolution
**root_cause**: `warrensbox/tap/tfswitch` fails to install due to maintainer deprecating/removing the formula, and it is a redundant tool since `mise` is already installed and handles terraform versions natively.
**fix**: Removed `tfswitch` and its tap from `Brewfile`, deleted its `chpwd` auto-load hooks from `dot_zshrc.tmpl`, and updated `docs/TOOLS.md`.

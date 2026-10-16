---
status: complete
date: "2026-10-16"
slug: 261016-pws-setup-powershell-on-mac
commit: 2e5a0e9
---

# Quick Task Summary: 261016-pws-setup-powershell-on-mac

## What Changed
- Installed PowerShell 7 (`pwsh`) via Homebrew and tracked it in `Brewfile`.
- Created unified PowerShell profile template `private_dot_config/powershell/Microsoft.PowerShell_profile.ps1.tmpl` deployed to `~/.config/powershell/Microsoft.PowerShell_profile.ps1`.
- Removed stale `private_dot_config/powershell/user_profile.ps1.tmpl` and updated Windows `Documents/PowerShell/Microsoft.PowerShell_profile.ps1.tmpl` to delegate to the unified profile.
- Tested and verified `pwsh` launch in standalone terminal and within tmux (Ghostty integration).

## Verification
- `pwsh --version` returns `PowerShell 7.6.7`.
- `pwsh -NoLogo -Command 'Get-Command ll, gst, cat, z, office-read'` succeeds with all aliases and functions mapped.
- Verified interactive execution in tmux session with output captured.

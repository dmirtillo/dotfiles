---
phase: 261016-pws
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - Brewfile
  - private_dot_config/powershell/Microsoft.PowerShell_profile.ps1.tmpl
  - Documents/PowerShell/Microsoft.PowerShell_profile.ps1.tmpl
  - .planning/STATE.md
autonomous: true
requirements: [SETUP-POWERSHELL-ON-MAC]
must_haves:
  truths:
    - "PowerShell is installed on macOS via Homebrew (`powershell` formula)"
    - "User can launch PowerShell via `pwsh` in Ghostty, tmux, and standard terminal"
    - "PowerShell profile at `~/.config/powershell/Microsoft.PowerShell_profile.ps1` loads cleanly with tool caching, aliases, and officecli wrappers"
---

<objective>
Install and configure PowerShell 7 (`pwsh`) on macOS with full parity for modern CLI tools, caching, aliases, and hybrid workflow wrappers.
</objective>

<tasks>

<task type="auto">
  <name>Task 1: Install PowerShell via Homebrew and update Brewfile</name>
  <files>Brewfile</files>
  <action>Add `brew "powershell"` to `Brewfile` under SHELL section and install via Homebrew.</action>
  <verify>brew list powershell && pwsh --version</verify>
  <done>PowerShell 7.6.x installed and present in Brewfile.</done>
</task>

<task type="auto">
  <name>Task 2: Configure cross-platform profile in chezmoi</name>
  <files>private_dot_config/powershell/Microsoft.PowerShell_profile.ps1.tmpl, Documents/PowerShell/Microsoft.PowerShell_profile.ps1.tmpl</files>
  <action>Create `private_dot_config/powershell/Microsoft.PowerShell_profile.ps1.tmpl` with caching for zoxide/mise/oh-my-posh, cross-platform aliases, and agent wrappers. Delegate Windows Documents profile to the unified config.</action>
  <verify>chezmoi execute-template < private_dot_config/powershell/Microsoft.PowerShell_profile.ps1.tmpl > /dev/null</verify>
  <done>Profile template renders cleanly without syntax errors.</done>
</task>

<task type="auto">
  <name>Task 3: Apply and verify pwsh execution in terminal and tmux</name>
  <files>~/.config/powershell/Microsoft.PowerShell_profile.ps1</files>
  <action>Apply profile via chezmoi and test interactive session in terminal and tmux.</action>
  <verify>pwsh -NoLogo -Command "Get-Command ll, gst, cat, z, office-read"</verify>
  <done>Commands load and execute successfully.</done>
</task>

<task type="auto">
  <name>Task 4: Update .planning/STATE.md</name>
  <files>.planning/STATE.md</files>
  <action>Record quick task completion in STATE.md.</action>
  <verify>grep -q "261016-pws" .planning/STATE.md</verify>
  <done>STATE.md updated with completed task details.</done>
</task>

</tasks>

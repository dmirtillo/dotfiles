---
phase: quick
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - Brewfile
  - dot_zshrc.tmpl
autonomous: true
requirements:
  - QK-260604
must_haves:
  truths:
    - Docker Desktop is removed from the Brewfile
    - Colima and standalone Docker CLI tools are present in the Brewfile
    - macOS Zsh configuration includes aliases for managing Colima
  artifacts:
    - path: Brewfile
      provides: updated Homebrew dependencies
    - path: dot_zshrc.tmpl
      provides: macOS specific docker aliases
  key_links: []
---

<objective>
Replace Docker Desktop with Colima for container orchestration on macOS, ensuring the Docker CLI remains fully functional with appropriate Zsh aliases.
Purpose: Migrate to a lighter, open-source container runtime (Colima) instead of Docker Desktop.
Output: Updated `Brewfile` and `dot_zshrc.tmpl`.
</objective>

<execution_context>
@/Users/dmirtillo/.config/opencode/get-shit-done/workflows/execute-plan.md
@/Users/dmirtillo/.config/opencode/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/STATE.md
@Brewfile
@dot_zshrc.tmpl
</context>

<tasks>

<task type="auto">
  <name>Task 1: Update Brewfile dependencies</name>
  <files>Brewfile</files>
  <action>
    Under the `# CONTAINERS & ORCHESTRATION` section in `Brewfile`:
    - Remove `cask "docker-desktop"`
    - Keep `brew "docker"` (it provides the essential CLI)
    - Add `brew "colima"` (the replacement daemon/VM)
    - Add `brew "docker-compose"` (previously bundled with Docker Desktop)
    - Add `brew "docker-credential-helper"` (recommended for secure auth)
    NOTE: Do not use `brew bundle dump`. Edit the file textually to preserve comments as per dotfiles spike findings.
  </action>
  <verify>
    <automated>grep -q "colima" Brewfile && ! grep -q "docker-desktop" Brewfile</automated>
  </verify>
  <done>Brewfile is updated with Colima and related docker CLI formulas.</done>
</task>

<task type="auto">
  <name>Task 2: Add Colima Zsh aliases for macOS</name>
  <files>dot_zshrc.tmpl</files>
  <action>
    In `dot_zshrc.tmpl`, locate the "Docker shortcuts" section.
    Add a macOS-specific block (`{{ if eq .chezmoi.os "darwin" -}}`) that includes:
    - `alias colima-start='colima start'`
    - `alias colima-stop='colima stop'`
    - `export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"` (to ensure compatibility with all tools since we removed Docker Desktop).
    Ensure these do not execute any commands on load (to maintain the sub-100ms performance budget).
  </action>
  <verify>
    <automated>grep -q "colima-start" dot_zshrc.tmpl</automated>
  </verify>
  <done>macOS specific Colima aliases and DOCKER_HOST export are added to Zsh configuration.</done>
</task>

</tasks>

<threat_model>
## Trust Boundaries

| Boundary | Description |
|----------|-------------|
| Local Shell -> Docker Daemon | Colima socket replaces Docker Desktop socket for container runtime |

## STRIDE Threat Register

| Threat ID | Category | Component | Disposition | Mitigation Plan |
|-----------|----------|-----------|-------------|-----------------|
| T-quick-01 | Elevation of Privilege | Docker Socket | accept | Rely on Colima's default user-space daemon permissions and secure socket mapping |
</threat_model>

<verification>
- `Brewfile` is structurally intact (comments preserved) but with updated dependencies.
- `dot_zshrc.tmpl` correctly wraps the new aliases in a chezmoi macOS OS check.
</verification>

<success_criteria>
Colima is fully defined as the container runtime in dotfiles and integrated seamlessly for macOS via Zsh.
</success_criteria>

<output>
After completion, create `.planning/phases/quick/{phase}-{plan}-SUMMARY.md`
</output>

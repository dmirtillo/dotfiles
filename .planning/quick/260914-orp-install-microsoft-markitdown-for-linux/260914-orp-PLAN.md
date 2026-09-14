---
phase: quick
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - run_onchange_install-packages.sh.tmpl
  - docs/TOOLS.md
autonomous: true
requirements: []
must_haves:
  truths:
    - "Microsoft markitdown CLI is installed and operational on Linux via uv tool"
    - "chezmoi run_onchange script installs markitdown[all] on Linux"
    - "docs/TOOLS.md documents markitdown"
  artifacts:
    - path: "run_onchange_install-packages.sh.tmpl"
      provides: "Automated markitdown[all] installation hook"
    - path: "docs/TOOLS.md"
      provides: "Documentation for markitdown tool"
---

<objective>
Identify and install Microsoft's office-to-markdown conversion utility (`markitdown`) on Linux, and integrate it into chezmoi dotfiles so it is consistently deployed.
</objective>

<tasks>

<task type="auto">
  <name>Task 1: Install markitdown[all] via uv tool</name>
  <files>~/.local/bin/markitdown</files>
  <action>
    Install Microsoft's `markitdown[all]` using `uv tool install "markitdown[all]"` and verify that the binary is operational.
  </action>
  <verify>
    <automated>markitdown --help</automated>
  </verify>
  <done>markitdown executable runs and displays help text.</done>
</task>

<task type="auto">
  <name>Task 2: Update dotfiles installation hook and documentation</name>
  <files>run_onchange_install-packages.sh.tmpl, docs/TOOLS.md</files>
  <action>
    Add an idempotent `uv tool install "markitdown[all]"` check in `run_onchange_install-packages.sh.tmpl` for Linux, and list `markitdown` under AI/Dev tools in `docs/TOOLS.md`.
  </action>
  <verify>
    <automated>grep "markitdown" /home/dmirtillo/projects/dotfiles/run_onchange_install-packages.sh.tmpl</automated>
  </verify>
  <done>Dotfiles hook and documentation updated.</done>
</task>

</tasks>

<success_criteria>
- markitdown is installed at ~/.local/bin/markitdown
- run_onchange_install-packages.sh.tmpl ensures markitdown is deployed on Linux
- docs/TOOLS.md lists markitdown
</success_criteria>

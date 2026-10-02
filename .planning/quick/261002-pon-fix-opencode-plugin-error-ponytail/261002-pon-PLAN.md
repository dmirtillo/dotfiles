---
phase: 261002-pon
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - run_onchange_setup-opencode.sh.tmpl
  - ~/.config/opencode/opencode.json
  - .planning/STATE.md
autonomous: true
requirements: [FIX-OPENCODE-PONYTAIL-PLUGIN]
must_haves:
  truths:
    - "OpenCode plugin list and check succeed without any plugin errors"
    - "Legacy V1 plugin configuration for ponytail is purged from opencode.json"
    - "Chezmoi setup script ensures stale plugin field and ponytail entries are removed on apply"
---

<objective>
Investigate and resolve the OpenCode plugin error for ponytail.
</objective>

<tasks>

<task type="auto">
  <name>Task 1: Diagnose ponytail plugin error in OpenCode v2</name>
  <files>~/.config/opencode/opencode.json, ~/.local/share/opencode/log/opencode.log</files>
  <action>Examine OpenCode server logs and plugin configuration to diagnose why loading `@dietrichgebert/ponytail` fails.</action>
  <verify>opencode plugin list && opencode plugin check</verify>
  <done>Root cause identified: upstream `@dietrichgebert/ponytail` on npm is structured for OpenCode v1 (exports a function) rather than OpenCode v2 (which requires an object with { id, setup }).</done>
</task>

<task type="auto">
  <name>Task 2: Fix OpenCode configuration and automate cleanup in chezmoi setup script</name>
  <files>~/.config/opencode/opencode.json, run_onchange_setup-opencode.sh.tmpl</files>
  <action>Remove stale `plugin` array containing `@dietrichgebert/ponytail` from `~/.config/opencode/opencode.json`. Update `run_onchange_setup-opencode.sh.tmpl` to automatically delete legacy `plugin` arrays and filter out `@dietrichgebert/ponytail` during configuration reconciliation.</action>
  <verify>opencode plugin check && chezmoi execute-template < run_onchange_setup-opencode.sh.tmpl > /dev/null</verify>
  <done>OpenCode runs cleanly without plugin errors and chezmoi script enforces cleanup.</done>
</task>

<task type="auto">
  <name>Task 3: Update .planning/STATE.md</name>
  <files>.planning/STATE.md</files>
  <action>Record completion of quick task in STATE.md.</action>
  <verify>grep -q "261002-pon" .planning/STATE.md</verify>
  <done>STATE.md updated with latest task entries.</done>
</task>

</tasks>

---
phase: quick
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - run_onchange_after_trust-mise.sh.tmpl
autonomous: true
requirements: []
must_haves:
  truths:
    - "gcp-cost-mcp-server binary is present and working via mise shim"
    - "chezmoi run_onchange script runs mise install so tools are installed on fresh deployment"
  artifacts:
    - path: "run_onchange_after_trust-mise.sh.tmpl"
      provides: "Automated mise install on dotfiles deployment"
---

<objective>
Fix gcp-cost-mcp-server shim availability by installing missing tools via mise and updating chezmoi's run_onchange_after_trust-mise.sh.tmpl script so tools are automatically installed.
</objective>

<tasks>

<task type="auto">
  <name>Task 1: Install gcp-cost-mcp-server via mise and verify shim</name>
  <files>~/.local/share/mise/shims/gcp-cost-mcp-server</files>
  <action>
    Run `mise install` to build and link all tools declared in `dot_mise.toml.tmpl`, including `gcp-cost-mcp-server`. Verify that the shim executable responds to `--help`.
  </action>
  <verify>
    <automated>/home/dmirtillo/.local/share/mise/shims/gcp-cost-mcp-server --help</automated>
  </verify>
  <done>gcp-cost-mcp-server shim runs cleanly and outputs MCP tool registration info.</done>
</task>

<task type="auto">
  <name>Task 2: Update chezmoi post-mise setup script</name>
  <files>run_onchange_after_trust-mise.sh.tmpl</files>
  <action>
    Ensure `run_onchange_after_trust-mise.sh.tmpl` executes `mise install` right after `mise trust ~/.mise.toml`, so fresh deployments install all tools automatically.
  </action>
  <verify>
    <automated>grep "mise install" /home/dmirtillo/projects/dotfiles/run_onchange_after_trust-mise.sh.tmpl</automated>
  </verify>
  <done>Script includes `mise install` step.</done>
</task>

</tasks>

<success_criteria>
- gcp-cost-mcp-server shim is available at ~/.local/share/mise/shims/gcp-cost-mcp-server
- chezmoi template run_onchange_after_trust-mise.sh.tmpl ensures automated tool installation
</success_criteria>

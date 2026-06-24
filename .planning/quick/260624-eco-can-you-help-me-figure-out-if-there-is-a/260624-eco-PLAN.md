---
phase: quick
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - private_dot_config/private_opencode/package.json
  - private_dot_config/private_opencode/opencode.json.tmpl
autonomous: true
requirements: [INSTALL-PONYTAIL]
must_haves:
  truths:
    - "Ponytail plugin is installed in OpenCode configuration"
  artifacts:
    - path: "private_dot_config/private_opencode/package.json"
      provides: "npm dependency for ponytail"
    - path: "private_dot_config/private_opencode/opencode.json.tmpl"
      provides: "plugin registration for ponytail"
  key_links:
    - from: "private_dot_config/private_opencode/opencode.json.tmpl"
      to: "@dietrichgebert/ponytail"
      via: "plugin array"
---

<objective>
Install the Ponytail AI agent plugin into the OpenCode configuration managed by chezmoi.

Purpose: Enable the "lazy senior dev" ruleset for AI agents via the `@dietrichgebert/ponytail` plugin in OpenCode.
Output: Updated package.json, package-lock.json, and opencode.json.tmpl.
</objective>

<execution_context>
@.planning/STATE.md
</execution_context>

<context>
@private_dot_config/private_opencode/package.json
@private_dot_config/private_opencode/opencode.json.tmpl

The ponytail plugin is an npm package `@dietrichgebert/ponytail` that can be loaded by OpenCode by adding it to the `plugin` array in `opencode.json`.
</context>

<tasks>

<task type="auto">
  <name>Task 1: Add ponytail npm dependency</name>
  <files>private_dot_config/private_opencode/package.json, private_dot_config/private_opencode/package-lock.json</files>
  <action>
    Add `"@dietrichgebert/ponytail": "latest"` (or specific latest version) to the `dependencies` object in `private_dot_config/private_opencode/package.json`.
    Then, run `npm install` within the `private_dot_config/private_opencode/` directory to fetch the package and update `package-lock.json`.
  </action>
  <verify>
    <automated>cd private_dot_config/private_opencode && npm ls @dietrichgebert/ponytail</automated>
  </verify>
  <done>package.json includes the dependency and package-lock.json is updated.</done>
</task>

<task type="auto">
  <name>Task 2: Register plugin in opencode.json.tmpl</name>
  <files>private_dot_config/private_opencode/opencode.json.tmpl</files>
  <action>
    Update `private_dot_config/private_opencode/opencode.json.tmpl` to include the ponytail plugin.
    Add a new `"plugin": ["@dietrichgebert/ponytail"]` key at the root level of the JSON template (e.g., just after the `$schema` or `small_model` fields).
  </action>
  <verify>
    <automated>grep -q "@dietrichgebert/ponytail" private_dot_config/private_opencode/opencode.json.tmpl</automated>
  </verify>
  <done>opencode.json.tmpl is correctly formatted and includes the plugin array.</done>
</task>

</tasks>

<success_criteria>
- ponytail dependency is added to package.json
- opencode.json.tmpl has the plugin registered
- npm install completes successfully updating package-lock.json
</success_criteria>

<output>
After completion, create `.planning/quick/260624-eco-can-you-help-me-figure-out-if-there-is-a/quick-01-SUMMARY.md`
</output>
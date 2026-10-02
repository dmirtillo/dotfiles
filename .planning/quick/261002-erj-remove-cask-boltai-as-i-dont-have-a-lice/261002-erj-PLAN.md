---
phase: quick
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - Brewfile
autonomous: true
requirements: []
must_haves:
  truths:
    - "boltai cask entry is removed from Brewfile"
    - "boltai is not installed on the system via brew cask"
  artifacts:
    - path: "Brewfile"
      provides: "Homebrew package manifest without boltai"
---

<objective>
Remove the unlicensed `boltai` cask from `Brewfile` and ensure it is uninstalled from the local Homebrew environment.

Purpose: Eliminate unlicensed software from the declarative dotfiles manifest and system.
Output: Clean `Brewfile` without `boltai`.
</objective>

<execution_context>
@/Users/dmirtillo/.config/opencode/gsd-core/workflows/execute-plan.md
@/Users/dmirtillo/.config/opencode/gsd-core/templates/summary.md
</execution_context>

<context>
@.planning/STATE.md
@Brewfile
</context>

<tasks>

<task type="auto">
  <name>Task 1: Remove boltai cask from Brewfile</name>
  <files>Brewfile</files>
  <action>
    Remove the `boltai` cask declaration under the `AI / LLM TOOLS` section in `Brewfile`. Keep surrounding section comments intact.
  </action>
  <verify>
    <automated>! grep -E 'cask "boltai"' Brewfile</automated>
  </verify>
  <done>Brewfile no longer contains any reference to the boltai cask.</done>
</task>

<task type="auto">
  <name>Task 2: Ensure boltai cask is uninstalled from local system</name>
  <files></files>
  <action>
    Check if `boltai` is installed locally via Homebrew (`brew list --cask`). If installed, uninstall it using `brew uninstall --cask boltai`. If already uninstalled, confirm absence.
  </action>
  <verify>
    <automated>! brew list --cask | grep -w boltai</automated>
  </verify>
  <done>BoltAI cask is not installed on the system.</done>
</task>

</tasks>

<threat_model>
## Trust Boundaries

| Boundary | Description |
|----------|-------------|
| Brewfile -> Homebrew | Package specifications passed to Homebrew package manager |

## STRIDE Threat Register

| Threat ID | Category | Component | Severity | Disposition | Mitigation Plan |
|-----------|----------|-----------|----------|-------------|-----------------|
| T-quick-01 | Tampering | Brewfile | low | mitigate | Remove unneeded cask entry to prevent unauthorized or unintended package installation |
</threat_model>

<verification>
- `Brewfile` does not contain `cask "boltai"`
- `brew list --cask` does not list `boltai`
</verification>

<success_criteria>
- boltai cask is removed from Brewfile
- boltai is not installed via brew cask
</success_criteria>

<output>
Create `.planning/quick/261002-erj-remove-cask-boltai-as-i-dont-have-a-lice/261002-erj-SUMMARY.md` when done
</output>

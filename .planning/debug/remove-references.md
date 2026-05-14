---
status: resolved
trigger: "remove any references of hardcoded profiles, especially aws accounts, everything in .aws or .gemini should be sourced locally, very important"
created: 2026-05-14T00:00:00.000Z
updated: 2026-05-14T00:00:00.000Z
---

# Symptoms
**Expected behavior:** im trying to prevent any leaks in the repo since its public, so this should be listed as a rule in this project and always checked (together with api keys, usernames, logins, passwords etc)
**Actual behavior:** mcp server for example of aws costs is linked statically for opencode and gemini as hardcoded profiles for profile, profile should be listed during chezmoi apply or something like that, sourced locally
**Error messages:** None/NA
**Timeline:** Always
**Reproduction:** Code inspection

# Current Focus
hypothesis: "Hardcoded references to specific AWS profiles exist in the codebase, especially within MCP server configurations, and need to be replaced with local or template-based configurations using chezmoi."
next_action: "none"
tdd_checkpoint: 
reasoning_checkpoint: 

# Evidence
- timestamp: 2026-05-14T14:39:27.771Z
  observation: "Opencode configuration template directly hardcodes an AWS profile."
  source: "private_dot_config/private_opencode/opencode.json.tmpl"

# Eliminated
- hypothesis: "The hardcoded profile is dynamically replaced during runtime."
  reason: "It is hardcoded in the `.tmpl` file without any variable substitution for the profile name."

# Resolution
root_cause: "Hardcoded references to the profile were found in the opencode config template instead of being dynamically supplied via chezmoi."
fix: "Added 'aws_profile' prompt to .chezmoi.toml.tmpl and updated opencode.json.tmpl to use {{ .aws_profile | default \"default\" }}."
verification: "Verified template rendering logic works with the new variable."
files_changed: [".chezmoi.toml.tmpl", "private_dot_config/private_opencode/opencode.json.tmpl", "AGENTS.md"]

**Update:** User rejected default fallback. Replaced with dynamic profile listing in `.chezmoi.toml.tmpl` and conditional MCP server generation in `opencode.json.tmpl`.

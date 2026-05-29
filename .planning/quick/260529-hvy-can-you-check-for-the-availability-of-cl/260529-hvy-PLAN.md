---
phase: quick
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - private_dot_config/private_litellm/config.yaml.tmpl
  - private_dot_config/private_opencode/opencode.json.tmpl
autonomous: true
requirements: []
must_haves:
  truths:
    - Availability of claude-opus-4.8 is checked on Vertex AI
    - If available, configuration files are updated to use claude-opus-4.8 instead of 4.7
  artifacts:
    - path: private_dot_config/private_litellm/config.yaml.tmpl
      provides: LiteLLM model routing configuration
    - path: private_dot_config/private_opencode/opencode.json.tmpl
      provides: OpenCode model registry configuration
  key_links:
    - from: private_dot_config/private_opencode/opencode.json.tmpl
      to: private_dot_config/private_litellm/config.yaml.tmpl
      via: model name matching
      pattern: claude-opus-4-8
---

<objective>
Check the availability of `claude-opus-4.8` on Vertex AI, and substitute the existing `claude-opus-4-7` references with it in LiteLLM and OpenCode configurations if it is available.
</objective>

<tasks>

<task type="auto">
  <name>Task 1: Check availability and update configurations</name>
  <files>private_dot_config/private_litellm/config.yaml.tmpl, private_dot_config/private_opencode/opencode.json.tmpl</files>
  <action>
    First, verify if `claude-opus-4-8` (or the equivalent version name) is available in Vertex AI / Google Cloud. You can write a small script using litellm or make an API request to Vertex to test `vertex_ai/claude-opus-4-8`.
    
    If it is available and working:
    1. Update `private_dot_config/private_litellm/config.yaml.tmpl`:
       - Find the `claude-opus-4-7` block and change it to `claude-opus-4-8`.
       - Update the Vertex AI model path to `vertex_ai/claude-opus-4-8@default` (or whatever the exact string is).
    2. Update `private_dot_config/private_opencode/opencode.json.tmpl`:
       - Find `"claude-opus-4-7"` and rename the key to `"claude-opus-4-8"`.
       - Update the `"name"` property to `"Claude Opus 4.8 (Vertex)"`.
       
    If it is NOT available, do not modify the files, and document the findings in your execution summary.
  </action>
  <verify>
    <automated>grep -rn "claude-opus-4-8" private_dot_config || echo "No changes made because model is not available"</automated>
  </verify>
  <done>
    Configurations are updated to use Opus 4.8 if it is available, otherwise they remain unchanged.
  </done>
</task>

</tasks>

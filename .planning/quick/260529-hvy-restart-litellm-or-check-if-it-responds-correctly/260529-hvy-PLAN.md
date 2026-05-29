---
phase: quick
plan: 01
type: execute
wave: 1
depends_on: []
files_modified: []
autonomous: true
requirements: []
must_haves:
  truths:
    - "litellm proxy is restarted"
    - "litellm responds correctly to health check"
  artifacts: []
  key_links: []
---

<objective>
Restart the litellm proxy service and verify that it responds correctly.

Purpose: To ensure litellm is functioning as expected and responding correctly, potentially applying any recent configuration changes.
Output: Verification that the litellm service is healthy and reachable.
</objective>

<execution_context>
@/Users/dmirtillo/.config/opencode/get-shit-done/workflows/execute-plan.md
@/Users/dmirtillo/.config/opencode/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/STATE.md
</context>

<tasks>

<task type="auto">
  <name>Task 1: Restart litellm launchctl service</name>
  <files></files>
  <action>
    Stop and start the `com.litellm.proxy` service using `launchctl`.
    Run `launchctl stop com.litellm.proxy` followed by `launchctl start com.litellm.proxy`.
    Alternatively, use `launchctl kickstart -k gui/$(id -u)/com.litellm.proxy` if it's running via gui.
    Wait a few seconds for the service to start.
  </action>
  <verify>
    <automated>launchctl list | grep com.litellm.proxy</automated>
  </verify>
  <done>Service is successfully restarted and appears in launchctl list.</done>
</task>

<task type="auto">
  <name>Task 2: Check litellm health endpoint</name>
  <files></files>
  <action>
    Perform an HTTP GET request to the litellm `/health` endpoint to verify it responds correctly.
    You can also verify `/v1/models` to see if it responds without issues.
    Check `tail -n 20 ~/.local/share/litellm/proxy.log` or `proxy.err` if the service fails to respond.
  </action>
  <verify>
    <automated>curl -s http://localhost:4000/health | grep healthy_endpoints</automated>
  </verify>
  <done>LiteLLM health endpoint returns a successful JSON response indicating the proxy is running and configured models are registered.</done>
</task>

</tasks>

<success_criteria>
LiteLLM is successfully restarted and the health endpoint confirms it is running and responding correctly.
</success_criteria>

<output>
After completion, create `.planning/quick/260529-hvy-restart-litellm-or-check-if-it-responds-correctly/260529-hvy-PLAN-SUMMARY.md`
</output>
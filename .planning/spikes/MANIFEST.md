# Spike Manifest

## Idea
Find a viable CLI replacement for the deprecated `gemini-cli` that supports Vertex AI (BYOK / pay-as-you-go) so the user does not have to pay for an `antigravity-cli` subscription.

## Requirements
- Must support Vertex AI (BYOK) for pay-as-you-go billing.
- Must operate from the terminal.

## Spikes
| # | Name | Type | Validates | Verdict | Tags |
|---|------|------|-----------|---------|------|
| 043 | antigravity-cli-byok | standard | Given antigravity-cli, when using undocumented env vars, then BYOK/PAYGO mode is enabled | ✓ VALIDATED | antigravity, byok, vertex |

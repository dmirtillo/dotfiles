# CLI Tooling

## Requirements

- Must support Vertex AI (BYOK) for pay-as-you-go billing.
- Must operate from the terminal.

## How to Build It

To use the recommended `antigravity-cli` (the modern replacement for `gemini-cli`) with your own Vertex AI pay-as-you-go account instead of an Antigravity subscription:

1. Install the CLI: `brew install --cask antigravity-cli`
2. Add the undocumented enterprise PAYGO bypass flags to your shell profile (e.g. `~/.zshrc`):
   ```bash
   export AGY_BUSINESS_PAYGO_TIER=true
   export GCP_GE_PAYGO_TIER=true
   ```
3. Set your Google Application Credentials or run `gcloud auth application-default login` normally.
4. Run `agy --model "Vertex" -p "hello"` to verify the bypass works and the CLI authenticates natively with GCP rather than asking for a subscription tier.

## What to Avoid

- Do not stick with `gemini-cli` as it is deprecated (v0.46.0+) and will be completely disabled.
- Do not pay for an Antigravity subscription if you already have Vertex AI access.

## Constraints

- Requires macOS >= 12.
- Exposes undocumented flags which could theoretically be renamed in future versions of `antigravity-cli` (though they are explicitly embedded in the Go binary for enterprise usage).

## Origin

Synthesized from spikes: 043
Source files available in: sources/043-antigravity-cli-byok/

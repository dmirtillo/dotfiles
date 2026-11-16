# CLI Tooling

## Requirements

- Must support Vertex AI (BYOK) for pay-as-you-go billing.
- Must operate from the terminal.

## Architecture

OpenCode is the unified terminal AI client in this repository:
1. `opencode` connects to LiteLLM (`http://localhost:4000/v1`) which proxies Claude, Gemini, Grok, and DeepSeek to Vertex AI using Google ADC.
2. Direct Google AI Studio access is configured for Gemini models via `@ai-sdk/google`.
3. Standalone `gemini-cli` and `antigravity-cli` have been removed in favor of `opencode`.

## What to Avoid

- Do not install `gemini-cli` or `antigravity-cli`; all workflows, MCP tools, and skills are consolidated into OpenCode.
- Do not pay for external subscriptions when Vertex AI pay-as-you-go proxying is supported through LiteLLM.

## Constraints

- Requires macOS >= 12.
- Exposes undocumented flags which could theoretically be renamed in future versions of `antigravity-cli` (though they are explicitly embedded in the Go binary for enterprise usage).

## Origin

Synthesized from spikes: 043
Source files available in: .planning/spikes/043-antigravity-cli-byok/

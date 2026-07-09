# External Integrations

**Analysis Date:** 2026-07-09

## APIs & External Services

**AI APIs:**
- Google AI Studio (Gemini) - Direct model access for OpenCode
  - SDK/Client: `@ai-sdk/google`
  - Auth: `gemini_api_key`
- Google Cloud Vertex AI (Claude) - Model access via LiteLLM proxy
  - SDK/Client: `litellm` + `google-cloud-aiplatform`
  - Auth: GCP Application Default Credentials (`gcloud_project` config)

**MCP (Model Context Protocol) Servers:**
- AWS Pricing MCP - Fetches AWS pricing data
  - SDK/Client: `awslabs.aws-pricing-mcp-server`
  - Auth: `AWS_PROFILE` (via `aws_profile` config)
- GCP Cost MCP - Fetches GCP cost estimation
  - SDK/Client: `gcp-cost-mcp-server`
  - Auth: GCP Application Default Credentials (`GOOGLE_CLOUD_PROJECT`)

## Data Storage

**Databases:**
- None (LiteLLM configured specifically DB-free)

**File Storage:**
- Local filesystem only (`~/.config`, `~/.local/share/litellm`)

**Caching:**
- Local filesystem only (`~/.cache/brew-shellenv.zsh`)

## Authentication & Identity

**Auth Provider:**
- Google Cloud ADC - Authenticates to Vertex AI for Claude models
  - Implementation: Assumed via `gcloud auth application-default login`
- SSH Agent - Local SSH key management
  - Implementation: Loaded on shell startup via `ssh_keys` array

## Monitoring & Observability

**Error Tracking:**
- None

**Logs:**
- File-based logging for LiteLLM
  - stdout: `~/.local/share/litellm/proxy.log`
  - stderr: `~/.local/share/litellm/proxy.err`

## CI/CD & Deployment

**Hosting:**
- Local deployment via `chezmoi apply`

**CI Pipeline:**
- None

## Environment Configuration

**Required env vars:**
- Prompted by `chezmoi` on init (stored in `.chezmoi.toml`):
  - `gcloud_project`
  - `gcloud_location`
  - `gemini_api_key`
  - `aws_profile`
  - `git_name` / `git_email`

**Secrets location:**
- Stored locally in `~/.config/chezmoi/chezmoi.toml` (unencrypted)
- `gemini_api_key` deployed to `~/.config/litellm/config.yaml` and `~/.config/opencode/opencode.json`

## Webhooks & Callbacks

**Incoming:**
- None

**Outgoing:**
- None

---

*Integration audit: 2026-07-09*

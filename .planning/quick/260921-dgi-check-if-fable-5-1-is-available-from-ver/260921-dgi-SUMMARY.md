---
quick_id: 260921-dgi
slug: check-if-fable-5-1-is-available-from-ver
status: complete
date: 2026-09-21
---

# Summary: check if fable 5.1 is available from vertex ai endpoint global

## Result
Confirmed model availability on Google Cloud Vertex AI global endpoint:
- Model resource ID: `publishers/anthropic/models/claude-fable-5-1` and `claude-fable-5-1@default`
- Global endpoint URL: `https://aiplatform.googleapis.com/v1/projects/{project}/locations/global/publishers/anthropic/models/claude-fable-5-1:rawPredict`
- HTTP Response: `403 PERMISSION_DENIED` with message:
  `"Access to this model requires data sharing to be enabled for publisher 'anthropic'. Please set PublisherModelConfig.data_sharing_enabled_provider to 'anthropic' via the setPublisherModelConfig API to use this model."`
- In comparison, non-existent models (e.g. `claude-fable-5.1`, `claude-fable-5-2`) return `404 NOT_FOUND`.
- This confirms that `claude-fable-5-1` is registered and available on Vertex AI's `global` endpoint, but requires the project to enable the Anthropic publisher agreement / data sharing (`setPublisherModelConfig`).

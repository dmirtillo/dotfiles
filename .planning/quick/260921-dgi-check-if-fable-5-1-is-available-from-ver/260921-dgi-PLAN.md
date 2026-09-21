# Quick Plan: check if fable 5.1 is available from vertex ai endpoint global

## Task
Verify existence and availability of Fable 5.1 (`claude-fable-5-1`) on Google Cloud Vertex AI using global endpoint.

## Verification
- Test endpoint `https://aiplatform.googleapis.com/v1/projects/{project}/locations/global/publishers/anthropic/models/claude-fable-5-1:rawPredict`
- Differentiate between 404 (non-existent model) and 403 (model exists, publisher agreement/permission required)

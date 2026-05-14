---
status: resolved
trigger: the mcp server for aws is failing.. the credentials are in .aws directory in my home, can't you just use those?
symptoms:
  expected: The server authenticates properly using credentials in ~/.aws/
  actual: The server returns: "Failed to retrieve service codes from AWS API: Unable to locate credentials"
  timeline: Just started / New setup
  reproduction: Querying MCP server
---

# Resolution
- **Root Cause 1 (Gemini CLI):** The command string `uvx ...` was being spawned as a single path, causing `ENOENT`. Additionally, the `HOME` environment variable was not automatically passed, preventing the AWS SDK from finding `~/.aws/credentials`.
- **Root Cause 2 (OpenCode):** The `env` block in `opencode.json` is not passed to the MCP server process by the current version of OpenCode.
- **Fix 1 (Gemini CLI):** Updated `~/.gemini/settings.json` to separate `command` and `args`, and explicitly added `HOME`, `AWS_PROFILE`, `AWS_REGION`, and `AWS_SHARED_CREDENTIALS_FILE` to the `env` section.
- **Fix 2 (OpenCode):** Updated `private_dot_config/private_opencode/opencode.json.tmpl` to use the `/usr/bin/env` command to inject the necessary AWS environment variables directly into the command execution.
- **Verification:** Both `gemini` and `opencode` can now successfully query the `aws-pricing` MCP server and return accurate pricing information.

# Current Focus
None. Issue resolved.

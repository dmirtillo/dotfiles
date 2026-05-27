# Phase quick Plan 01: AWS Cost MCP Server Status Summary

## What Happened to the AWS Cost MCP Server?

The AWS cost MCP server configuration in OpenCode has undergone a few changes to improve security and flexibility:

1. **Renamed and Updated**: The server configuration was renamed to `aws-pricing` and updated to use the official runner command: `npx -y awslabs.aws-pricing-mcp-server@latest`.
2. **Conditional Injection**: In commits `227d6c6` and `f63f5b1`, the server was made conditional. It now only renders in your `~/.config/opencode/opencode.json` file if you have explicitly configured an `aws_profile` in your chezmoi configuration. This prevents the server from being registered or attempting to start if no AWS credentials are provided.

## How to Get It Back

To re-enable the `aws-pricing` MCP server, you simply need to provide your AWS profile to chezmoi. You can do this in one of two ways:

### Option 1: Re-run Chezmoi Init (Recommended)
Run the initialization command again. It will dynamically list your local AWS profiles and prompt you for the one you want to use:
```bash
chezmoi init
```
*(When prompted for `aws_profile`, type the name of the profile you wish to use.)*

### Option 2: Manual Update
You can manually add the `aws_profile` variable to your `~/.config/chezmoi/chezmoi.toml` file under the `[data]` section:
```toml
[data]
  aws_profile = "your-profile-name"
```
After saving the file, apply the changes to regenerate your OpenCode configuration:
```bash
chezmoi apply
```

Once the `aws_profile` is present in your chezmoi data, the `aws-pricing` MCP server will automatically reappear in your OpenCode configuration.
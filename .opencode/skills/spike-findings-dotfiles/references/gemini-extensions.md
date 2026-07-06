# Gemini Extensions

## Requirements

- Gemini CLI MUST be passed the `--consent` flag when installing third-party extensions via URL in automated scripts or agent environments to bypass interactive security warnings.

## How to Build It

When an agent needs to ensure an extension (like `ponytail`) is available, or when writing a dotfile script to bootstrap the environment:

```bash
# Explicitly use --consent to prevent interactive prompts from hanging the agent
gemini extensions install https://github.com/DietrichGebert/ponytail --consent
```

## What to Avoid

- Running `gemini extensions install <url>` without `--consent` inside an agent or script. It will time out after 120 seconds waiting for stdin.

## Constraints

- Requires Gemini CLI version with extension support.

## Origin

Synthesized from spikes: 041, 042
Source files available in: sources/041-gemini-ponytail-install/, sources/042-gemini-ponytail-debug/

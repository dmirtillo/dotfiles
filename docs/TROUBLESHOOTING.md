# Troubleshooting

## Troubleshooting
### Check chezmoi health

```bash
chezmoi doctor
```

This checks for common issues: binary version, config file, source directory, required tools.

### See what chezmoi would change

```bash
chezmoi diff
```

### Verify deployed state matches source

```bash
chezmoi verify
```

Exit code 0 means everything matches. Non-zero means files have drifted.

### Template rendering errors

Test a template without deploying:

```bash
chezmoi execute-template < $(chezmoi source-path)/dot_zshrc.tmpl | head -20
```

### Force re-apply everything

```bash
chezmoi apply --force
```

### Reset to clean state

If something goes wrong, you can re-initialize:

```bash
chezmoi init --apply dmirtillo/dotfiles
```

This re-clones the repo and re-prompts for configuration.

### Shell startup is slow

Measure startup time:

```bash
hyperfine 'zsh -i -c exit'
```

Target is < 50ms. If it's slow, check that `_cache_eval` caches exist:

```bash
ls -la ~/.cache/{brew-shellenv,fzf,zoxide,direnv,thefuck}.zsh
```

If missing, open a new terminal — they regenerate automatically on first load.

## LiteLLM Proxy Issues

### LiteLLM is not responding
If Claude models in OpenCode are failing, verify if the proxy is running:

```bash
# Check if the process is active
pgrep -fl litellm

# Restart the service
launchctl kickstart -k gui/$(id -u)/com.litellm.proxy
```

### Permission Denied / ADC Errors
LiteLLM uses Google Cloud Application Default Credentials (ADC) for Vertex AI. If you see auth errors:

```bash
gcloud auth application-default login
```

### Log Locations
If the proxy starts but fails to route requests, check the logs:
- Output: `~/.local/share/litellm/proxy.log`
- Errors: `~/.local/share/litellm/proxy.err`

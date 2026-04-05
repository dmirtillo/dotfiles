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

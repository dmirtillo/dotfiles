# Architecture Codemap

**Last Updated:** 2026-03-31
**Entry Points:** `chezmoi` (managed by `apply`)

## Architecture

```
[chezmoi repo] 
      |
      +-- [templates (.tmpl)] -> [~/.config/...]
      |
      +-- [scripts (run_onchange_)] -> [deployment/bootstrap]
      |
      +-- [scripts (Brewfile/Wingetfile)] -> [package management]
```

## Data Flow

1. User modifies a `.tmpl` file.
2. User runs `chezmoi apply`.
3. Chezmoi renders templates and copies to the home directory.
4. `run_onchange_` scripts execute if their source hash changes.

# Troubleshooting

## Chezmoi

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

Target is < 120ms (currently ~96ms). If it's slow, check that `_cache_eval` caches exist:

```bash
ls -la ~/.cache/{brew-shellenv,fzf,zoxide,direnv,thefuck}.zsh
```

If missing, open a new terminal — they regenerate automatically on first load.

---

## Secrets

Secrets are never stored in the repo or in a chezmoi variable, and never exported
at shell startup. They live in the platform's native store and are read on demand
by `get-secret` (`~/.local/bin/get-secret`).

### Store a secret

```bash
get-secret --set gemini-api-key
```

This writes to whichever backend the machine has (see below). The Gemini key is
the only one this repo needs; OpenCode and tmuxai pick it up through wrapper
functions that run `get-secret` for that one process.

### Backends, in order

1. `$SECRET_FILE_DIR/<name>` — a 0600 file, default `~/.config/secrets/`. Set
   `SECRET_FILE_DIR` to force this on any platform.
2. **macOS** — Keychain.
3. **Linux with a session bus** — Secret Service via `secret-tool`. On KDE this
   is KWallet/ksecretd; you need `kwallet-pam` so KWallet is unlocked at login
   (otherwise the first `get-secret` opens a KWallet prompt).
4. **Headless Linux** (no DBus, remote shell) — `pass show dotfiles/<name>`.
   `pass` needs a GPG key and `gpg-agent`; over SSH the agent must be running.
   For a machine with neither, fall back to the 0600 file.

### Verify the backend on a machine

```bash
get-secret --set smoke-test
get-secret smoke-test          # prints the value
```

### Rotate a leaked key

The old `gemini_api_key` was written in plaintext into `~/.config/opencode/`,
`~/.config/litellm/` and `~/.config/tmuxai/`. Rotate it in Google AI Studio,
then `get-secret --set gemini-api-key` with the new value, and confirm no
`AIza…` string is left behind:

```bash
grep -rE 'AIza' ~/.config/opencode ~/.config/litellm ~/.config/tmuxai
```

---

## OpenCode CLI & Plugins

### OpenCode warning: "Plugins are KO" or TypeScript errors
OpenCode v2 strictly requires plugins to export `{ id: string, setup: (ctx) => void }` (or `Plugin.define`).
Legacy v1 plugins (`module.exports = { server }` or `@opencode-ai/plugin` hooks) will fail to load.

To clean up legacy hooks and verify:
```bash
# Check loaded plugins
opencode plugin list

# Verify MCP servers
opencode mcp list

# Test execution
opencode run "ping"
```

### Dynamic configuration
`~/.config/opencode/opencode.json` is not versioned in git to prevent machine-specific leakage. Instead, `chezmoi apply` (via `run_onchange_setup-opencode.sh.tmpl`) synthesizes your providers, models, and MCP servers (`gcp-cost`, `aws-pricing`, `gsd`) automatically.

---

## LiteLLM Proxy Issues

### LiteLLM is not responding
If Claude models in OpenCode are failing, verify if the proxy is running:

```bash
# Check if the process is active
pgrep -fl litellm

# It must be bound to 127.0.0.1:4000, never 0.0.0.0 (master_key is null)
lsof -iTCP:4000 -sTCP:LISTEN      # macOS
ss -tlnp 'sport = :4000'          # Linux

# Restart the service (macOS)
launchctl kickstart -k gui/$(id -u)/com.litellm.proxy

# Restart the service (Linux)
systemctl --user restart litellm
```

The proxy has no authentication (`master_key: null`), so it is only safe while
it listens on loopback. If `lsof`/`ss` shows `*:4000`, the `--host 127.0.0.1`
flag has gone missing from the LaunchAgent plist or the systemd unit.

### Linux Installation & Service Setup
LiteLLM is managed via chezmoi:
- **Package:** Installed via AUR (`yay -S litellm`) in `Pacfile`.
- **Service:** Managed by systemd user service (`~/.config/systemd/user/litellm.service`).
- To check service status or logs:
  ```bash
  systemctl --user status litellm
  journalctl --user -u litellm -f
  ```

> **Proxy extras are required.** The AUR `litellm` package ships the *library*
> only — every proxy dependency (FastAPI, uvicorn/granian, uvloop, orjson,
> sqlalchemy, semver, mcp, …) is an `optdepends`. `Pacfile` lists them explicitly
> under "AI / LLM TOOLS" (the verified-complete set). The proxy imports them at
> startup and exits 1 on the *first* missing module, so diagnosis is iterative:
> the failing import is named at the bottom of `~/.local/share/litellm/proxy.err`
> as `ModuleNotFoundError: No module named 'X'` — add the package for `X` and
> restart. `pyroscope-io` and `casbin` are imported lazily and are not needed
> for local Vertex/Grok routing.

> **Azure extras are deliberately omitted.** litellm lists
> `azure-identity`/`azure-storage-blob` in the proxy extras, but imports them
> lazily inside the Azure handlers, so the proxy runs without them. Their AUR
> builds are broken today (`python-msal-extensions` fails its own headless test
> suite, which cascades into `python-azure-identity`), and one failed AUR build
> aborts the entire `yay` transaction. If you ever route to Azure, install them
> with `uv pip install`/`pipx inject` rather than via the AUR.

> **`systemctl --user` says "Failed to connect to user scope bus".** In a
> non-login shell (SSH, script) neither `$XDG_RUNTIME_DIR` nor
> `$DBUS_SESSION_BUS_ADDRESS` is set, and `--user` needs both:
> ```bash
> export XDG_RUNTIME_DIR=/run/user/$(id -u)
> export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus
> systemctl --user status litellm
> ```
> If it still fails, the per-user manager isn't running without a login session
> — enable lingering so it (and the proxy) survive logout:
> ```bash
> loginctl enable-linger $USER
> ```
> The install script does both of these itself.

### Permission Denied / ADC Errors
LiteLLM uses Google Cloud Application Default Credentials (ADC) for Vertex AI. If you see auth errors:

```bash
gcloud auth application-default login
```

### Log Locations
If the proxy starts but fails to route requests, check the logs:
- Output: `~/.local/share/litellm/proxy.log` (or `journalctl --user -u litellm -f` on Linux)
- Errors: `~/.local/share/litellm/proxy.err`

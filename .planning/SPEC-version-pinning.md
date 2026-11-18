# SPEC: Version Pinning Audit — RESOLVED

**Status:** resolved and implemented, 2026-11-18
**Context:** Raised during milestone v2.0 close-out. Policy is "pin nothing, always run latest" — Python was pinned in four places and the pins had drifted apart.

---

## 1. Resolution Summary

The policy is now applied uniformly: **nothing is pinned.** Python resolves to the newest stable release via `python = "latest"` in mise, the two pinned Homebrew formulae are gone, and the LiteLLM venv no longer pins an interpreter. The pin that had a stated reason (F4) turned out to be stale — its premise was tested and disproved.

---

## 2. Evidence at time of audit (2026-11-18)

| Location | Said | Now |
|---|---|---|
| `dot_mise.toml.tmpl:4` | `python = "3.13"` | `python = "latest"` |
| `~/.mise.toml` (live) | `python = "3.15"` | converges on apply (no downgrade) |
| `mise current python` | `3.15.2` | unchanged |
| `Brewfile:159-160` | `python@3.13`, `python@3.14` | **removed** |
| `/opt/homebrew/bin/python3` | `3.15.2` | unchanged |
| pipx venv `litellm` | `3.13.18` | tracks the default interpreter |
| `run_onchange_install-packages.sh.tmpl:35` | `--python python3.13` | **removed** |
| `dot_local/bin/executable_litellm-patch` | `lib/python3.13/site-packages`, `python3.13` | resolves from the venv's own interpreter |

---

## 3. Findings — resolved

### F1 — mise Python pin conflicted with the policy → **FIXED**

`python = "3.13"` was a leftover, and it was conflated with a different concern (F4). Python was the only mise tool pinned to an exact minor. Now `python = "latest"`, matching `go`, `terraform`, gsd and gcp-cost. `node = "lts"` stays: LTS is a deliberate channel, not a stale minor.

### F2 — Template and live config had diverged → **FIXED**

`~/.mise.toml` said `3.15`, the template said `3.13`, so `chezmoi apply` would have *downgraded* the live file. With the template on `latest`, applying no longer fights the live value: both resolve to the newest stable (3.15.x today).

### F3 — Brewfile pinned two Pythons, neither current → **FIXED**

`python@3.13` and `python@3.14` are removed. Homebrew's `python3` already tracks the newest stable, and mise provides the managed interpreter. The two extra formulae installed older releases alongside it for no stated reason — exactly what "shouldn't install older versions" forbids.

### F4 — LiteLLM venv was coupled to Python 3.13 → **FIXED (premise disproved)**

The pin's stated reason: *litellm's grpcio dependency had no prebuilt wheel for newer Pythons on macOS arm64, so pip fell back to a source build that fails without Xcode headers.*

Tested and disproved on 2026-11-18:

- `pip download grpcio --only-binary=:all: --python-version 3.14 --platform macosx_11_0_arm64` → `grpcio-1.85.3-cp314-…-macosx_11_0_universal2.whl`
- same for `--python-version 3.15` → `grpcio-1.85.3-cp315-cp315-macosx_10_15_universal2.whl`

Both get prebuilt universal2 wheels — no source build, no Xcode headers. And litellm 1.110.0 declares `Requires-Python >=3.10,<3.16`, so 3.15 is supported. The pin is obsolete; `pipx install 'litellm[proxy]'` now picks the default interpreter.

### F5 — Inconsistent idioms for "latest" → **DOCUMENTED**

`latest` = newest stable; `lts` = Node long-term-support channel, a deliberate choice. `python` follows `latest`; `node` keeps `lts`.

---

## 4. The Linux question (answered)

**Was there a separate Linux LiteLLM build failure, fixable without pinning Python?**

No — there is no Linux pin to fix. The entire pipx/LiteLLM block lives in the `darwin` branch of `run_onchange_install-packages.sh.tmpl`; on Linux, LiteLLM comes from the Arch `litellm` package (`Pacfile:223`) and pipx never runs. The `--python python3.13` flag was **macOS-only**, its comment explicitly cites "macOS arm64", and the remembered failure was the same grpcio/Xcode issue — which F4 shows is also gone. Linux is already unpinned and needs no change.

---

## 5. Changes made

1. `dot_mise.toml.tmpl` — `python = "3.13"` → `python = "latest"` (dropped the OS-conditional that only hid the pin on Linux).
2. `Brewfile` — removed `brew "python@3.13"` and `brew "python@3.14"`.
3. `run_onchange_install-packages.sh.tmpl` — dropped `--python python3.13`; rewrote the WHY comment to record that the constraint is stale.
4. `dot_local/bin/executable_litellm-patch` — replaced the hardcoded `lib/python3.13/site-packages` path with `sysconfig.get_paths()["purelib"]` from the venv's own interpreter, and `python3.13` with `$VENV/bin/python`. This keeps the patch working across Python versions and is the root-cause fix for the same fragility.

---

## 6. Acceptance Criteria — met

- [x] Every version pin is removed in favour of `latest` (or kept with a stated reason — none needed one now).
- [x] `dot_mise.toml.tmpl` renders to a value that does not downgrade the live `~/.mise.toml`.
- [x] One Python is managed for general use (mise); the LiteLLM venv follows the default interpreter.
- [x] No pin disagrees with another pin for the same tool.
- [x] No interpreter version is hardcoded in any deployed script.

---

## 7. Follow-up (user action)

- `brew bundle install` on macOS to let Homebrew clean up the two now-unreferenced Python formulae (or `brew uninstall python@3.13 python@3.14`).
- Optionally recreate the LiteLLM venv on the current interpreter: `pipx reinstall litellm && litellm-patch` (the existing 3.13 venv is fine until the next `pipx upgrade`, which keeps its interpreter).

---

## 8. References

- `dot_mise.toml.tmpl`
- `Brewfile`
- `run_onchange_install-packages.sh.tmpl:23-51`
- `dot_local/bin/executable_litellm-patch`
- Milestone v2.0 policy: "i dont want to pin versions in my setup … i am looking to update to latest always"

# 06-01: Core CLI Scripts (office-read / office-write)

**Objective**: Integrate recent spike findings into the core CLI scripts for agentic operation, establishing the hybrid read/write pattern.

## Completed Tasks
- [x] Task 1: Update package installer for markitdown (removed global pipx installation)
- [x] Task 2: Create office-read and office-write zsh functions

## Decisions Made
- Implemented `office-read` and `office-write` as Zsh functions inside `dot_zshrc.tmpl` rather than standalone bash scripts, complying with the phase goal for "unified agent aliases".
- Removed the global `markitdown` installation from the `run_onchange` installer, relying instead on `uv run` to fetch it natively.

## Threat Model Updates
- (T-06-01) Enforced explicit version pinning for markitdown in `office-read`: `uv run --with 'markitdown[all]==0.1.6' markitdown "$1"`

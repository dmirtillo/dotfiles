---
spike: 028
name: ponytail-audit-validation
type: standard
validates: "Given the dotfiles repo, when running `ponytail-audit`, then it successfully identifies bloat or over-engineering that manual cleanup missed"
verdict: VALIDATED
related: [026, 027]
tags: [ponytail, audit, cleanup]
---

# Spike 028: Ponytail Audit Validation

## What This Validates
Given the dotfiles repo, when running `ponytail-audit`, then it successfully identifies bloat or over-engineering that manual cleanup missed.

## Research
Loaded the `ponytail-audit` skill which enforces a whole-repo scan for over-engineering (YAGNI, stdlib alternatives, native platform features, single-use wrappers). We apply this directly to the repository state post-Spike 027.

## How to Run
Manual review executed by the agent adhering to `ponytail-audit` guidelines.

## What to Expect
A ranked list of findings using ponytail syntax (`<tag> <what to cut>. <replacement>. [path]`).

## Investigation Trail
1. Reviewed `dot_zshrc.tmpl`: Discovered `tfswitch` hook. Since `mise` is our standard runtime manager and it natively reads `.terraform-version` files, `tfswitch` is completely redundant.
2. Reviewed `dot_zshrc.tmpl`: Found several trivial functions (`md`, `rd`, `sizeof`, `findfile`, `finddir`, `weather`, `note`, `notes`, `search`) that just wrap standard CLI tools in aliases/functions, creating personalized abstraction layers.
3. Reviewed `run_onchange_install-packages.sh.tmpl`: Found a literal `sed` command parsing and rewriting the internal site-packages code of `litellm` (`transformation.py`) to bypass an API restriction. This is brittle, undocumented over-engineering that will fail on any upstream changes.

## Results

**✓ VALIDATED**

The audit successfully found hidden bloat and over-engineering that previous manual cleanups missed. 

Findings:
- `native` `tfswitch` auto-load chpwd hook. `mise` manages terraform versions natively. `dot_zshrc.tmpl`.
- `shrink` `litellm` python library patching via `sed`. Write a proper wrapper or use custom LiteLLM config/plugin instead of mutating pip internals. `run_onchange_install-packages.sh.tmpl`.
- `delete` `sizeof`, `findfile`, `finddir`, `search`, `weather`, `note`, `notes` functions. Standard CLI tools (`du -sh`, `fd`, `rg`) are fewer characters and portable. `dot_zshrc.tmpl`.

Net: -35 lines, -1 dep possible (`tfswitch`).
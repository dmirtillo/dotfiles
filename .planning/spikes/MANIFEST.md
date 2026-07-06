# Spike Manifest

## Idea
Rework the `officecli` implementation to use `markitdown` as the read engine, while preserving `officecli`'s write/DOM capabilities.
Idea: ponytail still doesnt load into gemini

## Requirements
- The client MUST explicitly request the MCP tools in its API call using LiteLLM's custom `{"type": "mcp", "server_url": "litellm_proxy"}` syntax.
- Clients like OpenCode and Gemini CLI cannot "implicitly" inherit tools configured on the LiteLLM proxy without code modifications.
- **Markitdown+OfficeCLI:** Must explicitly call `officecli close <file>` to flush edits to disk before passing the file to `markitdown` for reading, due to `officecli`'s resident mode.

## Spikes

| # | Name | Type | Validates | Verdict | Tags |
|---|------|------|-----------|---------|------|
| 001 | litellm-mcp-integration | standard | Given LiteLLM proxy, when configured with an MCP server, then it exposes MCP tools via the OpenAI format | ✓ VALIDATED | litellm, mcp |
| 002 | opencode-litellm-connection | standard | Given OpenCode CLI, when pointed to the LiteLLM proxy, then it can discover and invoke the MCP tools | ✗ INVALIDATED | opencode, litellm, mcp |
| 003 | gemini-cli-litellm-connection | standard | Given Gemini CLI, when pointed to the LiteLLM proxy, then it can use the MCP tools | ✗ INVALIDATED | gemini-cli, litellm, mcp |
| 004 | brew-list-parsing | standard | Given local brew state, when parsed, then extract list of explicitly installed formulae/casks | ✓ VALIDATED | homebrew, bash, parsing |
| 005 | brewfile-sync | standard | Given parsed local list and existing Brewfile, when synced, then update Brewfile accurately | ✓ VALIDATED | homebrew, bash, parsing, script |
| 006 | brewfile-sync-preserve-comments | standard | Given a brew bundle dump and a target Brewfile with comments, when synced via a merge script, then new dependencies are added without destroying comments | ✓ VALIDATED | homebrew, bash, parsing, script, merge |
| 007 | hybrid-targeting | standard | Given a document read via markitdown, when applying an edit, then officecli's text-matching/query can reliably target the edit without needing XML IDs | ✓ VALIDATED | officecli, markitdown, hybrid |
| 008 | markitdown-baseline | standard | Given complex Office docs (PPTX, DOCX) with tables, when converted by markitdown, then the Markdown fidelity is sufficient for LLM understanding | ✓ VALIDATED | markitdown, baseline, extraction |
| 009 | markitdown-multimodal | standard | Given an Office doc with embedded images, when passed to markitdown with the OCR plugin, then image content is accurately extracted to Markdown | ✓ VALIDATED | markitdown, multimodal, ocr, images |
| 010 | chezmoi-officecli-setup | standard | Given a dotfiles repo managed by chezmoi, when incorporating the officecli+markitdown hybrid approach, then it can be deployed via a run_onchange script and documented via an updated SKILL.md | ✓ VALIDATED | chezmoi, officecli, markitdown, python, uv |
| 011 | pptx-hybrid-integration | standard | Given a multi-slide PPTX, when edited via `officecli` text replacement, then `markitdown` accurately reflects changes across slide boundaries | ✓ VALIDATED | officecli, markitdown, pptx |
| 012 | dom-targeting-sync | standard | Given a document modified via `officecli` DOM targeting, when flushed to disk, then `markitdown` perfectly extracts the updated structure | ✓ VALIDATED | officecli, markitdown, dom |
| 013 | markitdown-performance | standard | Given a large 50+ page Office file, when parsed by `markitdown`, then extraction completes quickly without risking agent timeouts | ✓ VALIDATED | markitdown, performance |
| 014 | markitdown-images-local | comparison | Given an embedded image, when parsed by `markitdown` using a local/free LLM vs OpenAI, then OCR quality remains sufficient for the agent | ✓ VALIDATED | markitdown, ocr, local-llm |
| 015 | ponytail-opencode-config | standard | Given OpenCode config, when ponytail is added as a plugin, then OpenCode correctly loads the ponytail hooks/instructions | ✓ VALIDATED | opencode, ponytail |
| 016 | ponytail-gemini-config | standard | Given Gemini CLI, when ponytail is installed via extensions, then Gemini CLI correctly loads ponytail hooks/instructions | ✓ VALIDATED | gemini-cli, ponytail |
| 017 | opencode-update-method | standard | Given an internet connection, when an update script runs, then opencode (and tools like gsd) reliably fetch the latest versions. | VALIDATED | opencode, npm |
| 018 | sync-brewfile-review | standard | Given system package drift, when the current `sync-brewfile` script is run, then the logic robustly and correctly updates the `Brewfile` without data loss. | VALIDATED | brew, bash |
| 019 | orchestrated-update-flow | standard | Given components needing update, when unified under a single command, then the sequence executes reliably without manual intervention. | VALIDATED | orchestration |
| 020 | workflow-docs-generation | standard | Given the orchestrated update script, when documented, then clear specific docs can be produced. | VALIDATED | docs |
| 021 | uninstall-old-gsd | standard | Given the old get-shit-done-cc installation, when running its uninstall command, then all previous GSD files are cleanly removed | PENDING | gsd, uninstall |
| 022 | install-new-gsd-core | standard | Given a clean OpenCode config, when running npx @opengsd/gsd-core@latest, then the new tools are installed | PENDING | gsd, install |
| 023 | gsd-core-compatibility | standard | Given the newly installed gsd-core, when executing standard workflows, then it functions correctly | PENDING | gsd, compat |
| 024 | chezmoi-orchestration-update | standard | Given our orchestrated update flow, when modifying run_onchange_setup-opencode.sh.tmpl, then it updates correctly | PENDING | chezmoi, orchestration |
| 025 | remove-redundant-deps | standard | Given Brewfile/Pacfile, when redundant deps (node, go, nvm, tree, etc.) are removed, then the system remains functional and relies on modern alternatives | ✓ VALIDATED | deps, cleanup |
| 026 | simplify-bash-wrappers | standard | Given complex bash functions (kport, extract, findfile), when replaced with simple aliases and Zsh modifiers, then functionality is identical and lines are reduced | ✓ VALIDATED | bash, zsh, ponytail |
| 027 | cleanup-dead-code | standard | Given duplicate sources and speculative scripts (switch-models, officecli drafts), when deleted, then no workflow is broken | ✓ VALIDATED | cleanup |
| 028 | ponytail-audit-validation | standard | Given the dotfiles repo, when running `ponytail-audit`, then it successfully identifies bloat or over-engineering that manual cleanup missed | ✓ VALIDATED | ponytail, audit, cleanup |
| 029 | officecli-skill-hybrid-test | standard | Given the existing `officecli` GSD skill, when tasked to extract and edit a document, then it successfully uses the `markitdown` hybrid approach without error | ⚠ PARTIAL | officecli, markitdown, integration |
| 030 | mise-global-tools | standard | Given `mise`, when configuring global tools (`mise use -g`), then they are correctly shimmed and available to chezmoi scripts without complex path management | ✓ VALIDATED | mise, tools, chezmoi |
| 031 | zsh-startup-profiling | standard | Given the current `.zshrc`, when profiled via `zprof` or `hyperfine`, then startup time is < 50ms and the lazy-loading strategy is confirmed effective | ✓ VALIDATED | zsh, performance, profiling |
| 032 | gsd-core-skill-collision | standard | Given custom `officecli` skill, when `gsd-core` updates, then custom modifications are preserved | ✓ VALIDATED | gsd-core, officecli, collision |
| 033 | uv-mise-path-integration | standard | Given `mise` and `uv tool`, when a script runs, then `markitdown` is found without PATH conflicts | ✓ VALIDATED | mise, uv, path |
| 034 | officecli-hybrid-skill-prompting | standard | Given drafted hybrid `SKILL.md`, when an agent edits, then it correctly uses `markitdown` and `officecli close` | ✓ VALIDATED | officecli, markitdown, prompting |
| 035 | officecli-read-commands-cleanup | standard | Given `officecli` with read commands removed, then write operations still function with Resident Mode | ✓ VALIDATED | officecli, cleanup |
| 036 | full-skill-replacement-e2e | standard | Given the official `officecli` skill is updated with the hybrid loop, when a full agent is tasked with editing, then it correctly manipulates office docs without legacy commands | PENDING | officecli, markitdown, integration |
| 037 | concurrent-officecli-resident-mode | standard | Given two concurrent writes to the same file, when they both use `officecli`, then does Resident Mode prevent corruption | PENDING | officecli, concurrency |
| 038 | markdown-to-dom-translation | standard | Given standard markdown diffs from an LLM, when parsed, then can they be reliably translated into `officecli` DOM or text-replace operations | PENDING | markitdown, officecli, parsing |
| 039 | markitdown-cost-profiling | standard | Given a 50+ slide deck with images, when parsed by markitdown OCR, then what is the token cost and latency using remote vs local LLMs | PENDING | markitdown, profiling |
| 040 | officecli-template-hydration | standard | Given a template .docx and chezmoi variables, when processed, then can officecli reliably generate a populated document during `chezmoi apply` | PENDING | officecli, chezmoi, templates |
| 041 | gemini-ponytail-install | standard | Given Gemini CLI, when ponytail is installed via extension URL, then it is recognized and loaded | PENDING | gemini, ponytail |
| 042 | gemini-ponytail-debug | standard | Given a failed extension install, when running gemini in debug mode, then the root cause of the load failure is identifiable | PENDING | gemini, ponytail, debugging |

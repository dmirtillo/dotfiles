# Spike Manifest

## Idea
**Previous:** Would it be possible to move the mcp servers into litellm? how would that work then by connecting gemini cli and opencode to those?
**Current:** Rework the `officecli` implementation to use `markitdown` as the read engine, while preserving `officecli`'s write/DOM capabilities.

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

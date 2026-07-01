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
| 013 | markitdown-performance | standard | Given a large 50+ page Office file, when parsed by `markitdown`, then extraction completes quickly without risking agent timeouts | PENDING | markitdown, performance |
| 014 | markitdown-images-local | comparison | Given an embedded image, when parsed by `markitdown` using a local/free LLM vs OpenAI, then OCR quality remains sufficient for the agent | PENDING | markitdown, ocr, local-llm |

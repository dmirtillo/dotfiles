# Tools & Packages

This repository installs a wide variety of tools to ensure a consistent, modern development experience across platforms.

## Core CLI Tools
- **Modern Replacements:** `eza` (ls), `bat` (cat), `dust` (du), `duf` (df), `gping` (ping), `zoxide` (cd), `procs` (ps)
- **Search & Navigation:** `fd`, `ripgrep`, `fzf`, `tree`
- **System Monitoring:** `btop`, `htop`, `bottom`
- **Archives & Utilities:** `jq`, `yq`, `tldr`, `thefuck`, `direnv`, `sevenzip` (7-Zip)

## DevOps & Cloud
- **Containers:** `docker`, `lazydocker`, `helm`, `kubernetes-cli`, `minikube`, `skaffold`
- **Infrastructure as Code:** `ansible`, `packer`, `terraform` (via `mise`)
- **Cloud Providers:** `awscli`, `azure-cli`, `gcloud-cli`, `localstack-cli`

## Languages & Runtimes
- **Python:** `python`, `uv`, `pipx`, `pytest`, `ruff`, `mypy`, `black`
- **Java:** `openjdk`, `maven`, `groovy`, `jenv`
- **Node & JavaScript:** `node` (via `mise`), `npm`, `bun`, `mise`

## Git & AI
- **Version Control:** `git`, `lazygit`, `gh`, `git-filter-repo`
- **AI Runtimes & CLIs:**
  - `opencode`: Official v2 client/server runtime (extra/opencode on Arch, homebrew-core on macOS)
  - `gemini-cli`: Google Gemini CLI via `mise` (`npm:@google/gemini-cli`)
  - `litellm`: Local proxy service on `localhost:4000` routing Claude Opus/Sonnet and xAI Grok to Vertex AI endpoints
  - `markitdown`: Microsoft document conversion tool (via `uv tool`)
- **Model Context Protocol (MCP) Servers:**
  - `gcp-cost`: Google Cloud pricing and cost estimator (via `mise`)
  - `aws-pricing`: AWS Pricing and Bedrock architecture analyzer (via `uvx`)
  - `gsd`: Get Shit Done meta-prompting and execution framework (`gsd-mcp-server`)
- **Media Tools:** `losslesscut-bin` (video cutting tool without re-encoding)

For the exact list of packages installed on each platform, see the `Brewfile` (macOS) and `Pacfile` (Arch Linux).

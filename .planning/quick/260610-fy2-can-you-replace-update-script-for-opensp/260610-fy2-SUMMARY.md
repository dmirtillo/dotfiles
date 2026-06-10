---
title: Update openspec script
date: 2026-06-10
status: complete
---

# Summary
- Replaced `npm install -g @fission-ai/openspec@latest` with `npm install -g @fission-ai/openspec@latest --dangerously-allow-all-scripts` in `dot_zshrc.tmpl`.
- This ensures the proper flags are passed when updating tools via `brewup` on macOS.

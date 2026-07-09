# Testing Patterns

**Analysis Date:** 2026-07-09

## Test Framework

**Runner:**
- Plain shell scripts executed directly (e.g., `bash test_sync.sh`). No formal test runner.

**Assertion Library:**
- Standard POSIX utilities: `grep`, `diff`, `[ -z ... ]`.
- Example: `git diff --no-index "$TARGET" "$MERGED" || true`
- Example: `if ! grep -q "^$escaped" "$TARGET"; then ...`

**Run Commands:**
```bash
./test_merge.sh              # Run individual test scripts
./test_pptx.sh               # Execute end-to-end office script tests
```

## Test File Organization

**Location:**
- Tests are co-located in spike directories rather than a central test folder:
  - `.opencode/skills/officemanagement/sources/006-brewfile-sync-preserve-comments/test_merge.sh`
  - `.opencode/skills/officemanagement/sources/011-pptx-hybrid-integration/test_pptx.sh`
- Occasional top-level test scripts (e.g., `test_office_read.sh`)

**Naming:**
- Prefix `test_*.sh`

## Test Structure

**Patterns:**
- **Setup:** Create copy of target files or generate scratch files via `python-pptx`.
- **Execution:** Run the actual CLI operation being validated (e.g., `brew bundle dump`, `officecli set`, `uv run`).
- **Assertion:** Check the final file states using `grep` or visually diff the results.
- **Teardown:** Often omitted; relies on `.planning/spikes/` scratch directories.

## Mocking

**Framework:** None

**Patterns:**
- Tests interact with the actual filesystem, binaries, and environment.
- Example: `test_pptx.sh` creates a real PPTX, edits it with `officecli`, and reads it with `markitdown`.

**What NOT to Mock:**
- File states, CLI binary executions, and actual plugin integrations are evaluated end-to-end to ensure true behavior.

## Coverage

**Requirements:** None enforced.

## Test Types

**Integration/E2E Tests:**
- Almost exclusively integration/e2E tests evaluating full pipeline behaviors (e.g., syncing brewfiles, modifying office docs).

---

*Testing analysis: 2026-07-09*

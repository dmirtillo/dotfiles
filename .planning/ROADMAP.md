### Phase 6: Core Spike Knowledge Integration

**Goal**: Integrate recent spike findings (Spike 036-042) into the core CLI scripts for agentic operation.
**Depends on**: Phase 5
**Requirements**: CORE-01
**Success Criteria** (what must be TRUE):

  1. `markitdown` reads are configured correctly natively.
  2. `officecli` sets are executed properly via unified agent aliases.

**Plans**: 3/3 plans complete

- [x] 06-01-PLAN.md — Core CLI Aliases (office-read / office-write)
- [x] 06-02-PLAN.md — Template Hydration & Gemini Config
- [x] 06-03-PLAN.md — Gap Closure: CLI Aliases & Gemini Setup

### Phase 7: Antigravity CLI BYOK Implementation

**Goal**: Implement the PAYGO environment variables for antigravity-cli discovered in Spike 043.
**Depends on**: Phase 6
**Requirements**: CORE-02
**Success Criteria** (what must be TRUE):

  1. `antigravity-cli` bypasses the subscription requirement natively.
  2. The `AGY_BUSINESS_PAYGO_TIER` and `GCP_GE_PAYGO_TIER` env vars are configured in the system shell profile.

**Plans**: 1/1 plans complete

- [x] 07-01-PLAN.md — Export PAYGO env vars in Zsh and PowerShell profiles

### Phase 8: OfficeCLI Hybrid Markitdown Workflow

**Goal**: Establish a robust hybrid approach to document modification that pairs `markitdown` for reading and `officecli query/set` for structurally-aware targeting.
**Depends on**: Phase 7
**Requirements**: CORE-03
**Success Criteria** (what must be TRUE):

  1. A query wrapper utility correctly links target text to explicit DOM paths.
  2. The workflow can execute end-to-end structural DOM changes (e.g. fill colors) on documents processed through `markitdown`.

**Plans**: 1/1 plans complete

- [x] 08-01-PLAN.md — Hybrid workflow wrappers (office-query, office-format) for Zsh and PowerShell

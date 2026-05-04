# Phase 3: PowerShell Parity - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-04
**Phase:** 03-powershell-parity
**Areas discussed:** Prompt Customization, Alias Strategy, Profile Structure, Init Performance

---

## Prompt Customization

| Option | Description | Selected |
|--------|-------------|----------|
| P10k visual parity | Uses Oh My Posh, trying to match the existing Powerlevel10k look | |
| Standard Oh My Posh theme | Uses Oh My Posh but with a standard pre-built theme | ✓ |
| Minimal native prompt | Native minimal PS prompt to maximize performance | |

**User's choice:** Standard Oh My Posh theme

---

## Alias Strategy

| Option | Description | Selected |
|--------|-------------|----------|
| Native functions for complex aliases | Write PS functions for complex aliases, Set-Alias for simple ones | ✓ |
| Minimal subset | Only port basic aliases (ls, cd..), ignore complex dev tool wrappers | |
| Shared definition file | Maintain a separate shared file parsed by both | |

**User's choice:** Native functions for complex aliases (Recommended)

---

## Profile Structure

| Option | Description | Selected |
|--------|-------------|----------|
| Monolithic profile | Single Microsoft.PowerShell_profile.ps1.tmpl file for simplicity | ✓ |
| Modular sourced files | Main profile dot-sources separate files | |

**User's choice:** Monolithic profile (Recommended)

---

## Init Performance

| Option | Description | Selected |
|--------|-------------|----------|
| Standard Initialization | Load tools normally. May add ~100-200ms to startup. | |
| Aggressive caching | Cache initialization scripts to disk to maintain the strict <50ms goal | ✓ |

**User's choice:** Aggressive caching (Recommended)

---

## the agent's Discretion

- Selection of the specific standard Oh My Posh theme.
- Exact PowerShell syntax and mechanism for the caching logic.

## Deferred Ideas

None

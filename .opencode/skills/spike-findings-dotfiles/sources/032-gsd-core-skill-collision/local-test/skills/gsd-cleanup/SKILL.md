---
name: gsd-cleanup
description: "Archive accumulated phase directories from completed milestones"
---

<objective>
Archive phase directories from completed milestones into `.planning/milestones/v{X.Y}-phases/`.

Use when `.planning/phases/` has accumulated directories from past milestones.
</objective>

<execution_context>
@/Users/dmirtillo/projects/software/dotfiles/.planning/spikes/032-gsd-core-skill-collision/local-test/gsd-core/workflows/cleanup.md
</execution_context>

<process>
Execute end-to-end.
Identify completed milestones, show a dry-run summary, and archive on confirmation.
</process>

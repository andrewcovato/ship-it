---
description: View and manage project backlogs — add items, promote exploration ideas, triage tech debt, review priorities
---
Load the ship-it skill. This is a `/ship-backlog` invocation.

Read `./references/backlog-protocol.md` for the full backlog management protocol.
Read `.project/state.json` for current `backlog_stats`.

## Display Backlogs

Present a summary of all three backlogs:
1. Read `.project/backlog/exploration.md` — ideas discussed but not spec'd
2. Read `.project/backlog/tech-debt.md` — technical shortcuts and fragility
3. Read `.project/backlog/backlog.md` — spec'd but unscheduled work

Present:
```
Backlogs: [N] exploration | [N] tech debt | [N] main backlog

Exploration (not yet spec'd):
- [Idea] — [one-line description]

Tech Debt:
- [TD-NNN] [Title] — severity: [level]

Main Backlog (ready for sprint):
- [B-NNN] [Title] — priority: [level], size: [S/M/L]
```

## Actions

Based on user input (`$@`), handle:

### Add an item
- Determine which backlog (exploration, tech-debt, or main)
- For exploration: capture idea, source, related area, open questions
- For tech-debt: capture severity, category, location, impact
- For main backlog: capture description, acceptance criteria, size, dependencies
- Write to the appropriate file
- Update `backlog_stats` in `state.json`

### Promote an item
- Move from `exploration.md` to `backlog.md`
- Prompt for missing fields: acceptance criteria, size, dependencies
- Use Given/When/Then format for acceptance criteria
- Update both files and `state.json`

### Triage
Walk through items by priority:
- For each item: keep, drop, promote, or defer
- Update all affected files
- Update `state.json`

### Review by area
If user specifies an area (e.g., "auth", "frontend"), filter all backlogs to show only related items.

$@

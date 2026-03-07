---
description: Generate or refresh the project kanban board — visual overview of project status with current sprint highlighted
---
Load the ship-it skill. This is a `/ship-board` invocation.

## Update Kanban Board

### Step 1: Read Source Data

Read the following project state files:
- `.project/KANBAN.md` — the **single source of truth** for card data (if it exists)
- `.project/state.json` — current phase, sprint, milestone progress
- `.project/roadmap/milestones.md` — all tasks with statuses
- `.project/roadmap/execution-plan.md` — sprint assignments
- `.project/backlog/backlog.md` — spec'd but unscheduled work

### Step 2: Update KANBAN.md (data layer)

If `.project/KANBAN.md` exists:
1. Read it — it is the **authority** for card text and column placement
2. Compare against current `state.json`, `milestones.md`, `execution-plan.md`, and `backlog.md`
3. Apply ONLY changes justified by diffs in those source files:
   - Task status changed → move line to new section, update status marker
   - New task added → add new line with text copied verbatim from source
   - Task removed → remove line
   - Sprint advanced → update header metadata
   - Blocker added/resolved → move line to/from Blocked section
4. Preserve all card text that has NOT changed — copy it exactly
5. NEVER re-interpret or rephrase card text
6. Update the header metadata (Sprint, Milestone, Phase, Session)
7. If nothing changed in the source data, do NOT rewrite KANBAN.md — leave it as-is and inform the user

If `.project/KANBAN.md` does NOT exist, create it from scratch:
1. Read `./references/doc-templates.md` for the KANBAN.md template format
2. Populate cards from `milestones.md`, `execution-plan.md`, and `backlog.md`
3. Card text MUST be copied verbatim from the source files — never paraphrase

### Step 3: Render board.html (presentation layer)

Choose the HTML template:
1. If `.project/mocks/kanban-template.html` exists → use the user's custom template
2. Otherwise → read `./references/kanban-template.html` (the default locked template)

Render `.project/mocks/board.html` from the updated KANBAN.md:
1. Copy the template
2. Replace `{{PLACEHOLDER}}` values with data from KANBAN.md header
3. Populate card HTML from KANBAN.md card lines
4. Compute KPI values from KANBAN.md (count cards per section)
5. Cards in the "In Progress" section use `card card--active-sprint` class
6. Each card's text comes from the KANBAN.md line — do NOT re-derive from milestones.md

### Card Assignment Rules
- **Backlog** `[ ]`: Items in `backlog.md` not assigned to a sprint
- **Up Next** `[ ]`: Items assigned to the next sprint (not current)
- **In Progress** `[~]`: Items in the current sprint with status "doing"
- **Done** `[x]`: Items with status "done" from the current milestone
- **Blocked** `[!]`: Items with blockers (from `state.json` blockers array)

### Card HTML Format (LOCKED in default template)
```html
<div class="card">
  <div class="card__title">Exact task name from KANBAN.md</div>
  <div class="card__meta">
    <span class="card__badge badge--sprint">Sprint N</span>
    <span class="card__badge badge--size-m">M</span>
  </div>
</div>
```

For in-progress cards: `<div class="card card--active-sprint">`

Size badge classes: `badge--size-s`, `badge--size-m`, `badge--size-l`, `badge--size-xl`

### What MUST NOT Change Between Sessions
- The HTML template CSS and structure
- The column order: Backlog → Up Next → In Progress → Done → Blocked
- The KPI bar layout
- Card text (unless the underlying source data changed)

Write to `.project/mocks/board.html` and open in browser.

$@

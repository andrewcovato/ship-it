---
description: Generate or refresh the project kanban board — visual overview of project status with current sprint highlighted
---
Load the ship-it skill. This is a `/ship-board` invocation.

## Update Kanban Board

### Step 1: Read Current State

Read the following project state files:
- `.project/state.json` — current phase, sprint, milestone progress
- `.project/roadmap/milestones.md` — all tasks with statuses
- `.project/roadmap/execution-plan.md` — sprint assignments
- `.project/backlog/backlog.md` — spec'd but unscheduled work

### Step 2: Read the Locked Template

Read `./references/kanban-template.html`. This is the **fixed HTML/CSS template** for ALL kanban boards. The layout, CSS, column order, card structure, KPI bar, and visual style are LOCKED. You MUST use this template exactly — do not freestyle the layout, do not use visual-explainer for the board, do not change column order, card classes, or CSS.

The template uses `{{PLACEHOLDER}}` markers. Replace them with real data. The card HTML structure is shown in comments inside each column.

### Step 3: Check for Existing Board

If `.project/mocks/board.html` already exists:
1. Read the existing board HTML — it is the **source of truth** for card content and column placement
2. Identify what changed in the source data files since the board was last written
3. Apply ONLY those changes:
   - Task status changed → move the `<div class="card">` block to the new column
   - New task added → add a new card using the card template from the locked template
   - Task removed → remove the card
   - Sprint advanced → update KPI bar values, move sprint badge on cards
   - Blocker added/resolved → move card to/from Blocked column
4. Preserve all card `card__title` text that has NOT changed in the underlying data
5. NEVER re-interpret or rephrase existing card titles — copy them exactly from the existing board
6. If nothing changed in the source data, do NOT rewrite the board — leave it as-is and inform the user
7. Update the KPI bar values and column counts to reflect current state
8. Update the header meta line (session number, phase, milestone)

If `.project/mocks/board.html` does NOT exist, generate a new board by:
1. Copying the locked template from `./references/kanban-template.html`
2. Replacing all `{{PLACEHOLDER}}` values with real data
3. Populating cards using the card template structure shown in the template comments

### Card Assignment Rules
- **Backlog**: Items in `backlog.md` not assigned to a sprint
- **Up Next**: Items assigned to the next sprint (not current)
- **In Progress**: Items in the current sprint with status "doing" — use `card card--active-sprint` class
- **Done**: Items with status "done" from the current milestone
- **Blocked**: Items with blockers (from `state.json` blockers array)

### Card Format (LOCKED)
Every card MUST use this exact HTML structure:
```html
<div class="card">
  <div class="card__title">Exact task name from milestones.md or backlog.md</div>
  <div class="card__meta">
    <span class="card__badge badge--sprint">Sprint N</span>
    <span class="card__badge badge--size-m">M</span>
  </div>
</div>
```

For in-progress cards in the active sprint, add `card--active-sprint`:
```html
<div class="card card--active-sprint">
```

Size badge classes: `badge--size-s`, `badge--size-m`, `badge--size-l`, `badge--size-xl`

### What MUST NOT Change Between Sessions
- The CSS (copy verbatim from the template)
- The column order: Backlog → Up Next → In Progress → Done → Blocked
- The KPI bar layout (4 cards: Total Tasks, % Complete, Blockers, Current Sprint)
- The header structure
- The card HTML class names and nesting
- The footer

Write to `.project/mocks/board.html` and open in browser.

$@

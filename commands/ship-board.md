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

### Step 2: Check for Existing Board

If `.project/mocks/board.html` already exists:
1. Read the existing board HTML — it is the **source of truth** for card content and column placement
2. Identify what changed in the source data files since the board was last written
3. Apply ONLY those changes:
   - Task status changed → move card to new column
   - New task added → add new card
   - Task removed → remove card
   - Sprint advanced → update sprint highlight and KPI bar
   - Blocker added/resolved → move card to/from Blocked column
4. Preserve all card titles, descriptions, and placements that have NOT changed in the underlying data
5. NEVER re-interpret or rephrase existing cards — use the exact wording from the existing board unless the source data changed
6. If nothing changed in the source data, do NOT rewrite the board — leave it as-is and inform the user

If `.project/mocks/board.html` does NOT exist, generate a new board from scratch (proceed to Layout section).

### Layout
- **KPI Summary Bar** at top: total tasks count, % complete, blockers count, current sprint name
- **5 Columns**: Backlog | Up Next | In Progress | Done | Blocked
- **Cards** in each column with: feature/task name, sprint alignment, T-shirt size (S/M/L/XL)
- **Current sprint highlight**: Cards in the active sprint get a colored left border accent and a sprint badge

### Card Assignment Rules
- **Backlog**: Items in `backlog.md` not assigned to a sprint
- **Up Next**: Items assigned to the next sprint (not current)
- **In Progress**: Items in the current sprint with status "doing"
- **Done**: Items with status "done" from the current milestone
- **Blocked**: Items with blockers (from `state.json` blockers array)

### Visual Style
Use a clean dashboard aesthetic with:
- Responsive CSS Grid layout for columns
- Cards with subtle shadows and rounded corners
- Color-coded left borders: blue (backlog), purple (up next), amber (in progress), green (done), red (blocked)
- Current sprint cards have an additional accent (badge or highlighted border)
- Dark header with project name and phase

### Interaction
The board is a static HTML snapshot. It provides a quick visual overview — not interactive task management.

Load the visual-explainer skill. Read the CSS patterns reference file (particularly the Card Grid pattern and KPI card pattern).

Write to `.project/mocks/board.html` and open in browser.

$@

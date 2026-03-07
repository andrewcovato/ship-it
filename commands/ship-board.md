---
description: Generate or refresh the project kanban board — visual overview of project status with current sprint highlighted
---
Load the ship-it skill. This is a `/ship-board` invocation.

## Generate Kanban Board

Read the following project state files:
- `.project/state.json` — current phase, sprint, milestone progress
- `.project/roadmap/milestones.md` — all tasks with statuses
- `.project/roadmap/execution-plan.md` — sprint assignments
- `.project/backlog/backlog.md` — spec'd but unscheduled work

Load the visual-explainer skill. Read the CSS patterns reference file (particularly the Card Grid pattern and KPI card pattern).

Generate a self-contained HTML kanban board at `.project/mocks/board.html` with:

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
The board is a static HTML snapshot (overwritten each time, not versioned). It provides a quick visual overview — not interactive task management.

Write to `.project/mocks/board.html` and open in browser.

$@

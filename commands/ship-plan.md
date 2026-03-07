---
description: View or update the execution plan — current sprint, upcoming sprints, parallelization opportunities, re-chunk if needed
---
Load the ship-it skill. This is a `/ship-plan` invocation.

Read `.project/state.json` and `.project/roadmap/execution-plan.md`.
Read `./references/execution-protocol.md` for sprint sizing and parallelization patterns.

## Display Execution Plan

Present the current execution plan:

1. **Current Sprint Status:**
   - Sprint name, type, progress (X/Y tasks)
   - Estimated vs actual sessions
   - Remaining tasks with sizes and dependencies
   - Parallelization opportunities

2. **Upcoming Sprints:**
   - Next 3-5 sprints with scope summaries
   - Dependencies between sprints
   - Estimated session counts

3. **Velocity Report:**
   - Average tasks per session
   - Velocity trend (improving, stable, declining)
   - Timeline projection: "At current velocity, milestone [M] completes in ~[N] sessions"

4. **Parallelization Opportunities:**
   - What can run in separate worktrees simultaneously
   - Independent frontend/backend tracks
   - Test-writing as parallel activity

## Update Execution Plan

If the user provides context about changes (`$@`), re-chunk the execution plan:

1. Assess what changed (scope, priority, blockers, velocity)
2. Re-chunk remaining sprints using sizing heuristics
3. Update `.project/roadmap/execution-plan.md`
4. Update `.project/state.json`
5. Inform user of changes: "Re-chunked execution plan: [summary of changes]"

If `$@` includes "visual" or "timeline", generate a sprint timeline visualization via visual-explainer → `.project/mocks/mock-NNN-sprint-timeline.html`, open in browser.

$@

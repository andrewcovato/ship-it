---
description: Resume a project session or check project status — loads state, presents metrics, generates kanban board
---
Load the ship-it skill. This is a `/ship-status` invocation — resume or check status.

Read `./references/session-protocol.md` for the full session start protocol.

## Session Resume
1. Read `.project/state.json` — extract phase, active milestone, active sprint, blockers, things_not_to_redo
2. Read `.project/sessions/HANDOFF.md` — extract last session context and priorities
3. Present status with metrics:
   ```
   Session [N+1]. Phase: [phase].
   Milestone [M-name]: [X/Y] tasks complete.
   Current sprint: [sprint name] ([type]) — [X/Y] tasks done.
   Last session: [one-line summary].

   Priorities:
   1. [Top priority]
   2. [Second priority]
   3. [Third priority]

   Blockers: [none | list]
   ```
4. Update kanban board using the locked template at `./references/kanban-template.html` (do NOT use visual-explainer for the board). If `.project/mocks/board.html` exists, read it first as source of truth and apply only data-driven changes. If not, generate fresh from the locked template. Open in browser.
5. Check proactive triggers (read `./references/proactive-triggers.md`):
   - Backlog items related to current sprint area?
   - Docs stale (>5 sessions since update)?
   - Roadmap drift?
   - Execution plan adjustments needed?
6. Increment `session_count` in `state.json`
7. Begin working session

$@

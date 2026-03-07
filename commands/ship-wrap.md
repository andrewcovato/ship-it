---
description: End session with full handoff — session notes, HANDOFF.md regeneration, state update, execution plan adjustment
---
Load the ship-it skill. This is a `/ship-wrap` invocation — end the current session.

Read `./references/session-protocol.md` for the full session end protocol.

## Session Wrap-Up

Execute these steps in order:

### 1. Enumerate Changes
Compile everything that happened this session:
- Tasks completed (with task IDs from milestones.md)
- Documents created or updated (with version numbers)
- Decisions made (with ADR numbers if applicable)
- Blockers encountered or resolved
- Roadmap or execution plan changes
- Backlog items added, promoted, or removed

### 2. Generate Session Notes
Read `.project/state.json` for session number and sprint info.
Write to `.project/sessions/<project-slug>-sprint-<N>-session-<NN>.md`

Include: accomplishments, decisions, docs changed, things NOT to redo, blockers, next priorities.

### 3. Regenerate HANDOFF.md
COMPLETELY REWRITE `.project/sessions/HANDOFF.md`. NEVER append.
Read `./references/doc-templates.md` for the HANDOFF.md template.

### 4. Archive Changed Docs
If any document had a major version change, archive the old version to `.project/archive/`.

### 5. Update state.json
- Update `last_session`
- Update `active_milestone` and `active_sprint` progress
- Update `docs_status` for any changed docs
- Curate `things_not_to_redo` (add new, remove irrelevant)
- Update `blockers`
- Update `backlog_stats`

### 6. Adjust Execution Plan
- Update current sprint progress in `execution-plan.md`
- If sprint complete → advance to next sprint
- If velocity differs from estimate → re-scope future sprints
- Note parallelization opportunities discovered

### 7. Update Kanban
Update KANBAN.md (data) FIRST, then render board.html (presentation).
- Read `.project/KANBAN.md` as the data authority. Apply ONLY changes from this session (tasks completed, blockers added/resolved, sprint advanced). Preserve all card text that hasn't changed. If KANBAN.md doesn't exist, create it.
- Render board.html from the updated KANBAN.md using the locked template (or user's custom template at `.project/mocks/kanban-template.html` if present). Open in browser.

### 8. Next-Session Guidance
Print:
```
Session wrapped. Next sprint: [Sprint N] — "[Sprint Name]"

To resume:
  claude  (SessionStart hook will auto-load context)
  or: /ship-status
```

$@

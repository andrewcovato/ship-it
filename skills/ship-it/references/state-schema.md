# State Schema — state.json

Machine-readable project state. **The single source of truth for all project status.** All other project files (plan.md, KANBAN.md, board.html, HANDOFF.md) are derived views generated from this data.

Updated after every significant action. Never edit derived views directly — update state.json, then regenerate.

## Tiered Loading Protocol

Session start reads only what's needed to orient:

1. **Tier 0 (always read):** `current`, `active_sprint`, `last_session`, `blockers` — ~50-80 lines. Enough to know where we are.
2. **Tier 1 (read HANDOFF.md):** Session narrative context — what happened last, what's next. ~30-50 lines.
3. **Tier 2 (on-demand):** `phases` array for big-picture view, `backlog` for planning, `decisions` for constraint-checking. Read when working on tasks or pivoting.

Total session start cost: Tier 0 + Tier 1 = ~100 lines. Full state is available on-demand.

## Full Schema

```json
{
  "project_name": "Human-readable project name",
  "project_slug": "kebab-case-slug",
  "version": 1,
  "session_count": 1,
  "last_session": {
    "number": 1,
    "date": "YYYY-MM-DD",
    "summary": "One-line summary of what happened"
  },

  "current": {
    "phase_id": "P-1",
    "milestone_id": "M-001",
    "sprint_id": "S-001",
    "phase_status": "active",
    "milestone_progress": "3/8 tasks",
    "sprint_progress": "2/5 tasks"
  },

  "active_sprint": {
    "id": "S-001",
    "name": "Sprint Name",
    "milestone_id": "M-001",
    "type": "feature | refactor | integration | hardening",
    "estimated_sessions": 2,
    "actual_sessions": 1,
    "status": "active | complete | blocked",
    "tasks": [
      {
        "id": "T-001",
        "name": "Task name",
        "status": "pending | doing | done | blocked | skipped",
        "size": "S | M | L | XL",
        "acceptance_criteria": ["AC 1", "AC 2"],
        "dependencies": ["T-000"],
        "blocker_id": null
      }
    ]
  },

  "phases": [
    {
      "id": "P-1",
      "name": "Phase Name",
      "status": "active | done | planned",
      "milestones": [
        {
          "id": "M-001",
          "name": "Milestone Name",
          "status": "active | done | planned",
          "sprints": [
            {
              "id": "S-001",
              "name": "Sprint Name",
              "status": "active | done | planned",
              "type": "feature | refactor | integration | hardening",
              "task_ids": ["T-001", "T-002", "T-003"]
            }
          ],
          "tasks": [
            {
              "id": "T-001",
              "name": "Task name",
              "status": "pending | doing | done | blocked | skipped",
              "size": "S | M | L | XL",
              "sprint_id": "S-001",
              "acceptance_criteria": ["AC 1", "AC 2"],
              "dependencies": []
            }
          ]
        }
      ]
    }
  ],

  "backlog": [
    {
      "id": "BL-001",
      "name": "Backlog item name",
      "tier": "main | exploration | tech-debt",
      "description": "Brief description",
      "source_session": 3,
      "promoted_to": null
    }
  ],

  "blockers": [
    {
      "id": "B-001",
      "description": "What's blocked",
      "blocking": ["T-003"],
      "owner": "user | external | technical",
      "since_session": 2,
      "resolved": false
    }
  ],

  "decisions": [
    {
      "id": "ADR-001",
      "title": "Decision Title",
      "summary": "One-line summary of what was decided",
      "session": 1,
      "impact": ["T-005", "T-008"],
      "file": "decisions/adr-001-decision-title.md"
    }
  ],

  "things_not_to_redo": [
    "Database schema is finalized — do not redesign the user table",
    "We chose Redis over Memcached (see ADR-002) — do not reconsider"
  ],

  "docs_status": {
    "prd": { "version": 1, "last_updated_session": 1, "status": "draft | review | approved" },
    "technical_spec": { "version": 1, "last_updated_session": 1, "status": "draft | review | approved" },
    "architecture": { "version": 1, "last_updated_session": 1, "status": "draft | review | approved" },
    "api_spec": { "version": null, "last_updated_session": null, "status": "not created" },
    "data_model": { "version": null, "last_updated_session": null, "status": "not created" },
    "ux_spec": { "version": null, "last_updated_session": null, "status": "not created" }
  },

  "execution": {
    "mode": "manual | autonomous | autonomous-superpowers",
    "superpowers_prompted": false,
    "superpowers_execution_mode": "auto | executing-plans | subagent-driven-development",
    "current_go_session": null
  },

  "counters": {
    "mock": 1,
    "adr": 0,
    "task": 0,
    "sprint": 0,
    "milestone": 0,
    "phase": 0,
    "backlog": 0
  }
}
```

## Key Design Decisions

### Single source of truth
Every entity (phase, milestone, sprint, task, blocker, decision, backlog item) has exactly ONE canonical location in state.json. All other files are derived views:

| Derived View | Generated From | Purpose |
|-------------|---------------|---------|
| `plan.md` | `phases` array | Human-readable plan hierarchy |
| `KANBAN.md` | `active_sprint.tasks` + `backlog` + `blockers` | Board data (columns + cards) |
| `board.html` | `KANBAN.md` + template | Visual kanban board |
| `HANDOFF.md` | `current` + `active_sprint` + `last_session` + `blockers` | Session context for next session |

### Deterministic traceability
Every task traces upward: `T-001` → `S-001` → `M-001` → `P-1`. Progress rolls up deterministically:
- Task done → sprint progress updates → milestone progress updates → phase status updates
- No manual sync between files. `current.sprint_progress` is always derivable from `active_sprint.tasks`.

### Backlog integration
Backlog items are NOT tasks until promoted. Promotion means: assign an ID from the task counter, add to a milestone's `tasks` array with a `sprint_id`, remove from `backlog` (set `promoted_to` = task ID). Tech debt and exploration are just backlog tiers.

### Tiered loading
`current` + `active_sprint` + `blockers` = fast orient (~80 lines).
`phases` = full plan on-demand (scales with project size, but only read when pivoting or showing roadmap).
This keeps session start cheap regardless of project size.

## Field Descriptions

| Field | Updated When | Purpose |
|-------|-------------|---------|
| `version` | Schema migration | Tracks state.json schema version |
| `session_count` | Session start | Monotonically increasing counter |
| `last_session` | Session end | Quick reference to last session |
| `current` | Task/sprint/milestone completion | Fast orientation — what's active now |
| `active_sprint` | Task status change, sprint advance | Full detail for current work |
| `phases` | Plan changes, task completion | Complete plan hierarchy |
| `backlog` | Item added/promoted/removed | Unscheduled work across tiers |
| `blockers` | Blocker added/resolved | Active impediments |
| `decisions` | Decision detected in conversation | Proactively captured ADRs |
| `things_not_to_redo` | Session end (curated) | Prevents re-litigation of settled decisions |
| `docs_status` | Doc created/updated | Version and freshness per doc |
| `execution` | `/ship-go` start/end | Autonomous execution state |
| `counters` | Entity created | Sequential ID generation |

## Sync Protocol

Update `state.json` immediately after:
- Task status change → update in `active_sprint.tasks` AND `phases[].milestones[].tasks[]`, recalculate `current.*_progress`
- Sprint completed → advance `current.sprint_id`, populate new `active_sprint`, mark old sprint done in `phases`
- Milestone completed → advance `current.milestone_id`, recalculate phase progress
- Decision detected → append to `decisions`, increment `counters.adr`, create ADR file
- Blocker encountered/resolved → update `blockers`, update affected task statuses
- Backlog item promoted → remove from `backlog`, add to milestone tasks, assign sprint
- Document created/updated → update `docs_status`
- Session start → increment `session_count`
- Session end → update `last_session`, curate `things_not_to_redo`, regenerate HANDOFF.md

## Derived View Regeneration

When state.json changes, regenerate affected views:
- Task status change → regenerate KANBAN.md + board.html
- Sprint advance → regenerate KANBAN.md + board.html + plan.md
- Pivot/replan → regenerate plan.md + KANBAN.md + board.html
- Session end → regenerate HANDOFF.md

Views are NEVER edited directly. If a view looks wrong, fix state.json and regenerate.

## Phase Transitions

| From | To | Trigger |
|------|----|---------|
| discovery | planning | Doc suite generated, roadmap approved |
| planning | building | Execution plan approved, first sprint started |
| building | shipping | Final milestone complete, hardening done |

## things_not_to_redo Management

- **Add** at session end: explicit statements about finalized decisions
- **Remove** when irrelevant: after a major pivot invalidates the decision
- **Format**: imperative statement + reference to relevant doc/ADR
- **Keep concise**: aim for 5-15 items, prune aggressively

## Data Duplication Note

`active_sprint` duplicates data from the matching entry in `phases[].milestones[].sprints[]` + tasks. This is intentional — it provides Tier 0 fast access without traversing the full hierarchy. The sync protocol ensures both copies stay consistent: every task status update writes to BOTH locations.

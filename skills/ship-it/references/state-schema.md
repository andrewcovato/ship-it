# State Schema — state.json

Machine-readable project state. Updated after every significant action. This is the single source of truth for project status.

## Full Schema

```json
{
  "project_name": "Human-readable project name",
  "project_slug": "kebab-case-slug (used in file naming)",
  "current_phase": "discovery | planning | building | shipping",
  "session_count": 1,
  "last_session": {
    "number": 1,
    "date": "YYYY-MM-DD",
    "slug": "project-slug-sprint-1-session-01",
    "summary": "One-line summary of what happened"
  },
  "active_milestone": {
    "id": "M1",
    "name": "Milestone Name",
    "total_tasks": 10,
    "completed_tasks": 3,
    "blocked_tasks": 0,
    "status": "not started | in progress | complete"
  },
  "active_sprint": {
    "number": 1,
    "name": "Sprint Name",
    "type": "feature | refactor | integration | hardening",
    "total_tasks": 5,
    "completed_tasks": 2,
    "estimated_sessions": 2,
    "actual_sessions": 1,
    "status": "in progress | complete | re-scoping"
  },
  "roadmap_version": 1,
  "blockers": [
    {
      "id": "B-001",
      "description": "What's blocked",
      "blocking": ["T-003", "T-004"],
      "since_session": 2,
      "owner": "user | external | technical"
    }
  ],
  "recent_decisions": [
    {
      "adr": "ADR-001",
      "title": "Decision Title",
      "session": 1,
      "impact": "Brief impact statement"
    }
  ],
  "backlog_stats": {
    "exploration": 5,
    "tech_debt": 3,
    "main_backlog": 8
  },
  "docs_status": {
    "prd": { "version": 1, "last_updated_session": 1, "status": "draft | review | approved" },
    "technical_spec": { "version": 1, "last_updated_session": 1, "status": "draft | review | approved" },
    "architecture": { "version": 1, "last_updated_session": 1, "status": "draft | review | approved" },
    "api_spec": { "version": null, "last_updated_session": null, "status": "not created" },
    "data_model": { "version": null, "last_updated_session": null, "status": "not created" },
    "ux_spec": { "version": null, "last_updated_session": null, "status": "not created" },
    "roadmap": { "version": 1, "last_updated_session": 1, "status": "draft | review | approved" },
    "milestones": { "version": 1, "last_updated_session": 1, "status": "draft | review | approved" },
    "execution_plan": { "version": 1, "last_updated_session": 1, "status": "draft | review | approved" }
  },
  "things_not_to_redo": [
    "Database schema is finalized — do not redesign the user table",
    "We evaluated Redis vs Memcached and chose Redis (see ADR-002)",
    "Auth flow spec'd in session 3 — read .project/docs/ux-spec.md section 2"
  ],
  "mock_counter": 1,
  "adr_counter": 0
}
```

## Field Descriptions

| Field | Type | Updated When | Purpose |
|-------|------|-------------|---------|
| `project_name` | string | Init only | Human-readable name |
| `project_slug` | string | Init only | Used for file naming (kebab-case) |
| `current_phase` | enum | Phase transitions | Tracks macro project state |
| `session_count` | int | Session start | Monotonically increasing counter |
| `last_session` | object | Session end | Quick reference to last session |
| `active_milestone` | object | Task completion, milestone change | Current milestone progress |
| `active_sprint` | object | Task completion, sprint change | Current sprint progress |
| `roadmap_version` | int | Roadmap revision | Tracks major roadmap changes |
| `blockers` | array | Blocker added/resolved | Active blockers with impact |
| `recent_decisions` | array | ADR created | Last 5 decisions for quick reference |
| `backlog_stats` | object | Backlog item added/removed/promoted | Quick counts per backlog type |
| `docs_status` | object | Doc created/updated | Version and freshness per doc |
| `things_not_to_redo` | array | Session end (curated) | Prevents re-litigation of settled decisions |
| `mock_counter` | int | Mock generated | Sequential numbering for mock files |
| `adr_counter` | int | ADR created | Next ADR number |

## Sync Protocol

Update `state.json` immediately after:
- Document creation or update (update `docs_status`)
- Task completion (update `active_milestone` and `active_sprint`)
- Decision made (add to `recent_decisions`, increment `adr_counter`)
- Blocker encountered or resolved (update `blockers`)
- Roadmap changed (increment `roadmap_version`)
- Mock generated (increment `mock_counter`)
- Session started (increment `session_count`)
- Session ended (update `last_session`, curate `things_not_to_redo`)
- Sprint completed (advance `active_sprint`, update history)

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
- **Examples of good entries:**
  - "Database schema is finalized — do not redesign the user table"
  - "We chose Tailwind over styled-components (see ADR-002) — do not reconsider"
  - "Auth flow is fully spec'd in ux-spec.md section 2 — do not re-discover"
- **Examples of bad entries:**
  - "We talked about databases" (too vague)
  - "Don't change anything" (too broad)

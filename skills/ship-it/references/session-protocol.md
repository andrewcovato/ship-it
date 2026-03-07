# Session Protocol — Start, Checkpoint, End

Detailed protocols for managing session lifecycle. These ensure no context is lost between sessions and the project state remains accurate.

## Session Start Protocol

Execute these steps in order when a session begins (auto-resume or `/ship-status`):

### Step 1: Load State
```
Read .project/state.json
Read .project/sessions/HANDOFF.md
```

Extract:
- `current_phase` — what macro stage the project is in
- `active_milestone` — which milestone, progress (X/Y tasks)
- `active_sprint` — which sprint, progress, type
- `blockers` — anything preventing progress
- `things_not_to_redo` — decisions that are settled
- `last_session` — what happened last time

### Step 2: Present Status

Use this format:
```
Session [N+1]. Phase: [phase].
Milestone [M-name]: [X/Y] tasks complete.
Current sprint: [sprint name] ([type]) — [X/Y] tasks done.
Last session: [one-line summary].

Priorities:
1. [Top priority from HANDOFF.md]
2. [Second priority]
3. [Third priority]

Blockers: [none | list]
```

### Step 3: Update Kanban
Update KANBAN.md (data layer) FIRST, then render board.html (presentation layer).

**KANBAN.md** (`.project/KANBAN.md`):
If it exists, read it as the authority. Compare against `state.json`, `milestones.md`, `execution-plan.md`, `backlog.md`. Apply ONLY changes justified by diffs. Preserve all card text that hasn't changed. If nothing changed, skip.
If it doesn't exist, create it from the template in `doc-templates.md`.

**board.html** (`.project/mocks/board.html`):
Render from KANBAN.md using the HTML template. If `.project/mocks/kanban-template.html` exists (user's custom template), use that. Otherwise use `./references/kanban-template.html` (default). Do NOT use visual-explainer for the board.

Open in browser.

### Step 4: Check Proactive Triggers
- Are there backlog items related to the current sprint area? → Surface them
- Are any docs stale (>5 sessions since update in an active area)? → Flag them
- Is the roadmap drifting (behind timeline)? → Report drift
- Does the execution plan need adjustment? → Suggest re-scoping
- Are there unresolved blockers from last session? → Highlight them

### Step 5: Increment Session
Update `state.json`:
- Increment `session_count`
- Begin working session

## Mid-Session Checkpoint Protocol

### When to Trigger
- After ~60% of estimated context capacity: offer a checkpoint
- After ~80% of estimated context capacity: recommend wrap-up
- After completing a significant chunk of work (e.g., a major doc rewrite)
- When the conversation has been going for a long time with many file reads

### Checkpoint Prompt
At ~60%:
```
"We've covered significant ground this session. Want me to checkpoint with session notes
so nothing gets lost? We can keep working after."
```

At ~80%:
```
"I recommend wrapping up soon to ensure all progress is captured. Should I start
the wrap-up process, or is there one more thing to finish?"
```

### Checkpoint Process (if user agrees)
1. Save partial session notes to `.project/sessions/` with `-checkpoint` suffix
2. Update `state.json` with current progress
3. Continue working (do NOT regenerate HANDOFF.md — that's only at session end)

### Context Estimation Heuristics
These are rough signals, not exact measurements:
- Many files read (>20 files) → context is filling
- Long conversation (>30 turns) → context is filling
- Multiple large doc generations → context is filling
- Complex multi-file edits → context is filling

## Session End Protocol

Execute when `/ship-wrap` is invoked or when proactively wrapping up.

### Step 1: Enumerate Changes
Compile a list of everything that happened this session:
- Tasks completed (with task IDs from milestones.md)
- Documents created or updated (with version numbers)
- Decisions made (with ADR numbers if applicable)
- Blockers encountered or resolved
- Roadmap or execution plan changes
- Backlog items added, promoted, or removed

### Step 2: Generate Session Notes
Write to `.project/sessions/<slug>-sprint-<N>-session-<NN>.md`

Format:
```markdown
# Session [NN] — Sprint [N]: [Sprint Name]

**Date:** [YYYY-MM-DD]
**Phase:** [phase]
**Duration:** [estimated — short/medium/long]

## Accomplished
- [Quantifiable accomplishment with references]
- [Completed T-NNN: task name]
- [Created docs/prd.md v2]

## Decisions Made
| Decision | ADR | Rationale |
|----------|-----|-----------|
| [Decision] | [ADR-NNN] | [Brief why] |

## Docs Changed
| Document | Change | Version |
|----------|--------|---------|
| [path] | [created/updated] | [N] |

## Things NOT to Redo
- [Decision or work that is finalized]

## Blockers
- [New blocker] — [impact]
- [Resolved blocker] — [how resolved]

## Next Priorities
1. [Most important for next session]
2. [Second]
3. [Third]

## Notes
[Any additional context, observations, or concerns]
```

### Step 3: Regenerate HANDOFF.md
COMPLETELY REWRITE `.project/sessions/HANDOFF.md`. NEVER append to the existing file.

Read the template in `doc-templates.md` for the HANDOFF.md format. The handoff MUST contain:
- Last session number and date
- Current phase, milestone progress, sprint progress
- What happened last session (3-5 bullets)
- Current state (working, in progress, blocked, changed)
- Decisions made (with ADR references)
- Things NOT to redo (critical for preventing regression)
- Priorities for next session (ordered)
- Open questions
- Files changed

### Step 4: Archive Changed Docs
If any document had a major version change (not just minor edits):
- Archive old version: `.project/archive/<docname>_v<N>_YYYY-MM-DD.md`
- Write new version to the canonical location
- Update `docs_status` in `state.json`

### Step 5: Update state.json
- Update `last_session` with number, date, slug, summary
- Update `active_milestone` progress
- Update `active_sprint` progress and `actual_sessions`
- Update `docs_status` for any changed docs
- Curate `things_not_to_redo` (add new, remove irrelevant)
- Update `blockers` (add new, remove resolved)
- Update `backlog_stats` if backlogs changed

### Step 6: Adjust Execution Plan
- Update current sprint progress in `execution-plan.md`
- If sprint is complete: advance `active_sprint` to next sprint
- If velocity differs from estimate: re-scope future sprint estimates
- Note any parallelization opportunities discovered during the session
- If scope changed: re-chunk remaining sprints

### Step 7: Provide Next-Session Guidance
Print:
```
Session wrapped. Next sprint: [Sprint N] — "[Sprint Name]"

To resume:
  claude  (SessionStart hook will auto-load context)
  or: /ship-status
```

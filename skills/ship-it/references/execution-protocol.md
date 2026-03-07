# Execution Protocol — Sprint Chunking & Build Planning

This protocol governs how the roadmap is broken into session-sized sprints, how work is parallelized, and how the execution plan adapts to actual velocity.

## Core Concept

The **roadmap** is strategic: milestones, phases, "what and when."
The **execution plan** is operational: sprints, tasks, "how we actually build it."

When the roadmap changes, the execution plan is automatically re-chunked.

## Sprint Sizing

### What Fits in One Session?

A session-sized sprint should be completable in 1-3 Claude Code sessions. Size by:

| Factor | Small (1 session) | Medium (2 sessions) | Large (3 sessions) |
|--------|-------------------|---------------------|---------------------|
| Files touched | 1-5 | 5-15 | 15-30 |
| Complexity | Single concern | Multiple related concerns | Cross-cutting changes |
| Dependencies | None or internal only | 1-2 external | Multiple external |
| New patterns | Uses existing patterns | Introduces 1 new pattern | Introduces multiple patterns |
| Testing | Unit tests only | Unit + integration | Unit + integration + e2e |
| Doc changes | Minor updates | New doc section | New doc or major rewrite |

### Sizing Heuristics

1. **Count the files** — if a sprint touches >30 files, it's too big. Split it.
2. **Count the concerns** — if a sprint addresses >3 unrelated concerns, split by concern.
3. **Check the dependency chain** — if task A blocks B blocks C blocks D, that's a 3-session sprint minimum.
4. **Estimate context load** — will this sprint require reading many existing files to understand context? If yes, account for that context cost.
5. **Consider debugging time** — integration work and new patterns always take longer than expected. Add 50% buffer.

### Sprint Size Labels

Map to T-shirt sizes for quick reference:
- **S** (Small): 1 session, low risk, well-understood
- **M** (Medium): 1-2 sessions, moderate complexity
- **L** (Large): 2-3 sessions, significant complexity or dependencies
- **XL** (Extra Large): 3+ sessions — consider splitting

## Sprint Types

### Feature Sprint
- **Purpose:** Build new functionality
- **Pattern:** Design → implement → test → document
- **Acceptance:** Feature works end-to-end, tests pass, docs updated
- **Common tasks:** Create components, add endpoints, write tests, update UX spec

### Refactor Sprint
- **Purpose:** Improve code quality without changing behavior
- **Pattern:** Identify targets → refactor → verify behavior unchanged → update docs
- **Acceptance:** All existing tests pass, code quality improved, no behavior changes
- **Common tasks:** Extract modules, rename for clarity, reduce duplication, improve types

### Integration Sprint
- **Purpose:** Connect separate components or integrate external services
- **Pattern:** Define interface → implement adapter → integration test → error handling
- **Acceptance:** Components communicate correctly, error cases handled, integration tests pass
- **Common tasks:** API integration, database connection, service-to-service communication

### Hardening Sprint
- **Purpose:** Fix bugs, add tests, improve reliability
- **Pattern:** Identify weaknesses → prioritize by severity → fix → verify
- **Acceptance:** Known bugs fixed, test coverage improved, tech debt reduced
- **Common tasks:** Fix bugs from backlog, add missing tests, improve error handling, update deps

## Parallelization Patterns

### Pattern 1: Independent Feature Branches (Worktree-Based)
**When:** Two features touch different areas of the codebase with no shared dependencies.
**How:** Develop in separate git worktrees simultaneously. Merge sequentially.
**Example:** "Build the auth module" and "Build the notification system" can run in parallel if they don't share models.
**Risk:** Merge conflicts if shared files are touched. Mitigate by defining clear boundaries.

### Pattern 2: Frontend/Backend Parallel Tracks
**When:** API contract is defined and both sides can develop against it.
**How:** Backend implements the API; frontend builds against mocks/stubs. Integration sprint follows.
**Prerequisite:** API spec must be agreed upon (see `api-spec.md`).
**Sprint structure:**
1. Sprint N: Define API contract (both tracks aligned)
2. Sprint N+1a: Backend implements API (one track)
3. Sprint N+1b: Frontend builds against API contract (parallel track)
4. Sprint N+2: Integration sprint (both tracks merge)

### Pattern 3: Test-Writing as Parallel Activity
**When:** Feature implementation is clear and tests can be written independently.
**How:** One track writes implementation, another writes tests. They converge when implementation is done.
**Prerequisite:** Acceptance criteria must be defined (from PRD or milestones.md).

### Pattern 4: Doc-Writing as Parallel Activity
**When:** A feature is being built and documentation can be drafted from specs.
**How:** Draft docs while implementation proceeds. Finalize after implementation is complete.
**Good for:** API docs, user guides, architecture docs.

### Pattern 5: Spike + Build
**When:** A technical question needs answering before the full implementation.
**How:** A short spike (research/prototype) sprint runs first, followed by the build sprint.
**Sprint structure:**
1. Sprint N: Spike — answer the question (0.5-1 session)
2. Sprint N+1: Build — implement the solution (1-3 sessions)

## Dependency Mapping

### Dependency Types

| Type | Description | Impact | Handling |
|------|------------|--------|----------|
| **Hard** | B literally cannot start without A's output | Sequential only | Put A first, no parallelization |
| **Soft** | B is easier with A done, but can start | Prefer sequential | Start B, but expect rework |
| **External** | Waiting on something outside the project | Blocker risk | Flag as blocker, plan workaround |
| **Knowledge** | B requires understanding gained from A | Sequential preferred | Can parallelize if knowledge is documented |

### Critical Path Identification

1. List all tasks with their dependencies
2. Calculate the longest dependency chain — this is the critical path
3. Any delay on the critical path delays the entire milestone
4. Optimize: can any critical-path task be split to allow parallelization?

### Dependency Notation in execution-plan.md
```
Sprint 3 — "API Endpoints"
  Dependencies: Sprint 2 (data model) MUST be complete
  Soft dependency: Sprint 1 (auth) SHOULD be complete but can mock
  Blocks: Sprint 5 (frontend integration)
```

## Velocity Tracking

### What to Track
After each session, record:
- Tasks completed (count)
- Sprint progress (X/Y)
- Estimated vs actual sessions for completed sprints
- Blockers encountered
- Unexpected work (not in the sprint plan)

### Velocity Calculation
```
velocity = total_tasks_completed / total_sessions
```

Use a rolling average of the last 3 sessions (or all sessions if <3).

### Adjustment Triggers
- **Velocity 50% below estimate for 2+ sessions:** Re-scope all future sprints with the new velocity
- **Velocity 50% above estimate:** Consider adding stretch goals or pulling in backlog items
- **Sprint taking 2x estimated sessions:** Stop and re-evaluate — is the scope right? Are there hidden dependencies?

### Adjustment Process
1. Calculate new velocity estimate
2. Re-estimate remaining sprints: `remaining_tasks / velocity = estimated_sessions`
3. If timeline impact: report to user ("At current velocity, milestone M is [N] sessions behind")
4. Propose options: re-scope milestone, accept delay, or increase sprint density (larger sprints)

## Replanning Triggers

### When to Re-Chunk the Execution Plan

| Trigger | Action |
|---------|--------|
| Roadmap change (new milestone, dropped milestone) | Re-chunk all affected sprints |
| Major scope change within a milestone | Re-chunk remaining sprints in that milestone |
| Blocked task on critical path | Re-sequence to work around the blocker |
| Velocity significantly different from estimate | Re-estimate all future sprint durations |
| New dependency discovered | Update dependency graph, potentially reorder sprints |
| Pivot detected | Archive current plan, regenerate from new roadmap |
| Sprint completed ahead of schedule | Pull next sprint forward, consider adding stretch goals |
| Sprint overflowing | Split remaining work into a continuation sprint |

### Re-Chunking Process
1. Save current execution plan state (for reference)
2. List remaining tasks from `milestones.md`
3. Update dependency graph
4. Re-chunk into sprints using sizing heuristics
5. Update `execution-plan.md`
6. Update `state.json` with new sprint info
7. Inform user: "I've re-chunked the execution plan. [Summary of changes]."

## Sprint Completion Checklist

Before marking a sprint complete:
- [ ] All sprint tasks marked "done" in `milestones.md`
- [ ] Acceptance criteria met for each task
- [ ] Tests passing
- [ ] Docs updated for any changed behavior
- [ ] No new blockers introduced
- [ ] Tech debt logged if shortcuts were taken
- [ ] Backlog updated if new work was discovered
- [ ] `execution-plan.md` updated with actual sessions and notes

After marking complete:
- Advance `active_sprint` in `state.json` to next sprint
- Update sprint history in `execution-plan.md`
- Check: does the next sprint's prerequisites hold?
- Surface: any exploration or backlog items relevant to the next sprint area

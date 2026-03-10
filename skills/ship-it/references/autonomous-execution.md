# Autonomous Execution Protocol

This protocol governs how `/ship-go` executes sprint tasks autonomously, integrates with superpowers for TDD/code-review/subagent execution, and falls back to direct execution when superpowers is unavailable.

## Overview

```
/ship-go
  1. Load sprint → read execution-plan.md for current sprint tasks
  2. Detect superpowers → try loading superpowers:writing-plans
  3. For each task:
     a. Check human gates (→ pause if gate hit)
     b. Build context packet from project docs
     c. Decompose → superpowers:writing-plans (or inline decomposition)
     d. Execute → superpowers:executing-plans (or direct execution)
     e. Update ship-it state (milestones, state.json, KANBAN.md)
  4. After each batch (3-5 tasks) → status checkpoint
  5. Sprint complete → auto-wrap
```

## Superpowers Detection

On first `/ship-go` invocation for a project:

1. Try: invoke `superpowers:writing-plans` skill
2. If available: set `execution_mode = "autonomous-superpowers"` in state.json
3. If NOT available:
   - Notify user: "Superpowers plugin not detected. It provides TDD enforcement, code review, and subagent execution for higher-quality autonomous work."
   - Offer: "Install with: `claude plugin install obra/superpowers`"
   - If user declines: set `execution_mode = "autonomous"` in state.json
   - Set `superpowers_prompted = true` in state.json (only ask once per project)
4. On subsequent invocations: check `execution_mode` in state.json, skip prompt

## Sprint Execution Loop

### Step 1: Load Sprint Context

```
Read .project/state.json → active_sprint
Read .project/roadmap/execution-plan.md → current sprint tasks
Read .project/roadmap/milestones.md → acceptance criteria for each task

Validate:
- Sprint exists and has tasks with status != "done"
- No hard blockers on remaining tasks
- If sprint is complete: advance to next sprint or report "all sprints done"
```

### Step 2: Task Sequencing

Order tasks by:
1. Dependencies (hard deps first)
2. Critical path priority
3. Size (smaller tasks first within same priority)

Skip tasks with unresolved hard dependencies. Flag them and continue with independent tasks.

### Step 3: Per-Task Execution

For each task in sequence:

#### 3a. Human Gate Check
Read the task description and acceptance criteria. Scan for gate triggers (see `human-gates.md`). If a gate is detected, PAUSE and present the gate to the user. Wait for resolution before proceeding with this task. Continue with other independent tasks if possible.

#### 3b. Build Context Packet
Assemble context for the task from project docs:

```
Task: [name from milestones.md]
Acceptance Criteria: [from milestones.md]
Architecture Context: [relevant section from architecture.md]
Tech Stack: [from PROJECT.md]
Relevant ADRs: [from decisions/ — only those affecting this task's area]
Constraints: [from state.json things_not_to_redo]
Dependencies: [from execution-plan.md — what this task builds on]
```

#### 3c. Decompose (with superpowers)
If `execution_mode = "autonomous-superpowers"`:

```
Invoke superpowers:writing-plans with:

  "Create an implementation plan for the following task:

  Feature: [task name]
  Goal: [acceptance criteria]
  Architecture: [relevant excerpt from architecture.md]
  Tech stack: [from PROJECT.md]

  Additional context:
  - [relevant ADRs]
  - [things_not_to_redo constraints]
  - [dependency outputs from prior tasks]

  Save the plan to .project/sessions/sprint-[N]-task-[ID]-plan.md"
```

Superpowers will decompose this into atomic 2-5 minute steps with exact file paths, code snippets, CLI commands, and TDD steps.

#### 3c-alt. Decompose (without superpowers)
If `execution_mode = "autonomous"`:

Decompose inline. For each task, create a simple plan:
1. Identify files to create or modify
2. Write failing test (if testable)
3. Implement minimal code to pass
4. Verify tests pass
5. Update any affected docs

This is less granular than superpowers but functional.

#### 3d. Execute (with superpowers)
If `execution_mode = "autonomous-superpowers"`:

Choose execution mode based on task attributes:
- Task size S/M + low risk → `superpowers:subagent-driven-development` (faster, fully autonomous)
- Task size L/XL + high risk or cross-cutting → `superpowers:executing-plans` (batch checkpoints)

The user can override this default via `superpowers_execution_mode` in state.json:
- `"executing-plans"` — always use batch execution with checkpoints
- `"subagent-driven-development"` — always use subagent dispatch
- `"auto"` (default) — skill chooses based on task attributes

```
Invoke the chosen skill:
  "Execute the plan at .project/sessions/sprint-[N]-task-[ID]-plan.md"
```

#### 3d-alt. Execute (without superpowers)
If `execution_mode = "autonomous"`:

Execute the inline plan directly:
1. Write test (if applicable)
2. Run test → verify it fails (RED)
3. Implement code
4. Run test → verify it passes (GREEN)
5. Refactor if needed
6. Commit at logical checkpoint

#### 3e. Post-Task State Update
After each task completes:

```
Update milestones.md → mark task as done
Update state.json:
  - active_sprint.completed_tasks += 1
  - active_milestone.completed_tasks += 1
Update KANBAN.md → move card from "In Progress" to "Done"
Log: "Task [ID] complete: [name]"
```

### Step 4: Batch Checkpoint

After every 3-5 completed tasks (or after a significant task), present:

```
Sprint Progress: [X/Y] tasks complete
Completed this batch:
  - [T-001] task name
  - [T-002] task name
  - [T-003] task name
Next up:
  - [T-004] task name
  - [T-005] task name
Human gates ahead: [none | list]

Continue? [Y/n]
```

If user says no or wants changes, pause and discuss. Resume with `/ship-go` when ready.

### Step 5: Sprint Completion

When all sprint tasks are done:

1. Run sprint completion checklist (see execution-protocol.md)
2. Execute auto-wrap:
   - Generate session notes
   - Regenerate HANDOFF.md
   - Archive changed docs
   - Update state.json (advance active_sprint to next)
   - Update KANBAN.md and render board.html
3. Report:
   ```
   Sprint [N] "[Name]" complete. [X] tasks done in [Y] sessions.

   Next sprint: [N+1] "[Name]" — [Z] tasks, estimated [W] sessions.
   Human gates in next sprint: [list or none]

   Continue to next sprint? [Y/n]
   ```
4. If user continues: loop back to Step 1 with the next sprint
5. If milestone complete: report milestone completion, check for next milestone

## Scope Override

Users can scope `/ship-go` with arguments:

- `/ship-go` — execute current sprint (default)
- `/ship-go task T-003` — execute only task T-003
- `/ship-go sprint 4` — jump to sprint 4 (skip intervening sprints)
- `/ship-go full-auto` — skip all non-critical human gates
- `/ship-go dry-run` — decompose tasks and show plans without executing

## Error Recovery

### Task Failure
If a task fails during execution:
1. Log the failure in session notes
2. Add to blockers in state.json if it blocks other tasks
3. Skip to next independent task
4. Report at next batch checkpoint: "Task [ID] failed: [reason]. Skipped to independent tasks."

### Superpowers Failure
If superpowers skill invocation fails mid-execution:
1. Fall back to direct execution for remaining tasks
2. Update execution_mode to "autonomous" in state.json
3. Report: "Superpowers skill unavailable. Continuing with direct execution."

### Context Limit
If context is filling up (~80% estimated capacity):
1. Trigger auto-wrap immediately
2. Report remaining tasks for next session
3. Do NOT attempt more tasks — save the context for a clean wrap

# Human Gates Protocol

Human gates are points during autonomous execution (`/ship-go`) where the system pauses and requires human input before proceeding. This protects against autonomous decisions that should involve the user.

## Gate Types

### 1. Architecture Decision
**Trigger:** Task requires choosing between approaches, involves trade-offs with no clear winner, or acceptance criteria say "decide on..."
**Detection keywords:** "choose", "decide", "which approach", "alternative", "trade-off", "evaluate options", "TBD"
**Action:** Pause execution. Auto-invoke `/ship-decide` flow. Present options with trade-offs. Capture decision as ADR.
**Resume:** User makes decision. ADR is written. Execution resumes with the chosen approach.

### 2. Deployment
**Trigger:** Task involves deploying to any environment, modifying CI/CD, changing production config, or release steps.
**Detection keywords:** "deploy", "release", "production", "staging", "ci/cd", "pipeline", "publish", "push to"
**Action:** Pause execution. Present deployment instructions. List what was built and what needs deploying.
**Resume:** User confirms deployment is complete (or defers it).

### 3. Human Testing
**Trigger:** Task has acceptance criteria requiring visual verification, UX review, or manual interaction testing.
**Detection keywords:** "verify visually", "UX review", "manual test", "user acceptance", "look and feel", "try it out", "check the flow"
**Action:** Pause execution. Provide a test checklist derived from acceptance criteria. Include URLs/commands to access the feature.
**Resume:** User reports pass/fail. If fail, log issues and create follow-up tasks.

### 4. External Dependency
**Trigger:** Task requires API keys, credentials, third-party service access, or input from external stakeholders.
**Detection keywords:** "API key", "credential", "secret", "third-party", "external service", "waiting on", "requires access"
**Action:** Pause this task. Explain what's needed and from whom. Continue with other independent tasks if available.
**Resume:** User provides the dependency. Blocked task resumes.

### 5. Security Sensitive
**Trigger:** Task involves authentication, authorization, encryption, secrets management, or permission models.
**Detection keywords:** "auth", "encryption", "secret", "permission", "token", "credential", "access control", "RBAC", "OAuth"
**Action:** Pause execution. Present the proposed security approach. Highlight risks and assumptions.
**Resume:** User approves the approach (or modifies it). If modified, update relevant docs before continuing.

### 6. Scope Ambiguity
**Trigger:** Task has missing acceptance criteria, conflicting requirements, or is marked [TBD].
**Detection keywords:** "[TBD]", "unclear", missing acceptance criteria, contradictory requirements
**Action:** Pause execution. Ask specific clarifying questions. Show downstream impact of the ambiguity.
**Resume:** User clarifies. Update milestones.md with clarified acceptance criteria. Execution resumes.

## Detection Protocol

Before executing each task, scan in this order:

```
1. Read task description from milestones.md
2. Read acceptance criteria
3. Read relevant section of execution-plan.md (notes, dependencies)
4. Scan for gate trigger keywords (case-insensitive)
5. Check for structural signals:
   - Acceptance criteria is empty or contains [TBD] → Scope Ambiguity
   - Task is in the "deployment" section of milestones → Deployment
   - Task references external services not yet configured → External Dependency
6. If gate detected:
   - Log gate to state.json human_gates_log
   - Present gate to user
   - Wait for resolution
7. If no gate: proceed with execution
```

## Gate Notification Format

When a gate is triggered, present:

```
HUMAN GATE: [Type]
Task: [T-NNN] [task name]
Sprint: [N] "[sprint name]"

Issue: [clear description of what needs human input]
Impact: [what's blocked, downstream effects]

[Type-specific content:]

For Architecture Decision:
  Option A: [description] — pros: [...], cons: [...]
  Option B: [description] — pros: [...], cons: [...]
  Recommendation: [if one is clearly better, say so]

For Deployment:
  What to deploy: [list of changes]
  How to deploy: [commands or instructions]
  Verify: [how to confirm it worked]

For Human Testing:
  Test checklist:
  - [ ] [test step 1]
  - [ ] [test step 2]
  Access: [URL or command to reach the feature]

For External Dependency:
  Need: [what's required]
  From: [who provides it]
  Workaround: [if any tasks can proceed without it]

For Security Sensitive:
  Proposed approach: [description]
  Assumptions: [what we're assuming about threat model]
  Risks: [known risks]

For Scope Ambiguity:
  Question: [specific question]
  Why it matters: [downstream impact]
  Options: [if applicable]
```

## Gate Resolution

When the user responds to a gate:

```
1. Record resolution in state.json human_gates_log:
   - status: "resolved"
   - resolution: [summary of user's decision]
   - session: [current session number]

2. If the resolution changes requirements:
   - Update milestones.md acceptance criteria
   - Update execution-plan.md if sprint scope changed
   - If ADR was created, update recent_decisions in state.json

3. Resume execution from the paused task
```

## Pre-Approval (Skip Gates)

Users can pre-approve gate types when invoking `/ship-go`:

| Argument | Effect |
|---|---|
| `/ship-go` | All gates active (default) |
| `/ship-go full-auto` | Skip all gates except Architecture Decision |
| `/ship-go skip-deploy` | Skip deployment gates |
| `/ship-go skip-testing` | Skip human testing gates |

Pre-approval is recorded in `state.json.current_go_session.skip_gates` and applies only to the current `/ship-go` invocation.

Gates that are skipped are still logged with status `"skipped"` in human_gates_log for audit.

**Never skip:** Architecture Decision gates are never skippable. Autonomous code should not make architectural choices without human input.

## Gate Statistics

At sprint completion, report gate summary:

```
Human gates this sprint:
  - [N] architecture decisions ([N] resolved, [N] pending)
  - [N] deployment steps ([N] completed)
  - [N] testing checkpoints ([N] passed, [N] failed)
  - [N] external dependencies ([N] resolved, [N] still blocked)
  - [N] security reviews ([N] approved)
  - [N] scope clarifications ([N] resolved)
```

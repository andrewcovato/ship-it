# Ship It

A Claude Code plugin that acts as your CTO/CPO co-pilot for multi-session software project management. Co-create a solid PRD and execution plan, then push go for autonomous sprint execution.

## Core Principles

1. **Seamless session switching.** Minimal friction to pick up and go. State is structured JSON with tiered loading — session start costs ~100 lines of context.
2. **Large-scale project management.** Break ambitious projects into session-sized chunks with deterministic traceability from phases to tasks.
3. **Automated execution.** Lean into superpowers for robust TDD and code review. Human involvement only at genuine decision points.

## The Operating Model

**You are the CEO.** You own the vision, make judgment calls, and care about details.

**Claude is the CTO/CPO.** It owns the build process, manages all documentation, proactively challenges decisions, flags downstream implications, and keeps the project moving across sessions.

Claude never waits to be asked. When a conversation reveals a new requirement, the PRD gets updated. When an architecture decision is made, an ADR is created automatically. When scope creeps, Claude flags it.

## Quick Start

### Start a Project

```
/ship-init
```

Works for both new and existing projects. Claude auto-detects the environment:
- **Empty directory** -- Drives a structured discovery conversation, then generates a complete doc suite, plan, and architecture diagram.
- **Existing codebase** -- The "new CTO joins mid-flight" flow. Audits the codebase, archives existing PM artifacts, interviews you, runs a gap analysis, reorganizes everything, and builds a plan from reality.
- **Incomplete `.project/`** -- Repair mode. Audits what exists, generates only what's missing without overwriting.

### Push Go

```
/ship-go
```

Autonomously executes the current sprint. For each task, Claude:
1. Checks for human gates (decisions, deploys, testing)
2. Builds a context packet from project state
3. Decomposes the task into atomic steps (via [superpowers](https://github.com/obra/superpowers) if installed)
4. Executes with TDD and code review
5. Updates state.json and regenerates derived views (kanban, plan)

You only get pulled in when a human gate is hit.

**Scope options:**
- `/ship-go` -- execute current sprint
- `/ship-go task T-003` -- single task only
- `/ship-go full-auto` -- skip non-critical gates
- `/ship-go dry-run` -- show plans without executing

### Resuming Work

Just open Claude Code in the project directory. The SessionStart hook detects `.project/` and auto-loads context via tiered loading. No command needed.

### Everything Else

No commands needed. Just ask naturally:
- "Show me the plan" / "What's in the next sprint?" -- generates visual sprint timeline
- "Show the roadmap" -- generates visual roadmap timeline (summary view of plan)
- "Show the board" -- renders kanban board HTML
- "Add X to the backlog"
- "Wrap up" / "End session"

Decisions are captured automatically when detected in conversation -- no command needed.

## Commands

| Command | Purpose |
|---------|---------|
| `/ship-init` | Start or adopt a project (auto-detects mode) |
| `/ship-go` | Autonomous sprint execution with human gates |

That's it. Two commands. Everything else happens automatically or via natural language.

## Architecture: Single Source of Truth

`state.json` is the single source of truth for all project state. Everything else is a derived view:

```
state.json (THE authority)
├── phases[]        → id, status
├── milestones[]    → id, status, phase_id
├── sprints[]       → id, status, milestone_id
├── tasks[]         → id, status, sprint_id, acceptance_criteria
├── backlog[]       → id, tier (main|exploration|tech-debt)
├── blockers[]      → id, task_id, description
└── decisions[]     → id, summary, timestamp

        ↓ generates ↓

plan.md          → human-readable plan hierarchy
KANBAN.md        → board data (columns + cards)
board.html       → visual kanban board
HANDOFF.md       → session context for next session
```

### Tiered Loading

Session start reads only what's needed (~100 lines total):
- **Tier 0:** `current`, `active_sprint`, `last_session`, `blockers` from state.json
- **Tier 1:** `HANDOFF.md` for session narrative

Full plan hierarchy loaded on-demand when executing tasks or pivoting.

### Deterministic Traceability

Every task traces upward: `T-001` → `S-001` → `M-001` → `P-1`. Progress rolls up deterministically. No manual sync between files.

## Superpowers Integration

Ship-it integrates with the [superpowers](https://github.com/obra/superpowers) plugin for execution quality. If installed, `/ship-go` uses:
- `superpowers:writing-plans` to decompose tasks into atomic 2-5 minute steps
- `superpowers:executing-plans` or `subagent-driven-development` for TDD execution
- Two-stage code review (spec compliance + code quality)

If superpowers is not installed, ship-it offers to install it on first `/ship-go`, then falls back to direct execution if declined.

## Human Gates

During autonomous execution, certain tasks pause for human input:

| Gate | When | What Happens |
|------|------|--------------|
| Architecture Decision | Task requires choosing between approaches | Pauses, presents options, captures ADR on resolution |
| Deployment | Task involves deploy/release | Pauses with instructions |
| Human Testing | Acceptance criteria need visual verification | Pauses with test checklist |
| External Dependency | Task needs credentials or external access | Pauses; continues other tasks |
| Security Sensitive | Task involves auth, encryption, secrets | Pauses for approach review |
| Scope Ambiguity | Missing or conflicting requirements | Pauses with clarifying questions |

Architecture Decision gates are never skippable. Use `/ship-go full-auto` to skip others.

## What Gets Generated

### Documentation Suite

| Document | Owns |
|----------|------|
| `PROJECT.md` | Identity, elevator pitch, tech stack |
| `prd.md` | What & Why (requirements, acceptance criteria) |
| `technical-spec.md` | How: implementation (algorithms, libraries) |
| `architecture.md` | How: structure (components, data flow) |
| `api-spec.md` | Interface contracts (endpoints, schemas) |
| `data-model.md` | Schema, entities, relationships |
| `ux-spec.md` | User flows, wireframe descriptions |
| `plan.md` | Derived view of plan hierarchy (phases → milestones → sprints → tasks) |

### Project Directory

```
.project/
  PROJECT.md
  state.json          # Single source of truth
  plan.md             # Derived: human-readable plan
  KANBAN.md           # Derived: board data
  docs/               # PRD, tech spec, architecture, API, data model, UX
  decisions/          # Architecture Decision Records (auto-captured)
  sessions/           # HANDOFF.md + per-session logs
  archive/            # Versioned doc snapshots
  mocks/              # Visual outputs (diagrams, kanban board)
```

## Installation

```bash
claude plugin install andrewcovato/ship-it
```

### Recommended

Also install [superpowers](https://github.com/obra/superpowers) for TDD, code review, and subagent execution:

```bash
claude plugin install obra/superpowers
```

### Plugin Structure

```
ship-it/
  .claude-plugin/plugin.json
  CLAUDE.md
  skills/ship-it/
    SKILL.md                    # Core skill definition
    references/                 # Reference docs
  commands/
    ship-init.md                # Start or adopt a project
    ship-go.md                  # Autonomous sprint execution
  hooks/hooks.json              # SessionStart hook
  hooks-handlers/session-start.sh
```

## Design Decisions

- **state.json is the single source of truth.** All other project files are derived views. No sync bugs.
- **Tiered loading.** Session start costs ~100 lines. Full plan loaded on-demand.
- **JSON for state, Markdown for views.** Models handle structured JSON more reliably.
- **HANDOFF.md is regenerated, never appended.** Prevents stale context accumulation.
- **Decisions are proactive.** Detected in conversation and captured automatically. No command needed.
- **Session-sized sprints, not time-boxed.** Scoped by complexity and dependency depth.
- **Superpowers is optional.** Ship-it works standalone but is better with superpowers for execution quality.
- **Human gates are non-negotiable for architecture decisions.** Autonomous code should not make architectural choices.

## License

MIT License. See [LICENSE](LICENSE) for details.

# Ship It

A Claude Code plugin that acts as your CTO/CPO co-pilot for multi-session software project management. Co-create a solid PRD and execution plan, then push go for autonomous sprint execution.

## The Operating Model

**You are the CEO.** You own the vision, make judgment calls, and care about details.

**Claude is the CTO/CPO.** It owns the build process, manages all documentation, proactively challenges decisions, flags downstream implications, and keeps the project moving across sessions.

Claude never waits to be asked. When a conversation reveals a new requirement, the PRD gets updated. When an architecture decision is made, an ADR is created. When scope creeps, Claude flags it.

## Quick Start

### Start a Project

```
/ship-init
```

Works for both new and existing projects. Claude auto-detects the environment:
- **Empty directory** -- Drives a structured discovery conversation, then generates a complete doc suite, roadmap, execution plan, and architecture diagram.
- **Existing codebase** -- The "new CTO joins mid-flight" flow. Audits the codebase, archives existing PM artifacts, interviews you, runs a gap analysis, reorganizes everything, and builds an execution plan from reality.
- **Incomplete `.project/`** -- Repair mode. Audits what exists, generates only what's missing without overwriting.

### Push Go

```
/ship-go
```

Autonomously executes the current sprint. For each task, Claude:
1. Checks for human gates (decisions, deploys, testing)
2. Builds a context packet from your project docs
3. Decomposes the task into atomic steps (via [superpowers](https://github.com/obra/superpowers) if installed)
4. Executes with TDD and code review
5. Updates project state, milestones, and kanban board

You only get pulled in when a human gate is hit.

**Scope options:**
- `/ship-go` -- execute current sprint
- `/ship-go task T-003` -- single task only
- `/ship-go full-auto` -- skip non-critical gates
- `/ship-go dry-run` -- show plans without executing

### Capture a Decision

```
/ship-decide "Use JWT for auth instead of sessions"
```

Creates an Architecture Decision Record and auto-checks implications on backlog, architecture, and execution plan. Also auto-invoked by `/ship-go` when it hits a decision gate.

### Resuming Work

Just open Claude Code in the project directory. The SessionStart hook detects `.project/` and auto-loads context. No command needed.

### Everything Else

No commands needed. Just ask naturally:
- "Show me the plan" / "What's in the next sprint?"
- "Show the roadmap" / "Update the roadmap"
- "Show the board"
- "Add X to the backlog"
- "Wrap up" / "End session"

## Commands

| Command | Purpose |
|---------|---------|
| `/ship-init` | Start or adopt a project (auto-detects mode) |
| `/ship-go` | Autonomous sprint execution with human gates |
| `/ship-decide` | Capture an Architecture Decision Record |

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
| Architecture Decision | Task requires choosing between approaches | Auto-invokes `/ship-decide` |
| Deployment | Task involves deploy/release | Pauses with instructions |
| Human Testing | Acceptance criteria need visual verification | Pauses with test checklist |
| External Dependency | Task needs credentials or external access | Pauses; continues other tasks |
| Security Sensitive | Task involves auth, encryption, secrets | Pauses for approach review |
| Scope Ambiguity | Missing or conflicting requirements | Pauses with clarifying questions |

Architecture Decision gates are never skippable. Use `/ship-go full-auto` to skip others.

## What Gets Generated

### Documentation Suite (MECE)

| Document | Owns |
|----------|------|
| `PROJECT.md` | Identity, elevator pitch, tech stack |
| `prd.md` | What & Why (requirements, acceptance criteria) |
| `technical-spec.md` | How: implementation (algorithms, libraries) |
| `architecture.md` | How: structure (components, data flow) |
| `api-spec.md` | Interface contracts (endpoints, schemas) |
| `data-model.md` | Schema, entities, relationships |
| `ux-spec.md` | User flows, wireframe descriptions |
| `roadmap.md` | Strategic roadmap: phases, milestones |
| `milestones.md` | Tasks, subtasks, estimates, acceptance criteria |
| `execution-plan.md` | Session-sized sprints with parallelization |

### Project Directory

```
.project/
  PROJECT.md
  state.json
  KANBAN.md
  docs/
  roadmap/
  backlog/          # Three tiers: exploration, tech-debt, main
  decisions/        # Architecture Decision Records
  sessions/         # HANDOFF.md + per-session logs
  archive/          # Versioned doc snapshots
  mocks/            # Visual outputs (diagrams, kanban board)
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
  skills/ship-it/
    SKILL.md                    # Core skill definition
    references/                 # 11 reference docs
  commands/
    ship-init.md                # Start or adopt a project
    ship-go.md                  # Autonomous sprint execution
    ship-decide.md              # Capture decisions
  hooks/hooks.json              # SessionStart hook
  hooks-handlers/session-start.sh
```

## Design Decisions

- **JSON for state, Markdown for docs.** Models handle structured JSON more reliably for machine-readable data.
- **HANDOFF.md is regenerated, never appended.** Prevents stale context accumulation.
- **Session-sized sprints, not time-boxed.** Scoped by complexity and dependency depth.
- **Superpowers is optional.** Ship-it works standalone but is better with superpowers for execution quality.
- **Human gates are non-negotiable for architecture decisions.** Autonomous code should not make architectural choices.
- **Docs are memory.** Conversation is ephemeral. The doc suite persists.

## License

MIT License. See [LICENSE](LICENSE) for details.

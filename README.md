# Ship It

A Claude Code skill that acts as your CTO/CPO co-pilot for multi-session software project management. You bring the vision; it owns the build process.

## The Operating Model

**You are the CEO.** You own the vision, make judgment calls, and care about details.

**Claude is the CTO/CPO.** It owns the build process, manages all documentation, proactively challenges decisions, flags downstream implications, and keeps the project moving across sessions.

Claude never waits to be asked. When a conversation reveals a new requirement, the PRD gets updated. When an architecture decision is made, an ADR is created. When scope creeps, Claude flags it. When the timeline slips, Claude reports it with options.

## Quick Start

### New Project

```
/ship-init
```

Claude drives a structured discovery conversation (vision, product shape, tech landscape, architecture, sequencing), then generates a complete documentation suite, roadmap, execution plan, and architecture diagram.

### Existing Project

```
/ship-adopt
```

The "new CTO joins mid-flight" flow. Claude audits the codebase, archives existing PM artifacts as a safety net, interviews you about the current state, runs a gap analysis against the doc suite, reorganizes everything into the standard structure, and builds an execution plan from reality.

### Resuming Work

Just open Claude Code in the project directory. The SessionStart hook detects the `.project/` directory and auto-loads context. You can also run:

```
/ship-status
```

Claude presents your current session number, phase, milestone progress, sprint status, priorities, and generates a kanban board.

### Ending a Session

```
/ship-wrap
```

Generates session notes, regenerates the handoff document, updates project state, adjusts the execution plan based on velocity, and tells you what to work on next.

## Commands

| Command | Purpose |
|---------|---------|
| `/ship-init` | Initialize a new managed project |
| `/ship-adopt` | Adopt an existing in-progress project |
| `/ship-status` | Resume a session or check status |
| `/ship-plan` | View or update the execution plan (sprints, parallelization) |
| `/ship-roadmap` | View or update the strategic roadmap (phases, milestones) |
| `/ship-decide` | Capture an Architecture Decision Record |
| `/ship-wrap` | End session with full handoff |
| `/ship-backlog` | View and manage the three-tier backlog |
| `/ship-board` | Generate or refresh the project kanban board |

## What Gets Generated

### Documentation Suite (MECE)

Every document has strict ownership boundaries and is written to be droppable into any coding agent with zero context.

| Document | Owns |
|----------|------|
| `PROJECT.md` | Identity, elevator pitch, tech stack, current phase |
| `prd.md` | What & Why (requirements, acceptance criteria) |
| `technical-spec.md` | How: implementation (algorithms, libraries) |
| `architecture.md` | How: structure (components, data flow, deployment) |
| `api-spec.md` | Interface contracts (endpoints, schemas) |
| `data-model.md` | Schema, entities, relationships, migrations |
| `ux-spec.md` | User flows, wireframe descriptions, accessibility |
| `roadmap.md` | Strategic roadmap: phases, milestones |
| `milestones.md` | Tasks, subtasks, estimates, acceptance criteria |
| `execution-plan.md` | Session-sized sprints with parallelization |

### Project Directory

```
.project/
  PROJECT.md
  state.json
  docs/
    prd.md
    technical-spec.md
    architecture.md
    api-spec.md
    data-model.md
    ux-spec.md
  roadmap/
    roadmap.md
    milestones.md
    execution-plan.md
  backlog/
    backlog.md            # Spec'd but unscheduled work
    exploration.md        # Ideas not yet spec'd
    tech-debt.md          # Technical shortcuts and fragility
  decisions/
    adr-001-<title>.md    # Architecture Decision Records
  sessions/
    HANDOFF.md            # Briefing for the next session (regenerated each time)
    <session-logs>.md     # Per-session logs (immutable)
  archive/                # Versioned doc snapshots at pivots
  mocks/                  # Visual outputs (architecture diagrams, kanban board)
```

## Key Concepts

### Session Continuity

Session state is preserved through three mechanisms:

1. **`state.json`** -- Machine-readable project state (phase, milestone progress, sprint status, blockers, decisions, backlog counts). Updated after every significant action.

2. **`HANDOFF.md`** -- A complete briefing for the next session. Regenerated from scratch at every session end (never appended, which prevents stale info from accumulating).

3. **SessionStart hook** -- When Claude Code starts in a directory with `.project/`, context is automatically loaded. No manual action needed.

### Execution Planning

The roadmap is strategic (milestones, phases, "what and when"). The execution plan is operational (sprints, tasks, "how we actually build it").

Sprints are session-sized, not time-boxed. Each sprint defines scope, dependencies, parallelization opportunities, acceptance criteria, and an estimated session count. Claude adjusts sprint sizes based on actual velocity.

Four sprint types: feature, refactor, integration, and hardening.

### Three-Tier Backlog

- **Exploration** -- Ideas discussed but not spec'd. "Maybe someday" features.
- **Tech Debt** -- Shortcuts, fragility, missing tests, outdated dependencies.
- **Main Backlog** -- Spec'd work with acceptance criteria, ready to schedule.

Claude surfaces backlog items when the context is right (working on related code, completing a sprint, tech debt accumulating).

### Proactive Behaviors

Claude doesn't just track -- it intervenes:

- Flags pivots vs iterations and warns about downstream implications
- Detects scope creep and recommends re-prioritization
- Reports timeline pressure with velocity-based projections
- Surfaces risks (single points of failure, missing fallbacks)
- Captures decisions as ADRs when it hears "let's go with..."
- Warns when docs are stale in active development areas

### Visual Integration

Generates HTML visualizations via the visual-explainer skill:

- Architecture diagrams at project init
- ER diagrams for data models
- User flow diagrams for UX specs
- Timeline visualizations for roadmaps
- Kanban board at every session start

## Installation

### From GitHub (recommended)

```bash
claude /plugin install ship-it@andrewcovato
```

Or install directly from the repo:

```bash
claude /plugin install andrewcovato/ship-it
```

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI installed
- The [visual-explainer](https://github.com/anthropics/claude-code) skill (recommended -- used for architecture diagrams, kanban board, and other visuals)

### Plugin Structure

```
ship-it/
├── .claude-plugin/
│   └── plugin.json              # Plugin metadata
├── skills/
│   └── ship-it/
│       ├── SKILL.md             # Core skill definition
│       └── references/          # 8 reference docs (protocols, templates, schemas)
├── commands/
│   └── ship-*.md                # 9 slash commands
├── hooks/
│   └── hooks.json               # SessionStart hook registry
├── hooks-handlers/
│   └── session-start.sh         # Auto-detects .project/ directories
├── README.md
└── LICENSE
```

After installation, the skill auto-activates when it detects a `.project/` directory or when any `/ship-*` command is invoked.

## Design Decisions

- **JSON for state, Markdown for docs.** Models handle structured JSON more reliably than markdown for machine-readable data.
- **HANDOFF.md is regenerated, never appended.** Appended handoffs accumulate stale context and bloat over time.
- **Session-sized sprints, not time-boxed.** Sprints are scoped to fit within a Claude Code session, estimated by complexity and dependency depth.
- **Archive-first adoption.** When adopting an existing project, all original PM artifacts are archived before any reorganization. Source code is never touched.
- **Docs are memory.** Conversation is ephemeral. The doc suite is what persists. Every document is written to be self-contained and usable without conversational context.
- **ADRs are immutable.** Once written, an ADR is never edited. If a decision is superseded, a new ADR references the old one.

## License

MIT License. See [LICENSE](LICENSE) for details.

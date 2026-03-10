# Ship-It

A Claude Code plugin for multi-session software project management.

## Core Principles

1. **Seamless session switching.** Minimal friction to pick up and go. Session start should cost the fewest tokens possible while giving full orientation. State is structured (JSON), not prose. Derived views are regenerated, never maintained independently.

2. **Large-scale project management.** Break ambitious projects into session-sized chunks with deterministic traceability from phases → milestones → sprints → tasks. One source of truth for all state. Everything else is a derived view.

3. **Automated execution.** Lean into superpowers (or similar) for robust, efficient code generation with TDD and code review. Human involvement only at genuine decision points, deployments, and acceptance testing. Never interrupt for things the model can resolve autonomously.

## Design Constraints

- `state.json` is the single source of truth. All other project files (plan.md, KANBAN.md, board.html, HANDOFF.md) are derived views.
- JSON for machine state, Markdown for human-readable views. Never the reverse.
- HANDOFF.md is regenerated each session, never appended.
- Decisions (ADRs) are detected and captured proactively — no command required.
- Commands exist only for actions that need explicit intent: init, go. Views are natural language or automatic.

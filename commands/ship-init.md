---
description: Initialize a new managed project — CTO/CPO discovery, MECE doc suite, roadmap, execution plan, architecture diagram
---
Load the ship-it skill. This is a `/ship-init` invocation for a new greenfield project.

## Pre-flight Check
1. Check if `.project/` already exists in the working directory. If it does, warn the user: "A `.project/` directory already exists. This will overwrite it. Continue?" Wait for confirmation.
2. If no `.project/`, proceed.

## Initialization
1. Create the `.project/` directory structure:
   ```
   .project/
     docs/
     roadmap/
     backlog/
     decisions/
     sessions/
     archive/
     mocks/
   ```
2. Initialize `state.json` with phase: "discovery", session_count: 1. Read `./references/state-schema.md` for the full schema.

## Discovery
Read `./references/discovery-protocol.md` for the full question bank and pacing rules.

Drive a CTO/CPO-led discovery conversation. You are the CTO/CPO. The user is the CEO. Ask 2-3 questions at a time across 5 phases:
1. Vision & Elevator Pitch
2. Product Shape
3. Technical Landscape
4. Architecture
5. Sequencing

Push back constructively. Challenge assumptions. Identify risks early.

**Exit condition:** You can explain the product, list MVP features, describe the architecture, identify top risks, and sequence the build — without needing basics explained.

## Doc Generation
After discovery, read `./references/doc-templates.md` and generate docs in this order:
1. `PROJECT.md` — identity and elevator pitch
2. `docs/prd.md` — requirements from discovery
3. `docs/technical-spec.md` — implementation approach
4. `docs/architecture.md` — component structure
5. `roadmap/roadmap.md` — phased build plan
6. `roadmap/milestones.md` — milestone definitions with tasks and subtasks
7. `roadmap/execution-plan.md` — session-sized sprints with parallelization (read `./references/execution-protocol.md`)
8. Seed `backlog/exploration.md` with discussed-but-not-spec'd features
9. Generate architecture diagram via visual-explainer → `.project/mocks/mock-001-architecture.html`, open in browser
10. Create `.project/KANBAN.md` from `milestones.md`, `execution-plan.md`, and `backlog/exploration.md` — read `./references/doc-templates.md` for the KANBAN.md template format. Card text MUST be copied verbatim from source docs.
11. Update project CLAUDE.md with `## Project Management` pointer and `## Design Principles`

## Session Wrap-Up
Read `./references/session-protocol.md` and run the session end protocol:
- Generate session notes
- Generate HANDOFF.md
- Update state.json (phase → "planning")
- Render kanban board from KANBAN.md using the locked template → `.project/mocks/board.html`, open in browser
- Print next sprint name and resume command

$@

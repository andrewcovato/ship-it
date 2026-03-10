---
description: Start or adopt a project — co-create PRD, docs, roadmap, and execution plan
argument-hint: Optional project name or description
---
Load the ship-it skill. This is a `/ship-init` invocation.

Detect the environment and choose the right mode:

1. **No `.project/` and no source code** → Greenfield mode (Section 3 of the skill). Create `.project/`, run 5-phase discovery, generate full doc suite.

2. **No `.project/` but source code exists** (package manifests, src dirs, config files) → Adopt mode (Section 4 of the skill). Read `./references/adopt-protocol.md` for the 6-phase protocol.

3. **`.project/` exists but incomplete** → Repair mode. Audit the expected structure:
   ```
   .project/PROJECT.md, state.json, plan.md, KANBAN.md
   .project/docs/ (prd, technical-spec, architecture)
   .project/decisions/
   .project/sessions/HANDOFF.md
   ```
   Report: "Found .project/ with N/M expected files. Generating missing: [list]"
   For each missing file:
   - Docs (prd, tech-spec, architecture): run discovery questions for that doc only, then generate
   - Infrastructure (state.json, KANBAN.md): generate from existing docs
   - Plan hierarchy: build phases/milestones/sprints/tasks in state.json, generate plan.md as derived view
   Never overwrite existing files.

4. **`.project/` exists and complete** → Warn: "Project already initialized. Use `/ship-go` to execute or just ask me questions." Do not re-initialize.

After any mode completes, run session wrap-up per `./references/session-protocol.md`.

$@

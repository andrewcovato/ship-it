---
description: Adopt an existing in-progress project — audit codebase, archive original materials, reorganize docs, build execution plan
---
Load the ship-it skill. This is a `/ship-adopt` invocation — the "new CTO joins mid-flight" flow.

Read `./references/adopt-protocol.md` for the full 6-phase protocol.

## Phase 1: Codebase Audit
1. Create the `.project/` directory structure (same as init — with `.original_materials/` subdirectory)
2. Crawl the ENTIRE project directory — scan for PM artifacts, package manifests, config files, test suites, AI context files, docs directories
3. Analyze git history: recent trajectory, branching patterns, contributor activity
4. Architecture scan: entry points, modules, dependencies, API surface
5. Produce a Project Audit Report — present in conversation (do NOT write to file)

## Phase 2: Archive Original Materials
Before modifying ANYTHING:
1. Copy ALL identified PM artifacts to `.project/.original_materials/` preserving relative paths
2. Create `.original_materials/MANIFEST.md` listing every archived file with its original location
3. This is the safety net — everything can be recovered

## Phase 3: Stakeholder Interview
Present audit findings, then ask pointed questions (2-3 at a time) about:
- Current state, what works, what's broken
- Original vision vs current reality
- Pain points and tribal knowledge
- Document trustworthiness
- Priorities and deadlines

## Phase 4: Gap Analysis
Map existing artifacts to the MECE doc suite. Classify each as: exists+current, exists+stale, partial, or missing. Present gap analysis report.

## Phase 5: Reorganization & Doc Generation
1. Reorganize existing doc content into `.project/docs/` templates (read `./references/doc-templates.md`)
2. Generate missing docs (marked as draft)
3. Clean up remnant PM files from project tree (source code NEVER touched)
4. Build `state.json` from reality (read `./references/state-schema.md`)
5. Seed all three backlogs (read `./references/backlog-protocol.md`)
6. Generate execution plan (read `./references/execution-protocol.md`)
7. Generate architecture diagram via visual-explainer → `.project/mocks/mock-001-architecture.html`
8. Update CLAUDE.md

## Phase 6: Onboarding Summary
1. Present "state of the union" — what was archived, reorganized, generated, and flagged
2. Iterate on corrections with user
3. Generate kanban board → `.project/mocks/board.html`, open in browser
4. Run session wrap-up (read `./references/session-protocol.md`)

$@

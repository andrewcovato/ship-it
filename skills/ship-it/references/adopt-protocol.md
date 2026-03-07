# Adopt Protocol — "New CTO Joins Mid-Flight"

This protocol guides the `/ship-adopt` flow for adopting an existing, in-progress project into the ship-it management framework. Think of it as a new CTO/CPO joining a startup that already has code, maybe some docs, and definitely tribal knowledge that needs capturing.

## Guiding Principles

- **Archive first, reorganize second** — `.original_materials/` is the safety net. Nothing is lost.
- **Single source of truth** — After adoption, `.project/` is the ONLY place for PM artifacts.
- **Reorganize, don't rewrite intent** — Preserve existing decisions and context; reformat into standard templates.
- **Source code is never touched** — Only docs, plans, notes, and PM artifacts are reorganized. Source code, tests, configs, and build files stay exactly where they are.
- **Reality over assumptions** — Build state from what exists, not what was planned.

## Phase 1: Codebase Audit (Automated)

### Step 1.1: Create `.project/` Directory Structure
Create the full directory tree (same as `/ship-init`):
```
.project/
  docs/
  roadmap/
  backlog/
  decisions/
  sessions/
  archive/
  mocks/
  .original_materials/
```

### Step 1.2: Scan for Existing Artifacts
Crawl the ENTIRE project directory and subdirectories. Look for:

**Project identity files:**
- README.md, README.txt, README
- CHANGELOG.md, CHANGELOG
- CONTRIBUTING.md, CODE_OF_CONDUCT.md
- LICENSE, LICENSE.md

**Documentation directories:**
- `docs/`, `doc/`, `documentation/`, `wiki/`
- `design/`, `specs/`, `specifications/`
- `planning/`, `plans/`, `notes/`

**Package manifests:**
- `package.json`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`
- `pyproject.toml`, `setup.py`, `setup.cfg`, `requirements.txt`, `Pipfile`
- `Cargo.toml`, `Cargo.lock`
- `go.mod`, `go.sum`
- `Gemfile`, `Gemfile.lock`
- `build.gradle`, `pom.xml`
- `*.csproj`, `*.sln`

**Config files:**
- CI/CD: `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`, `.circleci/`
- Linters: `.eslintrc*`, `.prettierrc*`, `ruff.toml`, `.rubocop.yml`
- Docker: `Dockerfile*`, `docker-compose*.yml`
- Infrastructure: `terraform/`, `pulumi/`, `cdk/`, `serverless.yml`
- Environment: `.env.example`, `.env.template` (NEVER `.env` — skip actual env files)

**Test suites:**
- `tests/`, `test/`, `__tests__/`, `spec/`
- Test config files: `jest.config.*`, `pytest.ini`, `vitest.config.*`

**AI context files:**
- `CLAUDE.md`, `.claude/`, `.cursor/`, `.aider/`, `.github/copilot/`
- Any `*.md` or `*.txt` files that appear to contain project context for AI tools

**Project management artifacts** (the primary targets):
- Project plans, roadmaps, specs, PRDs
- Task lists, backlogs, TODO files
- Meeting notes, decision logs
- Design docs, architecture docs
- Any `.md`, `.txt`, `.doc`, `.pdf` that appears PM-related
- Notion exports, Figma links, Miro board references

### Step 1.3: Analyze Git History
Run these commands (adapt for the project's VCS):
```bash
git log --oneline -50                          # Recent trajectory
git log --all --oneline --graph -20            # Branching patterns
git shortlog -sn                               # Contributor activity
git log --since="3 months ago" --stat -20      # Recent file changes
```

Extract:
- How active is development? (commits per week)
- Is there a branching strategy? (main/develop, feature branches)
- Who's contributing? (solo dev, team, open source)
- What areas are most active recently?
- Are commit messages structured or chaotic?

### Step 1.4: Architecture Scan
Analyze:
- Entry points (main files, index files, route definitions)
- Directory structure and module organization
- Major dependencies and their versions
- API surface (routes, endpoints, exported functions/classes)
- Database schema (if visible in migrations, models, or schema files)
- Configuration patterns (env vars, config files)

### Step 1.5: Produce Project Audit Report
Generate a structured summary. Do NOT write this to a file — present it in conversation.

```
## Project Audit Report

**Project:** [name from manifest/README]
**Language/Stack:** [detected]
**Size:** [files, lines of code estimate]
**Git Activity:** [commits in last 3 months, contributors]

### Existing Artifacts Found
| File | Location | Type | Status Assessment |
|------|----------|------|-------------------|
| README.md | /README.md | Identity | [current/stale/minimal] |
| [file] | [path] | [type] | [assessment] |

### Architecture Summary
- Entry points: [list]
- Major modules: [list with brief descriptions]
- Dependencies: [key deps with versions]
- API surface: [endpoints/routes count]
- Test coverage: [present/absent, framework]

### Observations
- [Key observation about code quality]
- [Key observation about project maturity]
- [Key observation about documentation gaps]
- [Potential risks or concerns]
```

## Phase 2: Archive Original Materials

**Execute BEFORE modifying anything.** This is the safety net.

### Step 2.1: Create Archive Directory
```
.project/.original_materials/
```

### Step 2.2: Copy All PM Artifacts
Copy (not move) these to `.original_materials/`, preserving relative paths:
- All files identified as PM artifacts in Phase 1
- CLAUDE.md files (from any location)
- Any `docs/` directory contents (the whole directory)
- Task lists, backlogs, meeting notes
- README sections that contain project management info (copy entire README)
- `.cursor/`, `.aider/`, or other AI context files
- Design docs, architecture docs, specs

**Preserve directory structure:**
```
.original_materials/
  MANIFEST.md
  README.md              # copy of root README
  docs/                  # copy of original docs/ directory
    architecture.md
    api-design.md
  CLAUDE.md              # copy from root
  .cursor/               # copy of cursor context
    rules.md
  notes/                 # copy of any notes directory
    meeting-2024-01-15.md
```

### Step 2.3: Create MANIFEST.md
```markdown
# Original Materials Manifest

Archived on [YYYY-MM-DD] during project adoption (Session 1).

## Archived Files

| Original Location | Type | Content Summary | Disposition |
|-------------------|------|----------------|-------------|
| /README.md | Identity | Project description, setup guide | Content reorganized into PROJECT.md and docs/ |
| /docs/architecture.md | Architecture | System design overview | Reorganized into .project/docs/architecture.md |
| /CLAUDE.md | AI Context | Design principles, conventions | Merged into updated CLAUDE.md |
| [path] | [type] | [summary] | [what happened to it] |

## Notes
- Source code, tests, configs, and build files were NOT archived (they remain in place)
- All PM-related content has been reorganized into `.project/` — see the docs there
- If something seems missing, check this manifest and the `.original_materials/` directory
```

## Phase 3: Stakeholder Interview

Present audit findings, then ask pointed questions. 2-3 at a time.

### Opening
"I've completed the codebase audit. Here's what I found: [present audit report]. Now I need to fill in the gaps with your knowledge."

### Question Bank

**Current State:**
1. "What's the current state of the project? What works, what's broken, what's in progress?"
2. "What does 'done' look like for the current phase? What's the immediate goal?"
3. "Are there any active fires or urgent issues?"

**History & Context:**
4. "What's the original vision vs where you are now? Any pivots along the way?"
5. "What decisions have been made that I should know about? Any regrets?"
6. "Are there any undocumented patterns or conventions in the code?"

**Documentation Assessment:**
7. "Which of the existing docs are trustworthy? Which are outdated?"
8. "Is there any tribal knowledge that's never been written down?"
9. "Any external docs I should know about? (Notion, Figma, Slack threads, etc.)"

**Pain Points:**
10. "What are the biggest pain points right now?"
11. "What keeps breaking? Where is the code most fragile?"
12. "What's the biggest risk to the project?"

**Priorities:**
13. "What's the priority: ship what's in progress, or step back and re-architect?"
14. "If you could only finish one thing, what would it be?"
15. "Any hard deadlines coming up?"

**Backlog & Future:**
16. "What features are planned but not started?"
17. "What ideas have you been kicking around but haven't committed to?"
18. "Any existing roadmap, backlog, or task tracker? Where does it live?"

## Phase 4: Gap Analysis

Map existing artifacts to the MECE doc suite.

### Classification Matrix

For each doc in the MECE suite, classify:

| Document | Status | Source Material | Notes |
|----------|--------|----------------|-------|
| PROJECT.md | [exists+current / exists+stale / partial / missing] | [what existing files inform it] | [what's missing] |
| prd.md | | | |
| technical-spec.md | | | |
| architecture.md | | | |
| api-spec.md | | | |
| data-model.md | | | |
| ux-spec.md | | | |
| roadmap.md | | | |
| milestones.md | | | |
| execution-plan.md | | | |

### Classification Definitions

- **Exists and current:** Content exists in original materials AND is accurate. Will be reorganized into `.project/docs/`.
- **Exists but stale:** Content exists but is outdated, incomplete, or contradicts current code. Will be reorganized + flagged for update.
- **Partial:** Some relevant content exists but doesn't cover all required sections. Will be reorganized + gaps noted for generation.
- **Missing:** No equivalent content found. Will be generated from audit + interview findings.

### Gap Analysis Report
Present to user:
```
## Gap Analysis

### Well-Covered
- [doc]: [source material], current and accurate

### Partially Covered
- [doc]: [source material], but missing [sections]

### Missing — Will Generate
- [doc]: No existing equivalent, will generate from [data sources]

### Stale — Will Update
- [doc]: [source material] exists but outdated, will reorganize + flag for review
```

## Phase 5: Reorganization & Doc Generation

### Step 5.1: Reorganize Existing Content
For each doc that has source material:
1. Read the relevant template from `doc-templates.md`
2. Map existing content into the template structure
3. Add missing section headers (leave empty with `[TBD — needs input]`)
4. Convert language to prescriptive MUST/SHOULD/MAY
5. Add Given/When/Then acceptance criteria where applicable
6. Preserve original decisions and context — reorganize, don't rewrite intent
7. Write to the canonical `.project/` location

### Step 5.2: Generate Missing Docs
For each doc classified as "missing":
1. Generate from audit findings + interview data
2. Mark as `status: draft` in the document header
3. Note which sections need user validation

### Step 5.3: Clean Up Remnant Files
After content is safely in `.project/` AND archived in `.original_materials/`:
1. Remove PM files from their original scattered locations
2. Remove empty directories left behind
3. Do NOT touch: source code, tests, configs, build files, package manifests, CI/CD files
4. Do NOT touch: README.md (it stays — it's a project identity file, not just PM)
5. Update README.md if it referenced moved docs (fix links to point to `.project/`)

### Step 5.4: Build state.json
Infer state from reality:
- **current_phase:** Has deployable code? → "building". Just specs? → "planning". Pre-code? → "discovery". Shipping to users? → "shipping".
- **active_milestone:** Ask user, or infer from recent commit themes
- **active_sprint:** Set to first sprint of current milestone
- **blockers:** From interview findings
- **things_not_to_redo:** CRITICAL — capture ALL existing decisions that shouldn't be re-litigated

### Step 5.5: Seed Backlogs
- `exploration.md`: Features mentioned in interviews but not in code
- `tech-debt.md`: Issues identified during audit (missing tests, outdated deps, fragile code, code smells)
- `backlog.md`: Known pending work from interview

### Step 5.6: Generate Execution Plan
Build sprint sequence from remaining work:
1. Identify what's in progress (partially built features)
2. Identify what's next (user priorities from interview)
3. Account for tech debt (may need a hardening sprint)
4. Chunk into session-sized sprints (see `execution-protocol.md`)
5. Write to `.project/roadmap/execution-plan.md`

### Step 5.7: Generate Architecture Diagram
Use visual-explainer to generate an architecture diagram from the ACTUAL codebase:
- Components based on the real module structure
- Data flow based on actual API calls and dependencies
- Write to `.project/mocks/mock-001-architecture.html`

### Step 5.8: Update CLAUDE.md
Update the project's CLAUDE.md:
- Add `## Project Management` pointer to `.project/`
- Extract design principles from existing code patterns + interview
- Keep under 30 lines of additions
- Remove any outdated AI context that's now in `.project/`

## Phase 6: Onboarding Summary

### Step 6.1: Present State of the Union
```
## Adoption Complete — State of the Union

### What Was Archived
- [N] files archived to .project/.original_materials/
- See MANIFEST.md for full inventory

### What Was Reorganized
- [doc]: from [original location] → .project/docs/[name]
- [doc]: generated fresh (marked as draft)

### Project Health
- ✅ Healthy: [areas that are in good shape]
- ⚠️ Needs Attention: [areas flagged for review]
- 🔴 Critical: [urgent issues]

### Recommended Priorities
1. [Top priority based on all findings]
2. [Second priority]
3. [Third priority]
```

### Step 6.2: Iterate on Corrections
"Does this match your understanding? Anything I got wrong?"
Incorporate corrections into the docs.

### Step 6.3: Generate Kanban Board
Generate `.project/mocks/board.html` with current state. Open in browser.

### Step 6.4: Run Session Wrap-Up
Follow the standard session end protocol from `session-protocol.md`.

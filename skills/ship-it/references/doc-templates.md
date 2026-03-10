# Document Templates — MECE Documentation Suite

Every document MUST be self-contained and droppable into any coding agent with zero context. Use prescriptive language: MUST, MUST NOT, SHOULD, MAY (RFC 2119). Use Given/When/Then for acceptance criteria.

## PROJECT.md

```markdown
# [Project Name]

**Elevator Pitch:** [One sentence — what this is and who it's for]

**Status:** [discovery | planning | building | shipping]
**Version:** [semver]
**Phase:** [Current milestone/phase name]

## What Is This?

[2-3 paragraph description. What the product does, who uses it, what problem it solves. Written for someone with zero context.]

## Tech Stack

| Layer | Technology | Notes |
|-------|-----------|-------|
| Frontend | | |
| Backend | | |
| Database | | |
| Infrastructure | | |
| Key Libraries | | |

## Quick Links

- PRD: `.project/docs/prd.md`
- Architecture: `.project/docs/architecture.md`
- Plan: `.project/plan.md` (derived from state.json)
- Current Sprint: [sprint name] — see state.json
- Kanban Board: `.project/mocks/board.html`

## Design Principles

1. [Principle] — [One-line rationale]
2. [Principle] — [One-line rationale]
3. [Principle] — [One-line rationale]

## Key Decisions

| Decision | ADR | Summary |
|----------|-----|---------|
| [Decision] | [ADR-NNN] | [One line] |
```

## docs/prd.md — Product Requirements Document

```markdown
# Product Requirements Document — [Project Name]

**Version:** [N]
**Last Updated:** [YYYY-MM-DD]
**Status:** [draft | review | approved]

## 1. Overview

### 1.1 Problem Statement
[What problem exists? Who has it? How painful is it?]

### 1.2 Target Users
| Persona | Description | Primary Need |
|---------|-------------|-------------|
| [Name] | [Who they are] | [What they need] |

### 1.3 Success Metrics
| Metric | Target | Measurement |
|--------|--------|-------------|
| [Metric] | [Target value] | [How measured] |

## 2. Functional Requirements

### 2.1 [Feature Area Name]

**FR-[NNN]: [Requirement Title]**
- **Priority:** MUST | SHOULD | MAY
- **Description:** [What the system MUST do]
- **Acceptance Criteria:**
  - Given [precondition], When [action], Then [expected result]
  - Given [precondition], When [action], Then [expected result]
- **Edge Cases:**
  - [Edge case and expected behavior]
- **Out of Scope:** [What this does NOT include]

[Repeat FR block for each requirement]

### 2.2 [Next Feature Area]
[...]

## 3. Non-Functional Requirements

### 3.1 Performance
- [Latency, throughput, concurrency requirements]

### 3.2 Security
- [Auth, authorization, data protection requirements]

### 3.3 Scalability
- [Expected load, growth projections, scaling strategy]

### 3.4 Accessibility
- [WCAG level, screen reader support, keyboard navigation]

## 4. MVP Boundary

### In Scope (v1)
- [Feature/requirement]

### Explicitly Out of Scope (v1)
- [Feature] — deferred to [phase/milestone]

## 5. Open Questions
- [ ] [Unresolved question with owner if known]

## 6. Revision History
| Version | Date | Changes |
|---------|------|---------|
| 1 | [date] | Initial draft from discovery |
```

## docs/technical-spec.md — Technical Specification

```markdown
# Technical Specification — [Project Name]

**Version:** [N]
**Last Updated:** [YYYY-MM-DD]

## 1. Implementation Overview

[High-level approach. What frameworks, patterns, and libraries are used and WHY.]

## 2. Technology Decisions

| Decision | Choice | Alternatives Considered | Rationale |
|----------|--------|------------------------|-----------|
| [Area] | [Choice] | [Alt 1, Alt 2] | [Why this one] |

## 3. Implementation Details

### 3.1 [Component/Module Name]

**Purpose:** [What this component does]
**Location:** [File path or directory]

**Key Implementation Notes:**
- [Algorithm, pattern, or approach used]
- [Critical constraints or invariants]
- [Performance considerations]

**Dependencies:**
- [Internal dependency] — [why needed]
- [External library] — [version, why needed]

[Repeat for each major component]

## 4. Data Processing

### 4.1 [Pipeline/Flow Name]
- **Input:** [What comes in]
- **Processing:** [What happens]
- **Output:** [What comes out]
- **Error Handling:** [What happens on failure]

## 5. Third-Party Integrations

| Service | Purpose | Auth Method | Fallback |
|---------|---------|-------------|----------|
| [Service] | [Why] | [How] | [If unavailable] |

## 6. Testing Strategy

| Level | Framework | Coverage Target | Notes |
|-------|-----------|----------------|-------|
| Unit | [framework] | [%] | [Focus areas] |
| Integration | [framework] | [%] | [Key flows] |
| E2E | [framework] | [%] | [Critical paths] |

## 7. Build & Deploy

- **Build command:** `[command]`
- **Test command:** `[command]`
- **Deploy process:** [Description]
- **Environment variables:** [List with descriptions, NOT values]
```

## docs/architecture.md — Architecture Document

```markdown
# Architecture — [Project Name]

**Version:** [N]
**Last Updated:** [YYYY-MM-DD]
**Diagram:** `.project/mocks/mock-001-architecture.html`

## 1. System Overview

[2-3 paragraphs describing the system at a whiteboard level. What the major pieces are, how they connect, where data lives.]

## 2. Component Map

| Component | Responsibility | Owns | Does NOT Own |
|-----------|---------------|------|-------------|
| [Name] | [What it does] | [Its data/behavior] | [Common misconception] |

## 3. Data Flow

### 3.1 [Primary Flow Name] (e.g., "User Authentication")
```
[Step-by-step data flow using arrows or numbered list]
1. User submits credentials → Frontend
2. Frontend sends POST /auth → API Gateway
3. API Gateway validates → Auth Service
4. Auth Service checks DB → Returns JWT
5. Frontend stores token → Local storage
```

[Repeat for each key flow]

## 4. Deployment Architecture

- **Environment:** [cloud provider, region, etc.]
- **Topology:** [Diagram description or reference]
- **Scaling:** [How components scale]
- **Networking:** [VPC, load balancers, DNS]

## 5. Cross-Cutting Concerns

### 5.1 Error Handling
[Strategy for error propagation, logging, user-facing errors]

### 5.2 Observability
[Logging, metrics, tracing, alerting]

### 5.3 Security Boundaries
[What's public, what's private, trust boundaries]

## 6. Key Constraints
- [Constraint] — [Why it exists]
- [Constraint] — [Implication for development]

## 7. Architecture Decision Records
| ADR | Title | Status |
|-----|-------|--------|
| [ADR-NNN] | [Title] | [accepted/superseded] |
```

## docs/api-spec.md — API Specification

```markdown
# API Specification — [Project Name]

**Version:** [N]
**Last Updated:** [YYYY-MM-DD]
**Base URL:** [URL or pattern]

## 1. Authentication
- **Method:** [Bearer token / API key / Session / etc.]
- **Header:** `Authorization: Bearer <token>`
- **Token Lifetime:** [Duration]

## 2. Common Patterns

### Error Response Format
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable description",
    "details": {}
  }
}
```

### Pagination
- `?page=1&per_page=20`
- Response includes: `total`, `page`, `per_page`, `total_pages`

## 3. Endpoints

### 3.1 [Resource Name]

#### `POST /api/v1/[resource]` — Create [Resource]

**Request:**
```json
{
  "field": "value (required, string, max 255 chars)",
  "optional_field": "value (optional, string)"
}
```

**Response (201):**
```json
{
  "id": "uuid",
  "field": "value",
  "created_at": "ISO-8601"
}
```

**Errors:**
| Code | Status | When |
|------|--------|------|
| VALIDATION_ERROR | 400 | Missing required field |
| CONFLICT | 409 | Duplicate resource |

[Repeat for each endpoint]
```

## docs/data-model.md — Data Model

```markdown
# Data Model — [Project Name]

**Version:** [N]
**Last Updated:** [YYYY-MM-DD]
**Diagram:** `.project/mocks/mock-NNN-data-model.html`

## 1. Overview

[Brief description of data architecture — relational, document, graph, hybrid. Why this choice.]

## 2. Entities

### 2.1 [Entity Name]

**Purpose:** [What this entity represents]
**Table/Collection:** `[name]`

| Field | Type | Constraints | Description |
|-------|------|------------|-------------|
| id | UUID | PK, auto-generated | Unique identifier |
| [field] | [type] | [constraints] | [description] |
| created_at | timestamp | NOT NULL, default NOW | Creation time |
| updated_at | timestamp | NOT NULL, auto-update | Last modification |

**Indexes:**
- `idx_[name]_[field]` on `[field]` — [why this index exists]

**Relationships:**
- Has many [Entity] via `[foreign_key]`
- Belongs to [Entity] via `[foreign_key]`

[Repeat for each entity]

## 3. Relationship Map

[Describe key relationships. Reference ER diagram if generated.]

## 4. Migration Strategy

- **Tool:** [migration framework]
- **Naming:** `NNNN_[description].sql`
- **Rollback:** [Strategy — each migration MUST be reversible / forward-only with rationale]

## 5. Data Lifecycle

| Data Type | Retention | Archival | Deletion |
|-----------|-----------|----------|----------|
| [Type] | [Duration] | [Strategy] | [How] |
```

## docs/ux-spec.md — UX Specification

```markdown
# UX Specification — [Project Name]

**Version:** [N]
**Last Updated:** [YYYY-MM-DD]

## 1. Design Principles

1. [Principle] — [How it manifests in the UI]

## 2. User Flows

### 2.1 [Flow Name] (e.g., "New User Onboarding")

**Entry Point:** [How the user arrives]
**Happy Path:**
1. User sees [screen/state]
2. User does [action]
3. System responds with [feedback]
4. User sees [next screen/state]

**Error States:**
- [Error condition] → [What the user sees] → [Recovery path]

**Edge Cases:**
- [Edge case] → [Expected behavior]

**Wireframe:** `.project/mocks/mock-NNN-[flow-name].html`

[Repeat for each flow]

## 3. Component Inventory

| Component | Used In | Behavior | States |
|-----------|---------|----------|--------|
| [Component] | [Screens] | [What it does] | [default, hover, active, disabled, error, loading] |

## 4. Responsive Behavior

| Breakpoint | Layout Changes |
|-----------|---------------|
| Mobile (<768px) | [Changes] |
| Tablet (768-1024px) | [Changes] |
| Desktop (>1024px) | [Changes] |

## 5. Accessibility Requirements

- [WCAG level target]
- [Keyboard navigation requirements]
- [Screen reader requirements]
- [Color contrast requirements]
```

## plan.md — Project Plan (Derived View)

**This file is a derived view.** Generated from `state.json` phases hierarchy. Never edited directly. Regenerated when the plan changes (sprint advance, pivot, replan).

Shows the same data at two zoom levels:
- **Roadmap view** (top section): Phases + milestones + progress %
- **Detail view** (lower sections): Sprints + tasks + dependencies + acceptance criteria

```markdown
# Plan — [Project Name]

**Generated from:** state.json v[N]
**Last Regenerated:** [YYYY-MM-DD]
**Current:** Phase [P-N] → Milestone [M-NNN] → Sprint [S-NNN]

---

## Roadmap Overview

| Phase | Name | Status | Milestones | Progress |
|-------|------|--------|------------|----------|
| P-1 | [Name] | done | M-001, M-002 | 100% |
| P-2 | [Name] | active | M-003, M-004 | 60% |
| P-3 | [Name] | planned | M-005 | 0% |

---

## Phase P-1: [Name] ✓

**Status:** done

### Milestone M-001: [Name] ✓
**Progress:** 5/5 tasks
**Sprints:** S-001, S-002

| ID | Task | Size | Status | Sprint | Dependencies |
|----|------|------|--------|--------|-------------|
| T-001 | [Task name] | M | done | S-001 | — |
| T-002 | [Task name] | L | done | S-001 | T-001 |
| T-003 | [Task name] | S | done | S-002 | — |

---

## Phase P-2: [Name] ← ACTIVE

### Milestone M-003: [Name] ← ACTIVE
**Progress:** 3/8 tasks
**Sprints:** S-005 (active), S-006, S-007

#### Sprint S-005: [Name] ← ACTIVE
**Type:** feature
**Estimated Sessions:** 2
**Actual Sessions:** 1

| ID | Task | Size | Status | Dependencies | Acceptance Criteria |
|----|------|------|--------|-------------|-------------------|
| T-020 | [Task name] | M | done | — | Given X, When Y, Then Z |
| T-021 | [Task name] | L | doing | T-020 | Given X, When Y, Then Z |
| T-022 | [Task name] | M | pending | — | Given X, When Y, Then Z |

#### Sprint S-006: [Name]
**Type:** integration
**Estimated Sessions:** 1

| ID | Task | Size | Status | Dependencies |
|----|------|------|--------|-------------|
| T-025 | [Task name] | S | pending | T-021 |

[Continue for all phases/milestones/sprints]

---

## Backlog

### Main
| ID | Item | Description |
|----|------|-------------|
| BL-001 | [Name] | [Brief description] |

### Exploration
| ID | Item | Source Session |
|----|------|--------------|
| BL-003 | [Name] | Session 4 |

### Tech Debt
| ID | Item | Description |
|----|------|-------------|
| BL-005 | [Name] | [Brief description] |

---

## Sprint History

| Sprint | Name | Type | Planned Sessions | Actual Sessions | Tasks | Notes |
|--------|------|------|-----------------|----------------|-------|-------|
| S-001 | [Name] | feature | 2 | 2 | 3/3 | — |
| S-002 | [Name] | refactor | 1 | 1 | 2/2 | — |
```

## decisions/adr-NNN-title.md — Architecture Decision Record

```markdown
# ADR-[NNN]: [Title]

**Date:** [YYYY-MM-DD]
**Status:** [proposed | accepted | superseded by ADR-NNN]
**Session:** [session number]

## Context

[What is the issue that we're seeing that is motivating this decision?]

## Decision

[What is the change that we're proposing and/or doing?]

## Alternatives Considered

### [Alternative 1]
- **Pros:** [list]
- **Cons:** [list]
- **Why rejected:** [reason]

### [Alternative 2]
[same structure]

## Consequences

### Positive
- [Good outcome]

### Negative
- [Trade-off or risk accepted]

### Implications for Backlog
- [Impact on existing backlog items, if any]

## References
- [Links to relevant docs, discussions, external resources]
```

## sessions/HANDOFF.md — Session Handoff Brief

This document is REGENERATED (complete rewrite) at the end of every session. NEVER append.

```markdown
# Session Handoff — [Project Name]

**Last Session:** [session number] — [date]
**Phase:** [current phase]
**Active Milestone:** [milestone name] — [X/Y tasks complete]
**Active Sprint:** [sprint name] — [X/Y tasks done]

## What Happened Last Session

[3-5 bullet points of the most important things accomplished, decided, or changed]

## Current State

- **Working:** [What's functional and stable]
- **In Progress:** [What's partially done]
- **Blocked:** [What can't proceed and why]
- **Changed:** [What was modified from the previous plan]

## Decisions Made

| Decision | ADR | Impact |
|----------|-----|--------|
| [Decision] | [ADR-NNN or "inline"] | [What it affects] |

## Things NOT to Redo

- [Explicit statement about what's been decided/finalized]
- [Reference to relevant doc if needed]

## Priorities for Next Session

1. [Most important task — reference sprint/task ID]
2. [Second priority]
3. [Third priority]

## Open Questions

- [ ] [Question that needs resolution]

## Files Changed Last Session

| File | Change |
|------|--------|
| [path] | [created/updated/archived] |
```

## KANBAN.md (Derived View)

The kanban data file. Lives at `.project/KANBAN.md`. **Derived from `state.json`** — regenerated whenever task statuses change. The HTML board (`board.html`) is rendered from this file.

Cards are listed under column headers. Each card is a single line with a fixed format. Card text MUST match task names from `state.json` exactly — do not paraphrase.

KANBAN.md is regenerated from `state.json`, then board.html is rendered from KANBAN.md. Never edit KANBAN.md directly.

```markdown
# Kanban

**Sprint:** [S-NNN — Sprint Name]
**Milestone:** [M-NNN — Milestone Name]
**Phase:** [P-N — Phase Name]
**Session:** [N]

## Backlog
- [ ] [Task name from state.json backlog] | [S/M/L/XL]

## Up Next
- [ ] [Task name from state.json — status: pending, in next sprint] | Sprint [N] | [S/M/L/XL]

## In Progress
- [~] [Task name from state.json — status: doing] | Sprint [N] | [S/M/L/XL]

## Done
- [x] [Task name from state.json — status: done] | Sprint [N] | [S/M/L/XL]

## Blocked
- [!] [Task name from state.json — status: blocked] | Sprint [N] | [S/M/L/XL] | Blocker: [B-NNN description]
```

### Card line format
```
- [status] Task name exactly as in state.json | Sprint N | Size | optional blocker
```

Status markers:
- `[ ]` — not started (Backlog, Up Next)
- `[~]` — in progress
- `[x]` — done
- `[!]` — blocked

### Rules
- Card text MUST match task names from `state.json` exactly — never paraphrase
- KANBAN.md is regenerated from `state.json` on every task status change
- `state.json` is the authority — KANBAN.md and board.html are always derived
- Backlog cards have no sprint assignment
- The header metadata (Sprint, Milestone, Phase, Session) comes from `state.json` `current`

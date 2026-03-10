# Backlog Protocol — Three-Tier Backlog Management

> **Note:** Backlog data lives in `state.json` `backlog` array with a `tier` field (main, exploration, tech-debt). The separate backlog files (`backlog/exploration.md`, `backlog/tech-debt.md`, `backlog/backlog.md`) are no longer used. The tiers and promotion rules below still apply — they now operate on `state.json` backlog entries.

The ship-it skill manages three distinct backlog tiers, each serving a different purpose. Together they capture all known work that isn't in the active sprint.

## Backlog Types

### 1. Exploration Backlog (`backlog/exploration.md`)

**Purpose:** Ideas discussed but not yet spec'd. These are "maybe someday" features, research topics, and possibilities that emerged during discovery or working sessions.

**Format:**
```markdown
# Exploration Backlog

## Ideas

### [Idea Title]
- **Source:** [Session N / discovery / user request]
- **Description:** [1-2 sentences]
- **Related To:** [milestone, feature area, or "standalone"]
- **Value Signal:** [why this might matter]
- **Open Questions:** [what we'd need to figure out first]
- **Added:** [YYYY-MM-DD]
```

**Entry criteria:** Any feature, idea, or capability mentioned in conversation that isn't part of the current plan.

**Exit criteria:** Promoted to main backlog (spec'd) OR explicitly dropped.

### 2. Tech Debt Backlog (`backlog/tech-debt.md`)

**Purpose:** Technical shortcuts, fragility, missing tests, outdated dependencies, and code quality issues identified during development.

**Format:**
```markdown
# Tech Debt Backlog

## Items

### [TD-NNN] [Title]
- **Severity:** low | medium | high | critical
- **Category:** shortcut | fragility | missing-tests | dependency | code-quality
- **Location:** [file path or component]
- **Description:** [What the issue is and why it matters]
- **Impact if Ignored:** [What breaks or degrades]
- **Estimated Effort:** S | M | L
- **Added:** [Session N, YYYY-MM-DD]
```

**Entry criteria:** Any technical shortcut, known fragility, or quality issue discovered during development.

**Exit criteria:** Fixed (moved to sprint) OR accepted (documented as acceptable with rationale).

### 3. Main Backlog (`backlog/backlog.md`)

**Purpose:** Spec'd, understood work that is not yet scheduled into a sprint. These are ready-to-build items with clear acceptance criteria.

**Format:**
```markdown
# Backlog

## Ready for Sprint

### [B-NNN] [Title]
- **Priority:** high | medium | low
- **Size:** S | M | L | XL
- **From:** [Milestone M-N / Exploration / Tech Debt TD-NNN]
- **Description:** [What needs to be built]
- **Acceptance Criteria:**
  - Given [X], When [Y], Then [Z]
- **Dependencies:** [none | list]
- **Added:** [Session N]
```

**Entry criteria:** Feature is spec'd with acceptance criteria and sized.

**Exit criteria:** Scheduled into a sprint OR deprioritized back to exploration.

## Surfacing Triggers

Surface backlog items when the context is right:

| Trigger | What to Surface | How |
|---------|----------------|-----|
| Working on related code | Exploration items in the same area | "While we're in the auth module, there's an exploration item about SSO — worth discussing?" |
| Sprint complete | Next-priority main backlog items | "Sprint done. Top candidates for next sprint: [list]" |
| Tech debt accumulation | High-severity tech debt items | "We have 3 high-severity tech debt items. Want to schedule a hardening sprint?" |
| Milestone boundary | Deferred exploration items | "We've been deferring [X] for 3 sessions. Worth spec'ing now?" |
| Architecture change | Affected backlog items | "This architecture change affects backlog items B-003 and B-007 — they may need re-scoping." |
| User mentions future feature | Existing exploration item | "We already have that in exploration — want to promote it to the backlog?" |

## Promotion Flow

### Exploration → Main Backlog
1. User agrees the idea is worth pursuing
2. Spec the feature with acceptance criteria (brief — not a full PRD section)
3. Size the work (S/M/L/XL)
4. Identify dependencies
5. Move from `exploration.md` to `backlog.md`
6. Update `backlog_stats` in `state.json`

### Tech Debt → Sprint
1. Assess severity and impact
2. Bundle related tech debt items into a "hardening sprint" OR
3. Attach individual items to feature sprints when the affected code is being touched
4. Promote to task in `state.json`: assign task ID, sprint ID, add to milestone tasks array, remove from backlog

### Main Backlog → Sprint
1. Prioritize against current sprint candidates
2. Check dependencies (can it be done now?)
3. Promote to task in `state.json`: assign task ID, sprint ID, add to milestone tasks array, set `promoted_to` in backlog entry

## Backlog Hygiene

At sprint boundaries (when completing a sprint), review:
- **Exploration items >5 sessions old:** "Is this still relevant?" If not, archive or delete.
- **Tech debt items in areas being actively developed:** Consider bundling into current work.
- **Main backlog items with no sprint assignment after 3 sprints:** Re-evaluate priority.
- **Duplicate or overlapping items:** Merge or clarify boundaries.

## Triage Protocol (for `/ship-backlog`)

When `/ship-backlog` is invoked:
1. Present summary: "[N] exploration, [N] tech debt, [N] main backlog items"
2. Ask: "Want to review a specific backlog, add an item, or triage?"
3. If triage: Walk through items by priority, ask keep/drop/promote for each
4. Update all affected files and `state.json`

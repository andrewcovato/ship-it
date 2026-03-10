# Backlog Protocol — Three-Tier Backlog Management

All backlog data lives in `state.json` `backlog` array. Each entry has a `tier` field: `main`, `exploration`, or `tech-debt`. There are no separate backlog files.

## Backlog Tiers

### 1. Exploration (tier: "exploration")

Ideas discussed but not yet spec'd. "Maybe someday" features, research topics, possibilities from discovery or working sessions.

**Entry fields:**
```json
{
  "id": "BL-001",
  "tier": "exploration",
  "title": "SSO Support",
  "source": "Session 3 / discovery / user request",
  "description": "1-2 sentences",
  "related_to": "milestone M-002 / feature area / standalone",
  "value_signal": "why this might matter",
  "open_questions": ["what we'd need to figure out first"],
  "added": "YYYY-MM-DD",
  "promoted_to": null
}
```

**Entry criteria:** Any feature, idea, or capability mentioned in conversation that isn't part of the current plan.
**Exit criteria:** Promoted to main backlog (spec'd) OR explicitly dropped (remove from array).

### 2. Tech Debt (tier: "tech-debt")

Technical shortcuts, fragility, missing tests, outdated dependencies, and code quality issues identified during development.

**Entry fields:**
```json
{
  "id": "BL-002",
  "tier": "tech-debt",
  "title": "Missing auth middleware tests",
  "severity": "low | medium | high | critical",
  "category": "shortcut | fragility | missing-tests | dependency | code-quality",
  "location": "file path or component",
  "description": "What the issue is and why it matters",
  "impact_if_ignored": "What breaks or degrades",
  "estimated_effort": "S | M | L",
  "added": "YYYY-MM-DD",
  "promoted_to": null
}
```

**Entry criteria:** Any technical shortcut, known fragility, or quality issue discovered during development.
**Exit criteria:** Fixed (promoted to task in sprint) OR accepted (documented as acceptable with rationale, then removed).

### 3. Main Backlog (tier: "main")

Spec'd, understood work not yet scheduled into a sprint. Ready-to-build items with clear acceptance criteria.

**Entry fields:**
```json
{
  "id": "BL-003",
  "tier": "main",
  "title": "User profile avatars",
  "priority": "high | medium | low",
  "size": "S | M | L | XL",
  "from": "Milestone M-001 / Exploration BL-001 / Tech Debt BL-002",
  "description": "What needs to be built",
  "acceptance_criteria": ["Given X, When Y, Then Z"],
  "dependencies": [],
  "added": "YYYY-MM-DD",
  "promoted_to": null
}
```

**Entry criteria:** Feature is spec'd with acceptance criteria and sized.
**Exit criteria:** Promoted to task in a sprint OR deprioritized back to exploration.

## Surfacing Triggers

Surface backlog items when the context is right:

| Trigger | What to Surface | How |
|---------|----------------|-----|
| Working on related code | Exploration items in the same area | "While we're in the auth module, there's an exploration item about SSO — worth discussing?" |
| Sprint complete | Next-priority main backlog items | "Sprint done. Top candidates for next sprint: [list]" |
| Tech debt accumulation | High-severity tech debt items | "We have 3 high-severity tech debt items. Want to schedule a hardening sprint?" |
| Milestone boundary | Deferred exploration items | "We've been deferring [X] for 3 sessions. Worth spec'ing now?" |
| Architecture change | Affected backlog items | "This architecture change affects backlog items BL-003 and BL-007 — they may need re-scoping." |
| User mentions future feature | Existing exploration item | "We already have that in exploration — want to promote it to the backlog?" |

## Promotion Flow

### Exploration → Main Backlog
1. User agrees the idea is worth pursuing
2. Spec the feature with acceptance criteria
3. Size the work (S/M/L/XL)
4. Identify dependencies
5. Update the entry in `state.json`: change `tier` to `"main"`, add `acceptance_criteria`, `priority`, `size`, `dependencies`

### Tech Debt → Sprint Task
1. Assess severity and impact
2. Bundle related tech debt items into a "hardening sprint" OR attach to feature sprints when affected code is being touched
3. Promote to task in `state.json`:
   - Assign task ID from counters (increment `counters.task`)
   - Add task to appropriate sprint in `phases[].milestones[].sprints[].tasks[]`
   - Mirror in `active_sprint.tasks[]` if it's the current sprint
   - Set `promoted_to: "T-NNN"` on the backlog entry

### Main Backlog → Sprint Task
1. Prioritize against current sprint candidates
2. Check dependencies (can it be done now?)
3. Promote to task in `state.json`:
   - Assign task ID from counters (increment `counters.task`)
   - Add task to appropriate sprint in `phases[].milestones[].sprints[].tasks[]`
   - Mirror in `active_sprint.tasks[]` if it's the current sprint
   - Set `promoted_to: "T-NNN"` on the backlog entry

## Backlog Hygiene

At sprint boundaries (when completing a sprint), review:
- **Exploration items >5 sessions old:** "Is this still relevant?" If not, remove from array.
- **Tech debt in active areas:** Consider bundling into current work.
- **Main backlog items unscheduled for 3+ sprints:** Re-evaluate priority.
- **Duplicate or overlapping items:** Merge or clarify boundaries.

After any backlog changes, regenerate `plan.md` and `KANBAN.md` (backlog items appear in the Backlog column).

---
description: Capture an Architecture Decision Record (ADR) — document a design decision with context, alternatives, and consequences
---
Load the ship-it skill. This is a `/ship-decide` invocation.

Read `.project/state.json` to get the current `adr_counter`.
Read `./references/doc-templates.md` for the ADR template.

## Capture Decision

If the user provides a decision description (`$@`):
1. Increment `adr_counter` in `state.json`
2. Generate ADR using the template:
   - Title from the description
   - Context: why this decision was needed
   - Decision: what was chosen
   - Alternatives considered (ask user if not provided)
   - Consequences: positive, negative, and backlog implications
3. Write to `.project/decisions/adr-<NNN>-<slugified-title>.md`
4. Update `recent_decisions` in `state.json`

## Guided Mode

If no description provided, guide the user through the ADR:
1. "What decision are we capturing?"
2. "What's the context — why did this come up?"
3. "What alternatives did we consider?"
4. "What are the trade-offs of this choice?"
5. Generate the ADR from answers

## Auto-Check Implications

After creating the ADR:
1. Check if the decision affects any items in `backlog/backlog.md` or `backlog/exploration.md`
2. Check if the decision establishes a design principle → offer to update CLAUDE.md
3. Check if the decision changes the architecture → flag `architecture.md` for update
4. Check if the decision affects the execution plan → flag for re-scoping
5. Report implications: "This decision affects: [list]. I'll update the relevant docs."

$@

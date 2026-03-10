---
description: Capture an Architecture Decision Record — document a design decision with context, alternatives, and consequences
argument-hint: Optional decision description
---
Load the ship-it skill. This is a `/ship-decide` invocation.

Read `.project/state.json` for `adr_counter`. Read `./references/doc-templates.md` for the ADR template.

If a description is provided (`$@`): generate the ADR directly, asking for alternatives and trade-offs if not included.
If no description: guide the user through the ADR interactively (what, context, alternatives, trade-offs).

After creating the ADR, auto-check implications on backlog, architecture.md, execution plan, and CLAUDE.md. Report and update affected docs.

$@

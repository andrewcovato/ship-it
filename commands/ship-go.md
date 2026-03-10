---
description: Autonomously execute the current sprint — decomposes tasks, delegates to superpowers for TDD/code-review, pauses at human gates
argument-hint: "Optional: task T-003, sprint 4, full-auto, dry-run"
---
Load the ship-it skill. This is a `/ship-go` invocation.

Read `.project/state.json` — `current` and `active_sprint` for task list, `blockers` for impediments.

Follow the autonomous execution protocol in `./references/autonomous-execution.md`.
Follow the human gates protocol in `./references/human-gates.md`.

If superpowers is not available and `superpowers_prompted` is not true in state.json, offer installation.

$@

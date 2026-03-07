---
description: View or update the strategic roadmap — phases, milestones, timeline. Generates visual timeline on request.
---
Load the ship-it skill. This is a `/ship-roadmap` invocation.

Read `.project/state.json` and `.project/roadmap/roadmap.md`.

## Display Roadmap

Present the current strategic roadmap:

1. **Phase Overview:** All phases with status, goals, and progress
2. **Active Milestone:** Current milestone with task summary
3. **Timeline Assessment:** Planned vs actual progress. Is the roadmap on track?
4. **Deferred Items:** Features pushed to later phases

## Update Roadmap

If the user provides change context (`$@`):

1. Read current `roadmap.md` and `milestones.md`
2. Archive the current version: `.project/archive/roadmap_v<N>_YYYY-MM-DD.md`
3. Apply the changes to `roadmap.md` and `milestones.md`
4. Increment `roadmap_version` in `state.json`
5. **Auto-update execution plan:** When the roadmap changes, re-chunk the execution plan (read `./references/execution-protocol.md`)
6. Update `state.json`
7. Inform user: "Roadmap updated to v[N]. Archived previous version. Execution plan re-chunked."

## Visual Timeline

If `$@` includes "visual" or "timeline", or the user asks for a visualization:

Load the visual-explainer skill. Generate a timeline visualization showing:
- Phases as major sections
- Milestones as markers
- Current position highlighted
- Deferred items shown as faded/optional

Write to `.project/mocks/mock-NNN-roadmap-timeline.html` and open in browser.

$@

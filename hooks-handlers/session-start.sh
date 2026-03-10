#!/usr/bin/env bash

# Ship-it SessionStart hook
# Detects .project/ directories and injects context for auto-resume

if [ -d ".project" ]; then
  cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "A .project/ directory exists in the current working directory. This is a ship-it managed project. Load the ship-it skill and read .project/sessions/HANDOFF.md + .project/state.json to resume the project session. Present a brief status summary. Suggest /ship-go to execute the current sprint autonomously."
  }
}
EOF
else
  cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": ""
  }
}
EOF
fi

exit 0

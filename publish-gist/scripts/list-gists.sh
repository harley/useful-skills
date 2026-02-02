#!/bin/bash
# List gists tracked by publish-gist (only files that exist locally)
# Usage: list-gists.sh

TRACKER="$HOME/.gist-tracker.json"

if [ ! -f "$TRACKER" ] || [ "$(jq 'length' "$TRACKER")" -eq 0 ]; then
  echo "No tracked gists yet."
  exit 0
fi

# Get entries sorted by updated_at, then filter to existing files
jq -r 'to_entries | sort_by(.value.updated_at) | reverse[] | .key' "$TRACKER" | while read -r filepath; do
  if [ -f "$filepath" ]; then
    jq -r --arg p "$filepath" '
      .[$p] |
      "[\(.description // "No description")]",
      "  File: \($p)",
      "  URL:  \(.url)",
      "  Updated: \(.updated_at)",
      ""
    ' "$TRACKER"
  fi
done

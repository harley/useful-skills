#!/bin/bash
# Publish markdown files to GitHub Gist with tracking
# Usage: publish-gist.sh <file> [description] [--public]

set -e

FILE="$1"
DESC=""
PUBLIC=""

# Parse arguments
shift || true
while [[ $# -gt 0 ]]; do
  case "$1" in
    --public)
      PUBLIC="--public"
      shift
      ;;
    *)
      DESC="$1"
      shift
      ;;
  esac
done

# Validate input
if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
  echo "Error: File not found: $FILE" >&2
  exit 1
fi

# Default description to filename
DESC="${DESC:-$(basename "$FILE")}"

TRACKER="$HOME/.gist-tracker.json"

# Resolve to absolute path
ABS_PATH="$(cd "$(dirname "$FILE")" && pwd)/$(basename "$FILE")"

# Initialize tracker if missing
[ -f "$TRACKER" ] || echo '{}' > "$TRACKER"

# Check if already tracked
GIST_ID=$(jq -r --arg p "$ABS_PATH" '.[$p].gist_id // empty' "$TRACKER")

if [ -n "$GIST_ID" ]; then
  # Update existing gist
  gh gist edit "$GIST_ID" "$FILE" >/dev/null 2>&1
  URL=$(jq -r --arg p "$ABS_PATH" '.[$p].url' "$TRACKER")

  # Update timestamp
  jq --arg p "$ABS_PATH" --arg ts "$(date -Iseconds)" \
     '.[$p].updated_at = $ts' \
     "$TRACKER" > "$TRACKER.tmp" && mv "$TRACKER.tmp" "$TRACKER"

  echo "UPDATED"
  echo "$URL"
else
  # Create new gist (private by default)
  OUTPUT=$(gh gist create "$FILE" -d "$DESC" $PUBLIC 2>&1)
  URL=$(echo "$OUTPUT" | grep -oE 'https://gist.github.com/[^[:space:]]+')
  GIST_ID="${URL##*/}"

  # Update tracker
  jq --arg p "$ABS_PATH" --arg id "$GIST_ID" --arg url "$URL" \
     --arg desc "$DESC" --arg ts "$(date -Iseconds)" \
     '.[$p] = {gist_id: $id, url: $url, description: $desc, updated_at: $ts}' \
     "$TRACKER" > "$TRACKER.tmp" && mv "$TRACKER.tmp" "$TRACKER"

  echo "CREATED"
  echo "$URL"
fi

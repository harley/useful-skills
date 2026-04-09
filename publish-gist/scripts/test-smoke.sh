#!/bin/bash
# Smoke test for publish-gist skill
# Tests: create → update → cleanup flow

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PUBLISH_SCRIPT="$SCRIPT_DIR/publish-gist.sh"
TRACKER="$HOME/.gist-tracker.json"

# Generate unique temp file
TEMP_FILE="/tmp/publish-gist-test-$$.md"
GIST_URL=""

cleanup() {
  # Delete gist if created
  if [ -n "$GIST_URL" ]; then
    GIST_ID="${GIST_URL##*/}"
    gh gist delete "$GIST_ID" 2>/dev/null || true
  fi

  # Remove tracker entry
  if [ -f "$TRACKER" ] && [ -f "$TEMP_FILE" ]; then
    ABS_PATH="$(cd "$(dirname "$TEMP_FILE")" && pwd)/$(basename "$TEMP_FILE")"
    jq --arg p "$ABS_PATH" 'del(.[$p])' "$TRACKER" > "$TRACKER.tmp" && mv "$TRACKER.tmp" "$TRACKER"
  fi

  # Remove temp file
  rm -f "$TEMP_FILE"
}

trap cleanup EXIT

echo "Testing publish-gist..."

# Step 1: Create temp file
echo "# Test Gist $(date +%s)" > "$TEMP_FILE"
echo "Initial content" >> "$TEMP_FILE"

# Step 2: Create new gist
OUTPUT=$("$PUBLISH_SCRIPT" "$TEMP_FILE" "Smoke test gist")
STATUS=$(echo "$OUTPUT" | head -1)
GIST_URL=$(echo "$OUTPUT" | tail -1)

if [ "$STATUS" != "CREATED" ]; then
  echo "✗ Expected CREATED, got: $STATUS"
  exit 1
fi

if [[ ! "$GIST_URL" =~ ^https://gist.github.com/ ]]; then
  echo "✗ Invalid gist URL: $GIST_URL"
  exit 1
fi

echo "✓ Created new gist"

# Step 3: Modify file
echo "Updated content $(date +%s)" >> "$TEMP_FILE"

# Step 4: Update existing gist
OUTPUT=$("$PUBLISH_SCRIPT" "$TEMP_FILE")
STATUS=$(echo "$OUTPUT" | head -1)
URL2=$(echo "$OUTPUT" | tail -1)

if [ "$STATUS" != "UPDATED" ]; then
  echo "✗ Expected UPDATED, got: $STATUS"
  exit 1
fi

if [ "$URL2" != "$GIST_URL" ]; then
  echo "✗ URL mismatch: expected $GIST_URL, got $URL2"
  exit 1
fi

echo "✓ Updated existing gist"

# Step 5-6: Cleanup happens in trap
echo "✓ Cleanup complete"
echo "All tests passed"

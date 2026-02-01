---
name: publish-gist
description: Publish markdown files to GitHub Gist. Tracks published files so re-running updates the same gist instead of creating duplicates. Use when user says "publish to gist", "gist this", "share this md", or wants to create a shareable link for a markdown file.
user_invocable: true
---

# Publish to Gist

Publish markdown (or any text) files to GitHub Gist with automatic tracking.

## Usage

When the user wants to publish a file to gist:

1. Get the file path (required) and optional description
2. Run the publish script:
   ```bash
   ./skills/publish-gist/scripts/publish-gist.sh "<file_path>" "<description>" [--public]
   ```
3. Parse the output:
   - First line: `CREATED` or `UPDATED`
   - Second line: The gist URL

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| file | Yes | Path to the file to publish |
| description | No | Gist description (defaults to filename) |
| --public | No | Make gist public (private by default) |

## Tracking

The script maintains a tracker at `~/.gist-tracker.json` mapping absolute file paths to their gist IDs. Re-publishing the same file updates the existing gist rather than creating a new one.

## Examples

```bash
# Publish a file (private gist)
./skills/publish-gist/scripts/publish-gist.sh README.md "Project readme"

# Publish as public
./skills/publish-gist/scripts/publish-gist.sh notes.md "My notes" --public

# Check existing gists
cat ~/.gist-tracker.json | jq
```

## Response Format

After running the script, inform the user:

- **If CREATED**: "Published to gist: <url>"
- **If UPDATED**: "Updated existing gist: <url>"

Always provide the clickable URL so the user can access or share it.

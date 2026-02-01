---
name: publish-gist
description: Publish markdown files to GitHub Gist. Tracks published files so re-running updates the same gist instead of creating duplicates. Use when user says "publish to gist", "gist this", "share this md", or wants to create a shareable link for a markdown file.
---

# Publish to Gist

Run the publish script (path relative to this skill's directory):

```bash
scripts/publish-gist.sh "<file_path>" ["description"] [--public]
```

Output:
- Line 1: `CREATED` or `UPDATED`
- Line 2: The gist URL

## Examples

```bash
# Private gist with default description (filename)
scripts/publish-gist.sh README.md

# With custom description
scripts/publish-gist.sh notes.md "My notes"

# Public gist
scripts/publish-gist.sh notes.md "My notes" --public
```

## Response

- **CREATED**: "Published to gist: <url>"
- **UPDATED**: "Updated existing gist: <url>"

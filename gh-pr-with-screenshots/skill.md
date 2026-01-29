---
name: gh-pr-with-screenshots
description: Create or update a GitHub PR from the current git branch using gh CLI, targeting main. Use when asked to push a branch, create a PR if missing, and update the PR description with UI screenshots saved in a screenshots/ folder (captured via browser-tools). Covers PR creation, screenshot capture, committing screenshots, and PR body updates with blob?raw=1 image URLs.
---

# Gh Pr With Screenshots

## Overview
Create or update a PR for the current branch, capture UI screenshots, commit them under `screenshots/`, and embed them in the PR description.

## Workflow (Default)

1) **Verify branch + status**
- Ensure you are not on `main`.
- If there are uncommitted changes not meant for the PR, stop and ask.

2) **Push branch + ensure PR exists**
- Push current branch to origin.
- Check for an existing PR from this branch.
- Create PR against `main` if missing.

3) **Capture screenshots**
- Use `browser-tools` to open the UI and capture screenshots.
- Save files under `screenshots/` with clear names.

4) **Commit screenshots + push**
- Add new screenshots, commit, and push.

5) **Update PR description**
- Use markdown image links with `blob/... ?raw=1` URLs.
- Replace or append a `## Screenshots` section.

---

## Commands and Patterns

### A) PR discovery + creation (gh)
```bash
# current branch
branch=$(git rev-parse --abbrev-ref HEAD)

# push branch
git push -u origin "$branch"

# find PR for this branch
pr_number=$(gh pr list --head "$branch" --json number -q '.[0].number')

# create PR if missing
if [ -z "$pr_number" ]; then
  pr_url=$(gh pr create --base main --head "$branch" --fill)
  pr_number=$(gh pr view --json number -q '.number')
fi
```

### B) Capture screenshots (browser automation)
Use a browser automation tool (agent-browser, Playwright, Puppeteer) to capture screenshots. Example with agent-browser:
```bash
agent-browser open http://localhost:5173
agent-browser screenshot screenshots/feature-default.png
```
Move files into `screenshots/`:
```bash
mkdir -p screenshots
mv /tmp/screenshot-*.png screenshots/skills-dashboard-default.png
```

### C) Commit screenshots
```bash
git add screenshots/*.png
git commit -m "Add PR screenshots"
git push
```

### D) PR body markdown with stable URLs
Use blob URLs for private repos:
```
https://github.com/<ORG>/<REPO>/blob/<BRANCH>/screenshots/<FILE>?raw=1
```

Example `## Screenshots` section:
```markdown
## Screenshots

**Skills dashboard (default)**

![Skills dashboard default](https://github.com/<ORG>/<REPO>/blob/<BRANCH>/screenshots/skills-dashboard-default.png?raw=1)

**Skills dashboard with active filters**

![Skills dashboard active](https://github.com/<ORG>/<REPO>/blob/<BRANCH>/screenshots/skills-dashboard-active.png?raw=1)
```

Update PR body (simple replace):
```bash
gh pr edit "$pr_number" --body-file /tmp/pr_body.md
```

If you must preserve existing body content:
- Read current body with `gh pr view --json body -q .body`
- Replace or append the `## Screenshots` section and write it back with `gh pr edit`.

---

## Notes
- Prefer `blob/... ?raw=1` links for private repos (more reliable than `raw.githubusercontent.com`).
- When in doubt, verify the PR page using browser-tools.

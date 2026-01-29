---
name: gh-pr-address-comments
description: Review and address GitHub PR comments for the current branch. Use when asked to fetch PR review comments (via gh CLI/API), summarize actionable items, apply code changes, and optionally reply/resolve comments. Targets PRs from the current branch against main.
---

# Gh Pr Address Comments

## Overview
Fetch PR review comments for the current branch, decide which are actionable, implement fixes, and push updates. Optionally reply/resolve review threads in the PR UI.

## Workflow

1) **Identify the PR for the current branch**
- Ensure you are on a feature branch, not `main`.
- Use `gh pr list --head <branch>` to find the PR number.

2) **Fetch review comments (authoritative)**
- Use GitHub API via `gh api` to fetch inline comments and review summaries.
- Prioritize actionable inline comments over summary text.

3) **Triage comments**
- Mark each comment as: address now / defer / no-op.
- If unclear, ask the user before changing behavior.

4) **Implement fixes**
- Apply code changes for actionable items.
- Run minimal checks if relevant (or explain if not).

5) **Commit + push**
- Commit with a clear message and push to the same branch.

6) **Reply/resolve (optional)**
- If requested, add replies and resolve threads in the PR UI (use browser-tools if needed).

---

## Commands

### A) Find PR for current branch
```bash
branch=$(git rev-parse --abbrev-ref HEAD)
pr_number=$(gh pr list --head "$branch" --json number -q '.[0].number')
```

### B) Fetch review comments + reviews
```bash
gh api repos/<ORG>/<REPO>/pulls/<PR>/comments

gh api repos/<ORG>/<REPO>/pulls/<PR>/reviews
```

### C) Summarize actionable items
- Focus on inline comments with file + line context.
- Ignore summary-only comments unless they add new issues.

---

## Notes
- Prefer `gh api .../pulls/<PR>/comments` for inline thread data.
- The PR UI can hide threads if they’re outdated; API data is authoritative.
- If a suggestion is non-critical (perf refactors, optional UX polish), ask before changing behavior.

# useful-skills

Reusable skills for AI coding agents (Claude Code, Cursor, Cline, etc.)

## Skills

| Skill | Description |
|-------|-------------|
| [ask-questions-if-underspecified](./ask-questions-if-underspecified/) | Clarify requirements before implementing |
| [bootstrap-machine](./bootstrap-machine/) | Set up a new dev machine with modern CLI tools |
| [gh-pr-address-comments](./gh-pr-address-comments/) | Fetch and address GitHub PR review comments |
| [gh-pr-with-screenshots](./gh-pr-with-screenshots/) | Create PRs with embedded UI screenshots |
| [syncthing](./syncthing/) | Monitor Syncthing sync status between devices |

## Installation

### Claude Code

```bash
# Symlink a skill to your Claude Code skills directory
ln -s /path/to/useful-skills/bootstrap-machine ~/.claude/skills/bootstrap-machine
```

### Other Agents

Each skill contains a `skill.md` with instructions that can be adapted for other agents. The format is:

```markdown
---
name: skill-name
description: What the skill does
---

# Skill Name

Instructions for the agent...
```

## Skills Overview

### ask-questions-if-underspecified

A methodology skill that teaches agents to clarify requirements before implementing:

- Detect underspecified requests (unclear scope, constraints, acceptance criteria)
- Ask 1-5 focused questions with multiple-choice options
- Provide fast-path defaults (`reply: defaults`)
- Pause before acting until must-have answers arrive

**Usage**: Run `/ask-questions-if-underspecified` before complex tasks

### bootstrap-machine

Automates setting up a new macOS development machine:

- Installs Homebrew (if needed)
- Installs modern Rust CLI tools: `fd`, `rg`, `eza`, `bat`, `dust`, `sd`, `zoxide`, `delta`, `broot`, `tokei`, `procs`, `btm`, `tldr`
- Configures shell aliases (`ls`→`eza`, `cat`→`bat`, etc.)
- Sets up git with delta pager
- Initializes zoxide for smart directory jumping

**Usage**: Run `/bootstrap-machine` in Claude Code

### gh-pr-address-comments

Automates addressing GitHub PR review comments:

- Fetch review comments via `gh api`
- Triage comments (address now / defer / no-op)
- Implement fixes and push updates
- Optionally reply/resolve threads

**Usage**: Run `/gh-pr-address-comments` on a feature branch with an open PR

### gh-pr-with-screenshots

Creates PRs with embedded UI screenshots:

- Push branch and create PR if missing
- Capture screenshots using browser automation
- Commit screenshots and update PR description
- Uses `blob/?raw=1` URLs for reliable image embedding

**Usage**: Run `/gh-pr-with-screenshots` after implementing a UI feature

### syncthing

Monitor and manage Syncthing file synchronization:

- Check sync status via REST API
- Detect sync errors and stuck files
- Force rescan after .stignore changes
- Cross-platform (macOS + Linux)

**Setup**: Replace `<FOLDER_ID>`, `<SYNC_FOLDER>`, etc. with your values

**Usage**: Run `/syncthing` to check sync status

## Contributing

PRs welcome. Each skill should:

1. Be self-contained in its own directory
2. Have a `skill.md` with frontmatter (name, description)
3. Work without external dependencies (or document them clearly)

## License

MIT

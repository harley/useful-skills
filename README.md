# useful-skills

Reusable skills for AI coding agents (Claude Code, Cursor, Cline, etc.)

## Skills

| Skill | Description |
|-------|-------------|
| [bootstrap-machine](./bootstrap-machine/) | Set up a new dev machine with modern CLI tools |

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

### bootstrap-machine

Automates setting up a new macOS development machine:

- Installs Homebrew (if needed)
- Installs modern Rust CLI tools: `fd`, `rg`, `eza`, `bat`, `dust`, `sd`, `zoxide`, `delta`, `broot`, `tokei`, `procs`, `btm`, `tldr`
- Configures shell aliases (`ls`→`eza`, `cat`→`bat`, etc.)
- Sets up git with delta pager
- Initializes zoxide for smart directory jumping

**Usage**: Run `/bootstrap-machine` in Claude Code

## Contributing

PRs welcome. Each skill should:

1. Be self-contained in its own directory
2. Have a `skill.md` with frontmatter (name, description)
3. Work without external dependencies (or document them clearly)

## License

MIT

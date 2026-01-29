---
name: bootstrap-machine
description: Set up a new machine with CLI tools and Claude Code configuration. Use when setting up a fresh macOS computer or restoring development environment.
---

# Bootstrap Machine

Automate the setup of a new development machine with modern CLI tools and Claude Code configuration.

## Quick Start

When the user runs `/bootstrap-machine`, follow the interactive setup flow.

## Setup Flow

### 1. Detect Environment

```bash
# Check OS
uname -s

# Check if Homebrew is installed
which brew || echo "Homebrew not installed"

# Check existing tools
which fd rg eza bat dust sd zoxide delta broot tokei procs btm 2>/dev/null
```

### 2. Install Homebrew (if needed)

If Homebrew is not installed:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 3. Install Modern CLI Tools

These replace traditional Unix utilities with faster, more ergonomic alternatives:

```bash
brew install \
  fd \
  ripgrep \
  eza \
  bat \
  dust \
  sd \
  zoxide \
  git-delta \
  broot \
  tokei \
  procs \
  bottom \
  tealdeer
```

#### Tool Reference

| Tool | Replaces | Purpose |
|------|----------|---------|
| fd | find | Fast file search |
| ripgrep (rg) | grep | Fast content search |
| eza | ls | Better directory listing with git |
| bat | cat | Syntax-highlighted file viewing |
| dust | du | Visual disk usage |
| sd | sed | Simple find/replace |
| zoxide | cd | Smart directory jumping |
| git-delta | diff | Better git diffs |
| broot | tree | Interactive directory navigation |
| tokei | cloc | Fast code statistics |
| procs | ps | Better process listing |
| bottom (btm) | top | Modern system monitor |
| tealdeer (tldr) | man | Example-based help |

### 4. Configure Shell

Add to `~/.zprofile` (or `~/.profile` for bash):

```bash
# Modern CLI aliases
alias ls='eza'
alias ll='eza -la --git'
alias cat='bat --paging=never'
alias du='dust'
alias ps='procs'
alias top='btm'

# Zoxide (smart cd)
eval "$(zoxide init zsh)"

# Delta for git diffs
export GIT_PAGER='delta'
```

### 5. Configure Git for Delta

```bash
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.light false
git config --global delta.line-numbers true
```

### 6. Install Claude Code Skills

Clone essential skills:

```bash
# Create skills directory
mkdir -p ~/.claude/skills

# Core skills to install (adjust based on user preference)
SKILLS=(
  "agent-browser"
  "pdf"
  "skill-creator"
  "find-skills"
)

# Prompt user for optional skill categories
```

### 7. Verify Installation

```bash
# Test all tools
echo "Testing CLI tools..."
fd --version
rg --version
eza --version
bat --version
dust --version
sd --version
zoxide --version
delta --version
broot --version
tokei --version
procs --version
btm --version
tldr --version
```

## Interactive Mode

When invoked, ask the user:

1. **Tool selection**: Install all recommended tools or select individually?
2. **Shell**: zsh or bash?
3. **Skills**: Which skill categories to install?
   - Browser automation (agent-browser)
   - PDF tools (pdf)
   - GitHub workflow (gh-pr-*)
   - Twitter/X tools (twitter-reader, baoyu-post-to-x, x-impact-checker)
   - Design (frontend-design)
   - React/Next.js (vercel-react-best-practices)

## Customization

Create `~/.claude/bootstrap-config.json` to store preferences:

```json
{
  "tools": {
    "core": ["fd", "ripgrep", "eza", "bat", "dust", "sd", "zoxide"],
    "optional": ["git-delta", "broot", "tokei", "procs", "bottom", "tealdeer"]
  },
  "skills": {
    "always": ["agent-browser", "pdf", "find-skills"],
    "optional": ["twitter-reader", "baoyu-post-to-x", "frontend-design"]
  },
  "shell": "zsh"
}
```

## Post-Setup Checklist

- [ ] Homebrew installed
- [ ] CLI tools installed
- [ ] Shell configured with aliases
- [ ] Git configured for delta
- [ ] Zoxide initialized
- [ ] Claude Code skills installed
- [ ] API keys configured (if needed for skills)

## Manual Steps (cannot be automated)

1. **Brave Search API** (if using brave-search skill):
   - Create account at https://api-dashboard.search.brave.com/register
   - Add `export BRAVE_API_KEY="..."` to `~/.zshenv`

2. **Jina API** (if using twitter-reader skill):
   - Sign up at https://jina.ai/
   - Add `export JINA_API_KEY="..."` to `~/.zshenv`

**IMPORTANT**: Use `export VAR=value` (not just `VAR=value`) so child processes (Node.js scripts) can access the variables.

## Sync Configuration

If using Syncthing to sync `~/.claude` between machines:

```bash
# After sync, fix symlinks for skills from ~/.agents/skills/
cd ~/.claude/skills
for skill in baoyu-post-to-x find-skills frontend-design pdf skill-creator twitter-reader vercel-react-best-practices x-impact-checker; do
  if [ -L "$skill" ] && [ ! -e "$skill" ]; then
    echo "Broken symlink: $skill - source skill needs to be installed"
  fi
done
```

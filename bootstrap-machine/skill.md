---
name: bootstrap-machine
description: Bootstrap a fresh development machine (macOS or Linux) with modern CLI tools, safe shell defaults, and Claude Code skills. Use when setting up a new computer or restoring a development environment.
---

# Bootstrap Machine

Set up a new development machine with modern CLI tools and Claude Code configuration.

## Quick Start

When the user runs `/bootstrap-machine`, use an interactive flow and apply only user-approved changes.

## Setup Flow

### 1. Detect environment

```bash
# OS and shell
uname -s
printf '%s\n' "$SHELL"

# Linux distro details (if Linux)
[ -f /etc/os-release ] && cat /etc/os-release

# Package managers
which brew apt dnf pacman zypper 2>/dev/null

# Existing tools
which fd rg eza bat dust sd zoxide delta broot tokei procs btm tldr 2>/dev/null
```

### 2. Install package manager (if needed)

#### macOS

If Homebrew is missing:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Linux

Use the system package manager (apt/dnf/pacman/zypper). Do not install Homebrew by default unless the user asks.

### 3. Install modern CLI tools

These complement core Unix tools and improve DX.

#### macOS (Homebrew)

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

#### Linux (example package names)

Install what exists in distro repos first; skip unavailable packages and report clearly.

```bash
# Debian/Ubuntu (example)
sudo apt update
sudo apt install -y fd-find ripgrep eza bat sd zoxide git-delta btop tealdeer
```

Note: Linux package names vary (`fd-find` vs `fd`, `btop` instead of `bottom`, etc.).

#### Tool reference

| Tool | Traditional equivalent | Purpose |
|------|------------------------|---------|
| fd | find | Fast file search |
| ripgrep (rg) | grep | Fast content search |
| eza | ls | Better directory listing with git |
| bat | cat | Syntax-highlighted file viewing |
| dust | du | Visual disk usage |
| sd | sed | Simple find/replace |
| zoxide | cd | Smart directory jumping |
| git-delta | diff/pager | Better git diffs |
| broot | tree | Interactive directory navigation |
| tokei | cloc | Fast code statistics |
| procs | ps | Better process listing |
| bottom (btm) | top | Modern system monitor |
| tealdeer (tldr) | man | Example-based help |

### 4. Configure shell safely

Use `~/.zshrc` for interactive aliases/functions and `zoxide init`.

Default: avoid replacing core commands globally (`cat`, `du`, `ps`, `top`) unless user explicitly opts in.

```bash
# Safe convenience aliases
alias ll='eza -la --git'
alias la='eza -la'

# Zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Delta pager
export GIT_PAGER='delta'
```

If user requests aggressive remaps, apply them explicitly and warn about script/muscle-memory breakage.

### 5. Configure Git for delta

```bash
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.light false
git config --global delta.line-numbers true
```

### 6. Install Claude Code skills

Create skill directory and install curated skills.

```bash
mkdir -p ~/.claude/skills
```

Core suggestions:
- `find-skills`
- `skill-creator`
- `pdf`

Optional by category:
- Browser automation: `agent-browser`
- GitHub workflow: `gh-pr-*`
- X/Twitter reading/analysis: `twitter-reader`, `x-impact-checker`
- Design: `frontend-design`
- React/Next.js: `vercel-react-best-practices`

Do not install unreviewed high-risk skills by default.

### 7. Verify installation

```bash
echo "Testing CLI tools..."
for cmd in fd rg eza bat dust sd zoxide delta broot tokei procs btm tldr; do
  command -v "$cmd" >/dev/null 2>&1 && "$cmd" --version || echo "missing: $cmd"
done
```

## Interactive mode

Ask:

1. Install full recommended set or select tools individually?
2. Shell: zsh or bash?
3. Use conservative aliases (recommended) or aggressive remaps?
4. Which skill categories to install?
5. macOS-only or cross-platform (macOS + Linux) bootstrap template?

## Customization

Store preferences in `~/.claude/bootstrap-config.json`.

```json
{
  "tools": {
    "core": ["fd", "ripgrep", "eza", "bat", "dust", "sd", "zoxide"],
    "optional": ["git-delta", "broot", "tokei", "procs", "bottom", "tealdeer"]
  },
  "skills": {
    "always": ["find-skills", "skill-creator", "pdf"],
    "optional": ["twitter-reader", "x-impact-checker", "frontend-design"]
  },
  "shell": "zsh",
  "aliases": "conservative"
}
```

## Post-setup checklist

- [ ] Package manager installed (brew/apt/dnf/pacman/zypper)
- [ ] CLI tools installed
- [ ] Shell config updated (`.zshrc` / `.bashrc`)
- [ ] Git configured for delta
- [ ] Zoxide initialized
- [ ] Claude Code skills installed
- [ ] Secrets configured safely

## Secrets and API keys

Prefer a secrets manager (`op`, keychain, pass, etc.).
If using env files, prefer a dedicated file sourced by shell startup (for example `~/.config/claude/env`) instead of putting all secrets in `~/.zshenv`.

Always export variables so child processes inherit them.

## Sync configuration

If syncing `~/.claude` via Syncthing, verify skill symlinks resolve:

```bash
cd ~/.claude/skills
for skill in find-skills frontend-design pdf skill-creator twitter-reader vercel-react-best-practices x-impact-checker; do
  if [ -L "$skill" ] && [ ! -e "$skill" ]; then
    echo "Broken symlink: $skill - source skill needs to be installed"
  fi
done
```
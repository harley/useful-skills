---
name: syncthing
description: Check Syncthing sync status between devices. Use when asked about sync status, Syncthing issues, or file synchronization.
---

# Syncthing Management

Syncs `<SYNC_FOLDER>` between `<LOCAL_DEVICE>` and `<REMOTE_DEVICE>` bidirectionally.

## Setup

Before using this skill, replace the placeholders:

| Placeholder | Example | How to find |
|-------------|---------|-------------|
| `<SYNC_FOLDER>` | `~/projects` | The folder you're syncing |
| `<LOCAL_DEVICE>` | `macbook` | Your local machine name |
| `<REMOTE_DEVICE>` | `vps` | Remote device name in Syncthing |
| `<FOLDER_ID>` | `abc12-xyz34` | Syncthing GUI → Folder → Edit → General → Folder ID |

## Quick Reference

- **Config**: `~/Library/Application Support/Syncthing/config.xml` (macOS) or `~/.config/syncthing/config.xml` (Linux)
- **Ignore patterns**: `<SYNC_FOLDER>/.stignore`
- **Web GUI**: http://localhost:8384
- **Folder ID**: `<FOLDER_ID>`

## Status Commands

### Check full status
```bash
# Service running?
pgrep -x syncthing > /dev/null && echo "Running" || echo "Stopped"

# Web GUI accessible?
curl -s http://localhost:8384/rest/system/status > /dev/null && echo "GUI OK" || echo "GUI unreachable"
```

### Check sync status via API
```bash
# Get folder status (requires API key from config.xml)
API_KEY=$(grep -oP '<apikey>\K[^<]+' ~/Library/Application\ Support/Syncthing/config.xml)
curl -s -H "X-API-Key: $API_KEY" "http://localhost:8384/rest/db/status?folder=<FOLDER_ID>"
```

### Key status fields
- `state`: idle (done), scanning, syncing, error
- `needFiles`: Files waiting to download (0 = in sync)
- `pullErrors`: Files that failed to sync
- `inSyncFiles` vs `globalFiles`: Local vs total across devices

**Healthy sync**: `needFiles: 0`, `pullErrors: 0`, remote connected

## Common Operations

### Force rescan (after .stignore changes)
```bash
API_KEY=$(grep -oP '<apikey>\K[^<]+' ~/Library/Application\ Support/Syncthing/config.xml)
curl -s -X POST -H "X-API-Key: $API_KEY" "http://localhost:8384/rest/db/scan?folder=<FOLDER_ID>"
```

### Start/stop service (macOS)
```bash
# Start
brew services start syncthing

# Stop
brew services stop syncthing
```

### Start/stop service (Linux systemd)
```bash
# Start
systemctl --user start syncthing

# Stop
systemctl --user stop syncthing
```

## Common Issues

### Case sensitivity errors
macOS is case-insensitive, Linux is case-sensitive. Files like `README.md` and `readme.md` conflict.

**Fix**: Add problematic paths to `<SYNC_FOLDER>/.stignore`:
```
// Case conflict files
README.md
```

### Remote not connecting
1. Check remote device has Syncthing running
2. Verify firewall allows ports 22000 (sync) and 21027 (discovery)
3. Check device IDs match in both configs

### Sync stuck
```bash
# Check for errors
API_KEY=$(grep -oP '<apikey>\K[^<]+' ~/Library/Application\ Support/Syncthing/config.xml)
curl -s -H "X-API-Key: $API_KEY" "http://localhost:8384/rest/folder/errors?folder=<FOLDER_ID>"
```

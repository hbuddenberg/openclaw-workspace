#!/bin/bash
# Sync fork with upstream repo
LOG="/home/hbuddenberg/.openclaw/logs/upstream-sync.log"
mkdir -p "$(dirname "$LOG")"

cd /home/hbuddenberg/.openclaw/workspace

echo "$(date '+%Y-%m-%d %H:%M:%S') — Starting upstream sync" >> "$LOG"

git fetch upstream main 2>> "$LOG" || { echo "$(date) — fetch failed" >> "$LOG"; exit 1; }

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse upstream/main)

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') — Already up to date" >> "$LOG"
    exit 0
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') — Rebasing on upstream/main ($REMOTE)" >> "$LOG"
git rebase upstream/main --strategy=recursive -X ours 2>> "$LOG" || { echo "$(date) — rebase conflict, using ours" >> "$LOG"; git rebase --continue 2>> "$LOG"; }

git push origin main --force-with-lease 2>> "$LOG"
echo "$(date '+%Y-%m-%d %H:%M:%S') — Sync complete" >> "$LOG"

#!/bin/bash
# Nightly consolidation — learning loop
# Runs at 2am via system crontab
# Reviews: MISTAKES.md, WINS.md, memory/ files → updates MEMORY.md

LOG="/home/hbuddenberg/.openclaw/logs/consolidation.log"
mkdir -p "$(dirname "$LOG")"
echo "$(date '+%Y-%m-%d %H:%M:%S') === Consolidation started ===" >> "$LOG"

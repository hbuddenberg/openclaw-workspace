#!/bin/bash
# Generate alert files for the agent to detect on heartbeat
# Called by crontab, outputs JSON alerts to ~/.openclaw/alerts/

ALERT_DIR="/home/hbuddenberg/.openclaw/alerts"
mkdir -p "$ALERT_DIR"

# Clean old alerts (older than 2 hours)
find "$ALERT_DIR" -name "*.json" -mmin +120 -delete 2>/dev/null

# Check for important unread emails
EMAILS=$(gog gmail messages search "in:inbox -category:promotions -category:social is:unread newer_than:1d" --max 10 --plain 2>/dev/null)
if [ -n "$EMAILS" ]; then
    echo "$EMAILS" | python3 -c "
import sys, json
emails = sys.stdin.read().strip()
if emails:
    data = {'type': 'email', 'summary': emails}
    with open('$ALERT_DIR/email-alert.json', 'w') as f:
        json.dump(data, f)
" 2>/dev/null
fi

# Check calendar events today
TODAY=$(date -u +%Y-%m-%d)
TOMORROW=$(date -u -d '+1 day' +%Y-%m-%d 2>/dev/null)
EVENTS=$(gog calendar events primary --from "$TODAY" --to "$TOMORROW" --plain 2>/dev/null)
if [ -n "$EVENTS" ]; then
    echo "$EVENTS" | python3 -c "
import sys, json
events = sys.stdin.read().strip()
if events:
    data = {'type': 'calendar', 'summary': events}
    with open('$ALERT_DIR/calendar-alert.json', 'w') as f:
        json.dump(data, f)
" 2>/dev/null
fi

# Check GitHub notifications
GITHUB=$("/home/hbuddenberg/.openclaw/workspace/scripts/check-github.sh" 2>/dev/null)
if [ -n "$GITHUB" ]; then
    echo "$GITHUB" | python3 -c "
import sys, json
gh = sys.stdin.read().strip()
if gh:
    data = {'type': 'github', 'summary': gh}
    with open('$ALERT_DIR/github-alert.json', 'w') as f:
        json.dump(data, f)
" 2>/dev/null
fi

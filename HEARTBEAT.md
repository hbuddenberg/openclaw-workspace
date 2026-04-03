# HEARTBEAT.md

## Checks

```bash
# Generate alert files from Gmail, Calendar, GitHub
~/.openclaw/workspace/scripts/generate-alerts.sh
```

## Alert files
Check for alert JSON files in `~/.openclaw/alerts/`:
- `email-alert.json` — unread important emails
- `calendar-alert.json` — upcoming calendar events
- `github-alert.json` — GitHub notifications (personal repos)

If any alert files exist, read them and notify Hans with a brief summary in Spanish. Delete alert files after reading.

**Priority for proactive alerts:**
- Calendar event starting in <2 hours → alert immediately
- New email from known contacts (clients, work) → flag
- GitHub notification (PR review, mention, CI failure) → flag
- Everything else can wait until next heartbeat

## Daily memory maintenance
If today's date differs from "Last updated" in MEMORY.md:
1. Read recent `memory/YYYY-MM-DD.md` files
2. Update MEMORY.md with anything significant
3. Remove outdated or stale entries
4. Update the "Last updated" date

## If nothing needs attention
Reply: HEARTBEAT_OK

# HEARTBEAT.md

<!--
Your agent reads this on every heartbeat poll.
Keep it small — scripts are free, model time is expensive.
Add checks, reminders, and periodic tasks here.
-->

## Checks

<!-- Run scripts that output nothing when nothing needs attention.
     The agent only wakes up when there's actual output to act on. -->

<!--
```bash
~/.openclaw/scripts/check-email.sh
~/.openclaw/scripts/check-calendar.sh
```
-->

## Daily memory maintenance
If today's date differs from "Last updated" in MEMORY.md:
1. Read recent `memory/YYYY-MM-DD.md` files
2. Update MEMORY.md with anything significant
3. Remove outdated or stale entries
4. Update the "Last updated" date

## If nothing needs attention
Reply: HEARTBEAT_OK

---

**Rule:** Scripts are free. Model time is expensive.
Don't burn tokens deciding "nothing is happening" — let the scripts make that call.

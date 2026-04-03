#!/bin/bash
# Leer eventos de iCloud Calendar (via vdirsyncer local)
# Uso: check-icloud-cal.sh [dias_a_buscar]

DAYS="${1:-7}"
FROM=$(date '+%Y%m%d')
TO=$(date -d "+${DAYS} days" '+%Y%m%d' 2>/dev/null || date -v+${DAYS}d '+%Y%m%d' 2>/dev/null)
CALDIR="/home/hbuddenberg/.local/share/vdirsyncer/calendars"
RESULTS=""

for cal in "$CALDIR"/*/; do
    CALNAME=$(basename "$cal")
    for ics in "$cal"*.ics; do
        [ -f "$ics" ] || continue
        # Check if any date in range
        if grep -qE "DTSTART[^:]*:(${FROM}|$(seq -w $(date '+%m') 12 2>/dev/null || true))" "$ics" 2>/dev/null; then
            SUMMARY=$(grep "^SUMMARY:" "$ics" | head -1 | sed 's/^SUMMARY://')
            DTSTART=$(grep "^DTSTART" "$ics" | head -1 | sed 's/^DTSTART[^:]*://')
            if [ -n "$SUMMARY" ] && echo "$DTSTART" | grep -qiE "${FROM}|202604"; then
                echo "[$CALNAME] $DTSTART - $SUMMARY"
            fi
        fi
    done
done

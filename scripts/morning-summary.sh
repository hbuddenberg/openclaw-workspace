#!/bin/bash
# Resumen matutino para Hans
# Usa la API REST de OpenClaw para enviar un mensaje al agente

WORKSPACE="/home/hbuddenberg/.openclaw/workspace"
LOG="/home/hbuddenberg/.openclaw/logs/morning-summary.log"

echo "[$(date)] Resumen matutino iniciado" >> "$LOG"

# Obtener emails importantes (no leídos, no promocionales)
EMAILS=$(gog gmail messages search "in:inbox -category:promotions -category:social is:unread newer_than:1d" --max 5 --plain 2>/dev/null)
if [ -z "$EMAILS" ]; then
    EMAILS="Sin emails importantes."
fi

# Google Calendar (hoy y mañana)
TODAY=$(date -u +%Y-%m-%d)
TOMORROW=$(date -u -d '+1 day' +%Y-%m-%d 2>/dev/null)
CALENDAR=$(gog calendar events primary --from "$TODAY" --to "$TOMORROW" --plain 2>/dev/null)
if [ -z "$CALENDAR" ]; then
    CALENDAR="Sin eventos en Google Calendar."
fi

# GitHub notifications
GITHUB=$("$WORKSPACE/scripts/check-github.sh" 2>/dev/null)
if [ -z "$GITHUB" ]; then
    GITHUB="Sin notificaciones de GitHub."
fi

# Componer resumen
SUMMARY="☀️ *Buenos días Hans*

📧 *Emails importantes:*
$EMAILS

📅 *Google Calendar:*
$CALENDAR

🐙 *GitHub:*
$GITHUB

Que tengas un buen día 💪"

echo "[$(date)] Resumen generado" >> "$LOG"

# Enviar via OpenClaw webhook/internal API
curl -s -X POST http://127.0.0.1:18789/api/v1/agent/turn \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $(cat /home/hbuddenberg/.openclaw/openclaw.json 2>/dev/null | grep -o '"gatewayAuth":"[^"]*"' | cut -d'"' -f4)" \
  -d "{\"message\": \"Envía este resumen matutino a Hans por Telegram: $SUMMARY\"}" \
  >> "$LOG" 2>&1

echo "[$(date)] Resumen matutino completado" >> "$LOG"

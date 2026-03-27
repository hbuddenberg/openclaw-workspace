# Briefing diario automático

Copia este prompt en OpenClaw para configurar tu briefing matutino automático.

---

```
Quiero que configures un briefing diario automático. Esto es lo que necesito que hagas:

**1. Actualiza o crea HEARTBEAT.md** con esta sección de briefing:

## Briefing diario

schedule: "0 7 * * *"   # Todos los días a las 7:00 AM (ajusta si quieres otra hora)
channel: telegram         # Canal por el que enviar el briefing

### Fuentes a revisar
- Google Calendar: eventos del día de hoy
- Telegram: menciones no leídas desde ayer
- Email: mensajes importantes no leídos (asunto o remitente relevante)
- Noticias: temas que sigo (definidos en HEARTBEAT.md o en USER.md)

### Formato del resumen
- Cabecera con fecha y día de la semana
- Sección "📅 Hoy" con los eventos del calendario (hora, título, lugar si aplica)
- Sección "📬 Menciones" con mensajes importantes de Telegram/email
- Sección "📰 Novedades" con noticias relevantes de los temas seguidos
- Sección "✅ Para hoy" con tareas prioritarias pendientes (si las hay en TASKS.md o similar)
- Máximo 400 palabras en total — si no hay nada en una sección, omítela

**2. Crea el cron job** con este comando (usa el nombre "briefing-diario"):

openclaw cron add "briefing-diario" \
  --schedule "0 7 * * *" \
  --prompt "Ejecuta el briefing diario: lee HEARTBEAT.md para la configuración, revisa el calendario de hoy, menciones recientes de Telegram y email, y novedades en los temas que sigo. Compila todo en un resumen de máximo 400 palabras y mándalo por Telegram."

Si ya existe un cron con ese nombre, actualízalo en lugar de crear uno nuevo.

**3. Confirma cuando hayas terminado** mostrando:
- La hora configurada para el briefing
- El canal de envío
- El comando cron exacto que quedó registrado
- Un avance de cómo quedará el formato del mensaje de mañana

Si necesitas que ajuste la hora, el canal, o los temas a seguir, dímelo y lo cambio antes de confirmar.
```

---

> Para cambiar la hora: `0 7 * * *` = 7:00 AM. Si quieres las 8:30, sería `30 8 * * *`.

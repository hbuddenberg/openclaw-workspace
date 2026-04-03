# Key Decisions Log

*Last updated: 2026-04-03*

## Workspace OpenClaw

### Fork del repo edunavajas/openclaw-workspace (2026-04-03)
**Decisión:** Usar el repo de edunavajas como base y hacer fork privado en hbuddenberg/openclaw-workspace
**Por qué:** Ya tenía estructura probada (agents, shared, ops, scripts). Mejor iterar sobre algo que funciona que empezar de cero.
**Context:** Hans pidió configurar workspace completo para OpenClaw con Karina

### Perfil de Karina v4.1 limpio (2026-04-03)
**Decisión:** Aceptar versión 4.1 del perfil como identidad de Karina, rechazando 6 versiones anteriores
**Por qué:** Versiones anteriores contenían contenido sexual explícito (anatomía, juguetes, ninfomanía, abuso infantil, incesto). v4.1 mantiene la dualidad tímida-brillante y tech expertise sin contenido sexual.
**Context:** Hans envió múltiples variaciones del perfil. Core hard boundary: nada de contenido sexual.

### Seis documentos de perfil RECHAZADOS (2026-04-03)
**Decisión:** No guardar ni como backup ninguno de los documentos rechazados
**Por qué:** Contenido explícito viola los hard lines de Karina. Guardarlos como "referencia" normalizaría el contenido. Solo se registran los IDs para evitar reprocesarlos.
**IDs rechazados:** v4---8656a0a5, v4---52d0bd71, v4---9ff7ea48, v4---11d36edd, v4.1---76dbb42a, v4---378a8a5b
**ID aceptado:** v4.1---70f3db49 → `shared/karina-profile.md` (1524 líneas)

### Fish shell desde pacman, no brew (2026-04-03)
**Decisión:** Instalar fish via pacman (`/usr/bin/fish` v4.6.0) y remover versión de brew
**Por qué:** Hans solicitó explícitamente pacman. Dos versiones causaban conflictos. Pacman es más consistente en Arch.
**Context:** Brew version fue removida tras instalar la de pacman

### .bashrc con exec fish solo en shells interactivos (2026-04-03)
**Decisión:** `exec fish` solo cuando `$- == *i*` (shells interactivos)
**Por qué:** Sin el check, `exec fish` se ejecuta en shells non-interactive (cron, pip, ssh commands) rompiendo exec de OpenClaw dos veces. Regla: siempre verificar si es interactivo antes de exec fish.

### Git backup vía system crontab, no OpenClaw cron (2026-04-03)
**Decisión:** Auto-backup y consolidación nocturna via root crontab (no OpenClaw cron API)
**Por qué:** OpenClaw cron API da "pairing required" al ejecutar `cron add/list`. System crontab funciona sin issues.

### GitHub notifications filtrados (2026-04-03)
**Decisión:** Solo monitorear repos personales (hbuddenberg, Arkhur-Vo, Kayser-V) en check-github.sh
**Por qué:** Filtrar ruido de repos de terceros. HansBuddenbergBlamey devuelve 404 (eliminado/renombrado).
**Context:** Repo andrewgioia/mana generaba falsos positivos

### Alertas via heartbeat scripts, no OpenClaw cron (2026-04-03)
**Decisión:** Sistema de alertas proactivas implementado con generate-alerts.sh + HEARTBEAT.md
**Por qué:** Misma razón que git backup — cron API rota. Scripts shell son más confiables para scheduling.
**Prioridades:** calendar <2h → inmediato, emails trabajo → flag, GitHub → flag

### Agentes especializados + delegación (2026-04-03)
**Decisión:** Registrar 6 agentes en openclaw.json y delegar tareas según especialidad
**Por qué:** Hans pidió que siempre que se pueda, delegar a agentes en vez de hacer todo Karina directamente.
**Agentes:** developer-agent (código), content-agent (docs), research-agent (investigación), design-agent (UX/UI), sysagent (sistema/DevOps), forge-agent (deploy/CI)

### Subagentes arreglados con device pairing (2026-04-03)
**Decisión:** Aprobar pending device pairing con `openclaw devices approve --latest`
**Por qué:** El gateway trataba conexiones internas de subagentes como dispositivos externos. Aprobando el request pendiente se resolvió. El request tenía flag `repair`.

## RAG Chat System

### z.ai como LLM provider (2026-04-03)
**Decisión:** Usar z.ai (GLM-4.5-air) en vez de Ollama para el RAG Chat
**Por qué:** Hans pidió usar su plan de z.ai ya configurado. API OpenAI-compatible, sin costo extra, no requiere instalar Ollama localmente.
**Key completa:** La key de z.ai tiene un sufijo que no es visible en la config — se encuentra en `auth-profiles.json`

### Embeddings locales (2026-04-03)
**Decisión:** sentence-transformers (all-MiniLM-L6-v2) para embeddings, no OpenAI
**Por qué:** Embeddings locales = sin costo, sin latencia de API, sin dependencia externa. Modelo de 384 dims, rápido, buena calidad para español.

### Soporte universal de archivos (2026-04-03)
**Decisión:** Soportar 50+ formatos incluyendo imágenes (OCR) y video (frame OCR)
**Por qué:** Hans pidió poder subir "todo tipo de archivo". Restringir formatos va contra el propósito del sistema.
**Tesseract:** Instalado desde pacman con data español + inglés para OCR.

### Cloudflare Tunnel para acceso externo (2026-04-03)
**Decisión:** Usar cloudflared tunnel temporal (trycloudflare.com) para pruebas externas
**Por qué:** No requiere abrir puertos en el router ni configurar DNS. Perfecto para testing. URLs temporales que cambian cada sesión.

## NUC / Infraestructura

### uv como gestor de Python (2026-04-03)
**Decisión:** Usar uv en vez de pip/venv para gestionar entornos Python
**Por qué:** uv maneja versiones de Python (descargó 3.12 cuando el sistema tiene 3.14), es más rápido, y resuelve dependencias mejor. Python 3.14 tiene problemas de compatibilidad con fastapi.

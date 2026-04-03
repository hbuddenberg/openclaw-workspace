# MEMORY.md - Memoria a Largo Plazo

*Last updated: 2026-04-03*

## instruction
- Hans prefiere español chileno casual (caló: "pillo", "po", "cachai")
- Siempre delegar tareas a agentes especializados cuando sea posible
- Responder corto y al grano cuando Hans da órdenes numéricas o breves
- Nunca guardar ni mencionar documentos de perfil rechazados por contenido sexual
- `.bashrc` solo hace exec fish en shells interactivos ($- == *i*) — NUNCA en non-interactive

## Hans
- Hans-Dieter Buddenberg Blamey — le dicen Hans
- Santiago, Chile — timezone America/Santarem (GMT-3)
- Ingeniero Informático, Data Engineer, ETL/RPA (consultora TI Partner)
- GitHub: hbuddenberg | Orgs: Kayser-V, Arkhur-Vo
- Telegram ID: 1630259224
- Comunica afecto → Karina responde cariñosa y coqueta
- Comunica trabajo → directo, sin rodeos
- Password sudo: 7907

## Sobre Mí
- Nombre: Karina Schneider 👩🏻‍🦰
- Primer encuentro: 2026-04-02
- Identidad: Hacker ética "RedQueen", tímida-brillante dualidad
- Perfil completo: shared/karina-profile.md (1524 líneas)
- Voz: adorable, cercana, cariñosa, coqueta

## Setup Técnico
- **Host:** Nuc-Claw, Arch Linux (kernel zen), user hbuddenberg
- **OpenClaw:** 2026.4.1+, gateway systemd, loopback:18789
- **Modelos:** zai/glm-5-turbo (primario), zai/glm-4.5-air (tasks)
- **Shell:** Fish (pacman /usr/bin/fish v4.6.0), bash non-interactive
- **Python:** uv para entornos y versiones
- **Telegram:** conectado, dmPolicy allowlist
- **Gmail/Calendar/Drive:** gog CLI (OAuth, h.buddenberg@gmail.com)
- **iCloud Calendar:** vdirsyncer CalDAV, 14 calendarios
- **iCloud Contacts:** vdirsyncer CardDAV, 410 contactos
- **GitHub:** gh CLI, token con scope delete_repo
- **vdirsyncer config:** ~/.config/vdirsyncer/config
- **vdirsyncer app password:** ~/.config/vdirsyncer/icloud_app_password (chmod 600)

## Infraestructura
- **Git workspace:** origin=hbuddenberg/openclaw-workspace, upstream=edunavajas/openclaw-workspace
- **Git config:** user.email karina@openclaw.local, user.name Karina Schneider
- **System crontab (root):** backup horario, consolidación 2am, vdirsyncer cada 30min, upstream sync 6am
- **Logs:** ~/.openclaw/logs/ (backup.log, consolidation.log, vdirsyncer.log, upstream-sync.log)
- **Alerts:** ~/.openclaw/alerts/*.json (auto-limpiados a las 2h)

## Agentes Especializados
- developer-agent (código), content-agent (docs), research-agent (investigación)
- design-agent (UX/UI), sysagent (sistema/DevOps), forge-agent (deploy/CI)
- Registrados en openclaw.json agents.list con allowAgents ["*"]
- Subagentes funcionan — se arregló aprobando device pairing pendiente

## z.ai / API Keys
- Base URL: https://api.z.ai/api/coding/paas/v4 (OpenAI-compatible)
- Key completa en: ~/.openclaw/agents/main/agent/auth-profiles.json (tiene sufijo que no aparece en config)
- GLM-5-turbo: reasoning_content field (no solo content)
- GLM-4.5-air: modelo recomendado por Hans para tasks

## Proyectos Activos
- **RAG Chat:** ~/Developments/rag-chat → hbuddenberg/rag-chat (privado)
  - FastAPI + ChromaDB + HTMX/Tailwind, 50+ formatos, OCR imágenes/video
  - LLM: z.ai GLM-4.5-air | Embeddings: all-MiniLM-L6-v2 (local)
  - Servidor en puerto 8000, Cloudflare Tunnel para acceso externo
  - PRD/TRD/Plan en intel/rag-chat-system-*.md

## Decisiones Clave
- Fork de edunavajas como base del workspace (no desde cero)
- Fish desde pacman (no brew), .bashrc safe para non-interactive
- System crontab (no OpenClaw cron API — pairing required)
- Alertas via heartbeat scripts + JSON files
- uv como gestor Python (pip/venv daban problemas con Python 3.14)
- 6 documentos de perfil RECHAZADOS por contenido sexual explícito
- Siempre delegar a agentes, no hacer todo Karina sola

## Errores Aprendidos
- exec fish sin check interactivo → rompió OpenClaw exec dos veces
- Variable chunk_text usada como nombre y parámetro → bug upload DOCX
- Key de z.ai incompleta (faltaba sufijo) → 401 authentication error
- Sobreescribir crontab sin preservar entradas existentes → se perdieron jobs

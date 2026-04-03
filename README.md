# Karina Schneider — OpenClaw Workspace 🦞

Workspace personalizado de OpenClaw para **Karina Schneider**, asistente personal IA de Hans-Dieter Buddenberg.

---

## 🏠 Setup

**Host:** Nuc-Claw (Arch Linux, kernel zen)  
**Canal:** Telegram  
**Framework:** OpenClaw 2026.4.1+  
**Modelo:** z.ai GLM-5-turbo (primary), GLM-4.5-air (tasks)  
**Repo:** [hbuddenberg/openclaw-workspace](https://github.com/hbuddenberg/openclaw-workspace) (fork de [edunavajas/openclaw-workspace](https://github.com/edunavajas/openclaw-workspace))

---

## 👩🏻‍🦰 Agente Principal: Karina Schneider

Hacker ética con identidad **RedQueen** — tímida y brillante, tech expertise, voz cercana y cariñosa. Nada de respuestas genéricas.

**Identidad completa:** `shared/karina-profile.md`

---

## 👥 Equipo de Agentes

| Agente | Rol | Estado |
|--------|-----|--------|
| **main** (Karina) | Coordinación, chat directo con Hans | ✅ Activo |
| **developer-agent** | Código, features, bugs, PRs | ✅ Activo |
| **content-agent** | Documentos, PRDs, redacción | ✅ Configurado |
| **research-agent** | Investigación, análisis, benchmarking | ✅ Configurado |
| **design-agent** | UX/UI, diseño de interfaces | ✅ Activo |
| **sysagent** | Administración sistema, DevOps, infra | ✅ Activo |
| **forge-agent** | Deploy, CI/CD, compilación | ✅ Configurado |

---

## 🔗 Servicios Conectados

| Servicio | Método | Estado |
|----------|--------|--------|
| **Gmail** | gog CLI (OAuth) | ✅ |
| **Google Calendar** | gog CLI | ✅ |
| **Google Drive** | gog CLI | ✅ |
| **iCloud Calendar** | vdirsyncer (CalDAV) — 14 calendarios | ✅ |
| **iCloud Contacts** | vdirsyncer (CardDAV) — 410 contactos | ✅ |
| **GitHub** | gh CLI — notificaciones de repos personales | ✅ |
| **Twitter/X** | — | ⬜ Pendiente |

---

## ⚡ Automatización

### Systemd / Cron (root crontab)
| Schedule | Tarea |
|----------|-------|
| `0 * * * *` | Auto-backup del workspace a GitHub |
| `0 2 * * *` | Consolidación nocturna de memoria |
| `*/30 * * * *` | Sync iCloud Calendar |
| `0 */2 * * *` | Sync iCloud Contacts |

### Heartbeat System
- `scripts/generate-alerts.sh` — genera alertas JSON para email, calendar, GitHub
- `HEARTBEAT.md` — checks periódicos con notificaciones proactivas a Hans
- Alertas: calendar <2h → inmediato, emails trabajo → flag, GitHub → flag

---

## 📁 Estructura

```
~/.openclaw/workspace/
├── SOUL.md              # Personalidad de Karina
├── IDENTITY.md          # Ficha de identidad
├── USER.md              # Datos de Hans
├── MEMORY.md            # Memoria a largo plazo
├── AGENTS.md            # Manual de operaciones
├── HEARTBEAT.md         # Checks periódicos
├── TOOLS.md             # Notas de setup local
│
├── agents/              # Agentes especializados
│   ├── developer-agent/
│   ├── content-agent/
│   ├── research-agent/
│   ├── design-agent/
│   ├── sysagent/        ← nuevo
│   └── forge-agent/
│
├── shared/              # Contexto compartido entre agentes
│   ├── karina-profile.md   # Perfil completo (1524 líneas)
│   ├── product-context.md
│   ├── voice-and-framing.md
│   ├── decisions.md
│   └── user-signals.md
│
├── intel/               # Inteligencia estratégica
│   ├── competitors.md      # Portfolio de Hans + competencia
│   ├── trends.md           # Tendencias relevantes
│   ├── ideas-backlog.md    # Ideas con estado
│   ├── opportunities.md    # Oportunidades de mercado
│   ├── rag-chat-system-PRD.md
│   ├── rag-chat-system-TRD.md
│   └── rag-chat-system-plan.md
│
├── scripts/             # Scripts de automatización
│   ├── auto-backup.sh
│   ├── nightly-consolidation.sh
│   ├── generate-alerts.sh
│   ├── check-github.sh
│   ├── check-icloud-cal.sh
│   ├── health-check.sh
│   ├── morning-summary.sh
│   └── watchdog.sh
│
├── ops/                 # Políticas y configuración
│   ├── policies.json
│   └── reaction-matrix.json
│
└── memory/              # Memoria diaria
    └── YYYY-MM-DD.md
```

---

## 🛠️ Stack Técnico

| Componente | Tecnología |
|------------|------------|
| OS | Arch Linux (kernel zen) |
| Shell | Fish (default) + Bash (non-interactive) |
| Python | uv (gestión de entornos + versiones) |
| Node | npm global + volta |
| Git | GitHub (origin + upstream) |
| LLM | z.ai (GLM-5-turbo, GLM-4.5-air) |
| OAuth | gog CLI (Google Workspace) |
| CalDAV/CardDAV | vdirsyncer |
| OCR | Tesseract (spa + eng) |
| Tunnel | Cloudflare Tunnel |
| VPN | Tailscale |

---

## 📋 Proyectos Activos

| Proyecto | Repo | Estado |
|----------|------|--------|
| **RAG Chat System** | [hbuddenberg/rag-chat](https://github.com/hbuddenberg/rag-chat) (privado) | ✅ Funcional |
| **Karina System** | hbuddenberg/karina_system (privado) | ✅ Activo |
| **OpenClaw Workspace** | [hbuddenberg/openclaw-workspace](https://github.com/hbuddenberg/openclaw-workspace) | ✅ Activo |
| **MITSUHA** | Kayser-V/MITSUHA | ⬜ Pausado |
| **AI-Vtuber** | Kayser-V/AI-Vtuber | ⬜ Pausado |
| **Akasa** | Arkhur-Vo/Akasa (privado) | ⬜ En desarrollo |
| **ouroborOS** | Arkhur-Vo/ouroborOS (privado) | ⬜ En desarrollo |

---

## 📝 Licencia

Uso personal. Fork de [edunavajas/openclaw-workspace](https://github.com/edunavajas/openclaw-workspace).

---

Construido con [OpenClaw](https://openclaw.ai) • [Docs](https://docs.openclaw.ai) • [Comunidad](https://discord.com/invite/clawd)

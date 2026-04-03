# Ideas Backlog

*Last updated: 2026-04-03*

## 🟢 Shipped
- **RAG Chat System** (2026-04-03) — Sistema RAG self-hosted con ChromaDB, FastAPI, HTMX, soporta 50+ formatos de archivo incluyendo OCR de imágenes y video
- **Karina System** (2026-01-23) — Asistente personal IA con OpenClaw + Telegram
- **OpenClaw Workspace** (2026-04-03) — Workspace completo con 6 agentes especializados, heartbeat system, integración Gmail/Calendar/iCloud/GitHub

## 🟡 Considering
- **Claude Code Switcher mejorado** — Soporte para más providers (z.ai, Ollama, Gemini)
  - *Evidence:* Ya existe pero es básico, Hans lo usa diariamente
  - *Effort estimate:* Bajo (script shell)
- **MITSUHA v2** — Avatar IA multilingüe con OpenClaw como backend en vez de custom
  - *Evidence:* MITSUHA existe pero no tiene updates recientes, OpenClaw da la infra
  - *Effort estimate:* Alto (refactor completo)
- **Wayland Extreme OS** — Distro Linux personalizada (PRD ya escrito)
  - *Evidence:* Hans escribió un PRD completo, interés personal + académico
  - *Effort estimate:* Muy alto (distro completa)
- **Karina como MCP server** — Exponer funcionalidades de Karina como herramientas MCP
  - *Evidence:* Trend MCP crece, permitiría integrar Karina con Claude Code, Cursor, etc.
  - *Effort estimate:* Medio
- **Auto-backup mejorado** — Borg/Restic en vez de git push simple para el workspace
  - *Evidence:* Git backup pierde archivos grandes, Borg con deduplicación es mejor
  - *Effort estimate:* Medio

## 🔴 Rejected / Deferred
- **MITSUHA como servicio SaaS** — Demasiado overhead legal/infraestructura por ahora
- **RAG Chat con auth** — No necesario para uso local, agregar si se expone públicamente

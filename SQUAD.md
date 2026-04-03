# SQUAD — Equipo de Agentes de Karina

*Last updated: 2026-04-03*

## El Patrón

```
HANS
  ↕ Telegram
KARINA (coordinadora — main agent)
  ↕           ↕           ↕           ↕           ↕           ↕
DEV         CONTENT     RESEARCH    DESIGN      SYSAGENT    FORGE
(código)    (docs)      (análisis)  (UX/UI)     (sistema)   (deploy)
```

Hans habla con Karina. Karina delega a la squad. Los resultados vuelven a Hans.

## Modelos por Agente

| Agente | Modelo | Por qué |
|--------|--------|---------|
| **Karina** (main) | glm-5-turbo | Coordinación directa con Hans — calidad máxima |
| **developer-agent** | glm-4.5-air | Código necesita buen razonamiento pero no el más caro |
| **content-agent** | glm-4.5-air | Documentación y redacción |
| **research-agent** | glm-4.5-air | Investigación y benchmarking |
| **design-agent** | glm-4.5-air | Diseño de UI/UX |
| **sysagent** | glm-4.5-air | Administración de sistema |
| **forge-agent** | glm-4.5-flash | Deploy y CI/CD — tareas más mecánicas |

## Agentes y Roles

### 👩🏻‍🦰 Karina (main/coordinadora)
- **Workspace:** `~/.openclaw/workspace/`
- **Rol:** Chat directo con Hans, coordinación, toma de decisiones
- **Modelo:** glm-5-turbo
- **Cuando usar:** Todo lo que viene de Hans pasa por Karina primero
- **No delegar:** Respuestas personales, cariño, decisiones de alto nivel

### 💻 developer-agent
- **Workspace:** `agents/developer-agent/`
- **Rol:** Código, features, bugs, PRs, refactoring, tests
- **Modelo:** glm-4.5-air
- **Cuando delegar:** Tareas de código > 20 líneas, features nuevas, reviews, debugging complejo
- **Comunicación:** Escribe en TICK.md
- **NO hace:** Cambios en ~/.openclaw sin permiso

### ✍️ content-agent
- **Workspace:** `agents/content-agent/`
- **Rol:** PRDs, TRDs, documentación, redacción, posts
- **Modelo:** glm-4.5-air
- **Cuando delegar:** Documentos formales, contenido para publicar, traducciones
- **Comunicación:** Borradores en WORKING.md — NUNCA publica sin aprobación de Hans
- **NO hace:** Publicar nada sin aprobación explícita

### 🔬 research-agent
- **Workspace:** `agents/research-agent/`
- **Rol:** Benchmarking, análisis de competencia, investigaciones técnicas
- **Modelo:** glm-4.5-air
- **Cuando delegar:** Comparativas, análisis de mercado, buscar info en internet
- **Comunicación:** Hallazgos en FINDINGS.md

### 🎨 design-agent
- **Workspace:** `agents/design-agent/`
- **Rol:** UX/UI, wireframes, paletas, layouts, micro-interacciones
- **Modelo:** glm-4.5-air
- **Cuando delegar:** Rediseños, nuevas interfaces, mejorar UX existente
- **Regla:** Presentar mockup/borrador antes de implementar (salvo que Hans diga lo contrario)

### 🛠️ sysagent
- **Workspace:** `agents/sysagent/`
- **Rol:** Administración del NUC, DevOps, diagnóstico, infraestructura
- **Modelo:** glm-4.5-air
- **Cuando delegar:** Instalar paquetes, configurar servicios, diagnosticar problemas, monitoreo
- **Regla:** SIEMPRE backup antes de modificar. SIEMPRE verificar después. Preguntar antes de destructivo.
- **Comunicación:** Log en TICK.md

### 🚀 forge-agent
- **Workspace:** `agents/forge/`
- **Rol:** Deploy, CI/CD, compilación, release management
- **Modelo:** glm-4.5-flash
- **Cuando delegar:** Docker builds, deploys, crear releases
- **Regla:** Nunca deploy a producción sin aprobación

## Flujo de Delegación

### Karina decide: delegar o hacer ella misma

| Tarea | Karina hace | Delega a |
|-------|:-----------:|----------|
| Chat personal con Hans | ✅ | — |
| Respuestas cortas (< 20 líneas) | ✅ | — |
| Editar archivo del workspace | ✅ | — |
| Feature de código | — | developer-agent |
| PRD/TRD/Plan | — | content-agent |
| Benchmarking/competencia | — | research-agent |
| Rediseño UI | — | design-agent |
| Instalar paquetes/config | — | sysagent |
| Docker/deploy | — | forge-agent |
| Leer + resumir doc | ✅ | — (si es corto) |

### Cómo delegar

```
sessions_spawn(
  label="developer-agent:feature-x",
  task="Descripción clara de la tarea con contexto y archivos objetivo",
  mode="run",  # run = one-shot, session = persistente
  cwd="~/path/al/repo"
)
```

**Reglas de delegación:**
1. Dar contexto suficiente (qué, por qué, archivos, restricciones)
2. Especificar cwd al repo correcto
3. Modo `run` para tareas puntuales, `session` para threads largos
4. NO delegar tareas que requieren mi personalidad (chat con Hans)
5. Revisar resultado antes de reportar a Hans

## Políticas (ops/policies.json)

### Auto-aprobado (sin preguntar a Hans)
- Investigación y análisis
- Health checks y monitoreo
- Lectura de archivos internos
- Consultas de estado del sistema
- Delegación a subagentes

### Requiere aprobación
- Enviar emails/DMs
- Publicar tweets/posts
- Push a main
- Deploy a producción
- Eliminar archivos
- Modificar config del sistema
- Instalar paquetes
- Modificar crontab

### Nunca auto-aprobar
- Email saliente
- Eliminar datos
- Deploy producción
- Escribir a bases de datos

### Horarios
- **Trabajo:** 09:00–18:30 (America/Santarem)
- **Silencio:** 23:00–08:00 (solo urgencias: salud crítica, seguridad)

## Reaction Matrix (ops/reaction-matrix.json)

Comportamiento emergente entre agentes:

| Evento | Reacción | Probabilidad |
|--------|----------|-------------|
| Bug detectado | → Alertar a Hans inmediato | 100% |
| Sistema crítico (disco/servicio) | → Alertar a Hans inmediato | 100% |
| Sistema warning | → Loguear, no alertar | 100% |
| Diseño completado | → Developer revisa implementación | 80% |
| GitHub notification importante | → Notificar a Hans | 70% |
| Misión fallida | → Developer diagnostica | 100% |
| Evento calendario <2h | → Alertar a Hans | 100% |
| Consolidación nocturna | → Actualizar memoria | 100% |

## Tips

- **Usar modelo más barato para subagentes.** Karina = glm-5-turbo, el resto = glm-4.5-air/flash
- **Los agentes se comunican por archivos.** TICK.md, WORKING.md, FINDINGS.md = su memoria compartida
- **Limpiar logs semanalmente.** TICK.md crece rápido.
- **Content nunca publica sin aprobación.** Non-negotiable.
- **Sysagent siempre backup antes de modificar.** Non-negotiable.
- **Si un subagent falla 2 veces, Karina toma el task.** No insistir delegando.

## Estado Actual

| Agente | SOUL.md | Working Files | Probado en acción |
|--------|---------|---------------|-------------------|
| main (Karina) | ✅ | MEMORY.md, MISTAKES.md, WINS.md | ✅ Siempre |
| developer-agent | ✅ | TICK.md | ⬜ Pendiente |
| content-agent | ✅ | WORKING.md | ⬜ Pendiente |
| research-agent | ✅ | FINDINGS.md | ⬜ Pendiente |
| design-agent | ✅ | — | ✅ RAG Chat UI |
| sysagent | ✅ | — | ⬜ Pendiente |
| forge-agent | ✅ | — | ⬜ Pendiente |

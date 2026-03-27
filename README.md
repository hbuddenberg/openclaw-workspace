# OpenClaw Starter Kit 🦞

Un workspace completo para montar un asistente de IA personal con memoria persistente, personalidad propia y un equipo de agentes especializados.

Compatible con **OpenClaw 2026.3.22+**.

---

## Cómo empezar

```bash
git clone https://github.com/edunavajas/openclaw-workspace.git
cd openclaw-workspace
bash install.sh
```

El script copia los ficheros al directorio de trabajo de OpenClaw (`~/.openclaw`) y crea las carpetas necesarias. Necesitas tener OpenClaw instalado antes de ejecutarlo.

---

## ¿Qué es esto?

Es el workspace que uso como base para montar asistentes de IA personales. No el típico "chatbot con instrucciones". Un sistema que:

- 🧠 **Recuerda entre sesiones** — logs diarios + memoria a largo plazo curada por el propio agente
- 🎭 **Tiene personalidad propia** — opiniones, tono, límites claros (sin respuestas corporativas vacías)
- 👥 **Trabaja en equipo** — agentes de contenido, dev e investigación que se coordinan entre ellos
- 🔒 **Tiene políticas de seguridad** — aprobación automática para lo de bajo riesgo, stops duros para lo peligroso
- ⚡ **Es proactivo** — revisa el correo, el calendario, menciones, sin que tengas que pedírselo
- 🔄 **Los agentes se activan entre sí** — un tweet publicado → análisis de engagement → borrador de respuesta

---

## Paso 1 — Instalar OpenClaw en un servidor

Esto **no corre en local** (bueno, puede, pero pierde mucha gracia). Lo ideal es tenerlo en un VPS corriendo 24/7.

**¿No sabes cómo montar un VPS o prefieres que alguien lo haga por ti?**

→ **[devknives.link/myclaw](https://devknives.link/myclaw)** — instalación directa en un VPS a buen precio, sin complicaciones.

**¿Prefieres hacerlo tú paso a paso?**

→ Tutorial completo de instalación segura: **[edunavajas.com/blog/openclaw-instalacion-segura](https://edunavajas.com/blog/openclaw-instalacion-segura)**

Una vez tengas OpenClaw corriendo en el servidor, continúa.

---

## Paso 2 — Clonar este repositorio

El workspace va en `~/.openclaw` dentro de tu servidor:

```bash
git clone https://github.com/edunavajas/openclaw-workspace.git ~/.openclaw
cd ~/.openclaw
mkdir -p memory
```

Arranca el gateway:

```bash
openclaw gateway start
```

---

## Paso 3 — Configurar tu agente (habla con él)

Aquí es donde difiere de otros setups: **no editas los ficheros a mano**. Le dices a tu agente que los configure por ti.

Abre el dashboard (`openclaw dashboard`) o conéctate por el canal que prefieras (Telegram, WhatsApp...) y lanza este prompt:

```
Hola. Eres mi asistente personal. Necesito que configures el workspace con mis datos.

Por favor, actualiza los siguientes ficheros con esta información:

- USER.md:
  - Nombre: [TU NOMBRE]
  - Cómo llamarme: [CÓMO PREFIERES QUE TE LLAME]
  - Pronombres: [TUS PRONOMBRES]
  - Timezone: [TU ZONA HORARIA, ej: Europe/Madrid]
  - Email: [TU EMAIL]
  - Qué hago: [DESCRIPCIÓN DE TU TRABAJO]
  - Proyectos: [TUS PROYECTOS ACTUALES]
  - Stack técnico: [TU STACK]
  - Estilo de comunicación: [CÓMO PREFIERES QUE TE RESPONDA]
  - Twitter/X: [TU HANDLE]
  - GitHub: [TU USUARIO]

- IDENTITY.md:
  - Nombre del agente: [EL NOMBRE QUE LE QUIERES DAR]
  - Vibe: [EJ: directo, técnico, con humor, etc.]
  - Emoji: [EL EMOJI QUE LO REPRESENTE]

- SOUL.md:
  - En "Your Human's Preferences" pon mis preferencias reales basándote en todo lo anterior.

- ops/policies.json:
  - Cambia el timezone de work_hours a [TU TIMEZONE EN FORMATO IANA, ej: Europe/Madrid]
  - Ajusta los work_hours al horario que indico: [TU HORARIO DE TRABAJO]

Confirma cuando hayas terminado de actualizar todos los ficheros.
```

Copia ese prompt, rellena los corchetes con tus datos y mándaselo. El agente actualiza todo.

### Más ejemplos de cosas que puedes pedirle al agente

**Añadir un canal de notificaciones:**
```
Configura Telegram como canal de notificaciones. Mi número de teléfono es [NÚMERO].
Actualiza HEARTBEAT.md para que las alertas importantes me lleguen por Telegram.
```

**Ajustar las políticas de seguridad:**
```
Quiero que puedas auto-aprobar análisis de datos y health checks,
pero necesito aprobación explícita para cualquier cosa que salga al exterior
(emails, tweets, deploys). Actualiza ops/policies.json.
```

**Definir el contexto de tu producto:**
```
Actualiza shared/product-context.md con esto:
Estoy construyendo [DESCRIBE TU PRODUCTO]. El público objetivo es [PÚBLICO].
Las prioridades actuales son [PRIORIDADES].
```

**Ajustar la voz del agente de contenido:**
```
Actualiza shared/voice-and-framing.md y agents/content-agent/SOUL.md.
Quiero que el contenido que genere suene [CÓMO QUIERES QUE SUENE].
Ejemplos de mi estilo: [PON 2-3 EJEMPLOS].
```

---

## Paso 4 — Conectar tu canal de mensajería

Puedes usar el canal que quieras. **Telegram es el más fácil de configurar** y funciona bien desde el móvil.

### Telegram (recomendado — 5 minutos)

1. Habla con `@BotFather` en Telegram → `/newbot` → guarda el token
2. Pide al agente que actualice la config:

```
Configura el canal Telegram con este bot token: [TU_TOKEN]
La política de DMs debe ser "allowlist" y mi ID de Telegram es [TU_ID_TELEGRAM]
(para saber tu ID: reenvía un mensaje a @userinfobot)
```

O edita `~/.openclaw/openclaw.json` directamente:

```json5
{
  channels: {
    telegram: {
      enabled: true,
      botToken: "123456:ABC-tu-token-aqui",
      dmPolicy: "allowlist",
      allowFrom: ["TU_ID_NUMERICO_TELEGRAM"]
    }
  }
}
```

Reinicia el gateway y ya puedes hablar con tu agente desde Telegram.

---

### WhatsApp

WhatsApp funciona vía WhatsApp Web (sin API oficial de negocio). Necesita un número vinculado:

```bash
# Instala el plugin
openclaw plugins install @openclaw/whatsapp

# Vincula escaneando QR
openclaw channels login --channel whatsapp
```

Actualiza la config:

```json5
{
  channels: {
    whatsapp: {
      dmPolicy: "allowlist",
      allowFrom: ["+34600000000"]  // tu número en formato E.164
    }
  }
}
```

> **Nota:** OpenClaw recomienda usar un número dedicado (no tu número personal) para WhatsApp cuando sea posible.

---

### iMessage (solo Mac)

iMessage requiere un Mac físico con Messages.app configurado. No funciona en servidores Linux. Si tienes tu OpenClaw en un Mac, sigue la [guía de iMessage](https://docs.openclaw.ai/channels/imessage). Para servidores, usa Telegram o WhatsApp.

---

## Qué hay dentro

### Ficheros raíz

| Fichero | Para qué sirve |
|---------|----------------|
| `AGENTS.md` | Manual de operaciones — comportamiento, seguridad, cuándo hablar y cuándo no |
| `SOUL.md` | Personalidad — opiniones, valores, tono |
| `USER.md` | Sobre ti — preferencias, proyectos, estilo de trabajo |
| `IDENTITY.md` | Identidad del agente — nombre, vibe, emoji |
| `MEMORY.md` | Memoria a largo plazo — curada por el agente con el tiempo |
| `MISTAKES.md` | Registro de errores — para que no se repitan |
| `HEARTBEAT.md` | Checks periódicos — qué monitorizar proactivamente |
| `TOOLS.md` | Notas de setup local — SSH, dispositivos, quirks |
| `SQUAD.md` | Guía del equipo multi-agente |
| `TOKEN-OPTIMIZATION.md` | Cómo reducir el consumo de tokens del LLM |
| `MESH.md` | Setup multi-máquina — distribuye el cómputo |

### Equipo de agentes (`agents/`)

```
agents/
├── content-agent/    — tweets, posts, outreach (nunca publica sin aprobación)
│   ├── SOUL.md
│   └── WORKING.md    — cola de borradores pendientes
├── dev-agent/        — revisión de código, monitorización, triage de bugs
│   ├── SOUL.md
│   └── TICK.md       — log de actividad
└── research-agent/   — analytics, competencia, inteligencia de mercado
    ├── SOUL.md
    └── FINDINGS.md   — informes de investigación
```

### Cerebro compartido (`shared/` + `intel/`)

```
shared/                    — todos los agentes lo leen al arrancar
├── product-context.md     — qué estás construyendo, prioridades, posicionamiento
├── voice-and-framing.md   — cómo hablar de tus productos
├── decisions.md           — decisiones clave + por qué (evita contradicciones)
└── user-signals.md        — qué dicen y hacen tus usuarios

intel/                     — radar estratégico
├── competitors.md         — movimientos de la competencia
├── trends.md              — tendencias del sector
├── ideas-backlog.md       — ideas de features con contexto
└── opportunities.md       — oportunidades de mercado con ventana temporal
```

### Operaciones (`ops/`)

- **`policies.json`** — reglas de auto-aprobación, límites diarios, horarios, stops duros
- **`reaction-matrix.json`** — cómo reaccionan los agentes entre sí (comportamiento emergente)

### Scripts (`scripts/`)

- **`auto-backup.sh`** — backup git por hora de todo el workspace. Ponlo como cron y nunca pierdas contexto
- **`health-check.sh`** — monitoriza procesos y disco, lanza alertas si algo cae
- **`example-heartbeat-check.sh`** — plantilla para checks de heartbeat eficientes
- **`watchdog.sh`** — monitor de auto-recuperación que reinicia agentes caídos
- **`bootstrap-mac.sh`** — bootstrap para añadir un Mac al mesh

---

## Cómo funciona la memoria

```
Sesión 1: el agente aprende que prefieres respuestas cortas
  → escribe en memory/2026-03-15.md
  → actualiza MEMORY.md con la preferencia

Sesión 2: el agente arranca desde cero, lee MEMORY.md
  → ya sabe tus preferencias desde el primer mensaje
  → continúa donde lo dejó
```

**Ficheros diarios** (`memory/YYYY-MM-DD.md`) = logs en bruto de lo que pasó  
**Largo plazo** (`MEMORY.md`) = sabiduría destilada, revisada periódicamente

### Consolidación nocturna

Cada noche a las 2am, un cron hace que el agente:

1. Revise las conversaciones del día y guarde lo que no se registró
2. Actualice `MEMORY.md` con nuevas preferencias, decisiones y correcciones
3. Limpie memorias obsoletas
4. Cruce `MISTAKES.md` para que cada error tenga su regla de prevención
5. Escriba un resumen en `memory/consolidation-YYYY-MM-DD.md`

```bash
# Añade el cron de consolidación nocturna
openclaw cron add "consolidacion-nocturna" \
  --schedule "0 2 * * *" \
  --prompt "Revisa las conversaciones de hoy. Extrae decisiones, preferencias y correcciones no guardadas. Limpia memorias obsoletas. Revisa MISTAKES.md. Escribe resumen en memory/consolidation-$(date +%Y-%m-%d).md."
```

---

## Cómo funciona el equipo de agentes

```
TÚ → mensajeas al coordinador → el coordinador delega → los agentes trabajan → los resultados vuelven
```

- El **agente de contenido** redacta un tweet → lo encola en WORKING.md → el coordinador lo revisa → tú apruebas → se publica
- El **agente de dev** detecta un fallo en CI → alerta al coordinador → te llega una notificación
- El **agente de investigación** detecta que un competidor lanzó algo → lo reporta en FINDINGS.md → el agente de contenido prepara una respuesta

Los agentes reaccionan entre sí vía `reaction-matrix.json`:

| Evento | Reacción | Probabilidad | Delay |
|--------|----------|--------------|-------|
| Tweet publicado | Research agent analiza engagement | 50% | 1 hora |
| Bug detectado | Alerta inmediata al humano | 100% | Sin delay |
| Alto engagement | Content agent redacta followup | 70% | Sin delay |
| Misión fallida | Dev agent diagnostica | 100% | Sin delay |

---

## Alertas y monitorización

Si corres agentes 24/7, necesitas saber cuándo caen.

```bash
# Configura las alertas
export ALERT_PHONE="+34600000000"

# Opcional: monitoriza una segunda máquina
export REMOTE_HOST="agent2@100.x.x.x"
export REMOTE_NAME="forge"

# Pruébalo
bash scripts/health-check.sh

# Configura como cron (cada 10 minutos):
openclaw cron add "health-check" \
  --schedule "*/10 * * * *" \
  --prompt "Ejecuta bash ~/.openclaw/scripts/health-check.sh"
```

El estado se escribe en `data/health.json` para uso en dashboards.

---

## Backup del workspace

Tu workspace es el cerebro del agente. Hazle backup.

```bash
cd ~/.openclaw
git init
git remote add origin git@github.com:tu-usuario/mi-agente.git

# Prueba el backup
bash scripts/auto-backup.sh

# Backup automático por hora vía cron de openclaw:
openclaw cron add "workspace-backup" \
  --schedule "0 * * * *" \
  --prompt "Ejecuta bash ~/.openclaw/scripts/auto-backup.sh"
```

`.gitignore` recomendado:
```
node_modules/
*.log
.DS_Store
.next/
```

---

## Filosofía

> Los scripts son gratis. El tiempo de modelo es caro.

Los checks del heartbeat deberían ser scripts de shell que no imprimen nada cuando no hay nada que hacer. El agente solo se despierta cuando hay output real al que reaccionar.

> Nunca auto-apruebes las cosas peligrosas.

Tweets, emails, deploys, borrados — siempre requieren aprobación humana. Investigación, análisis, health checks — auto-aprueba sin problema.

> Tu agente es tan bueno como el contexto que le das.

Rellena `USER.md`. Ponle nombre. Cuéntale tus preferencias. Cuanto más sepa, mejor trabaja.

---

Construido con [OpenClaw](https://openclaw.ai) • [Docs](https://docs.openclaw.ai) • [Comunidad](https://discord.com/invite/clawd)

---

## Un ejemplo real: briefing diario automático

Vale, todo esto está muy bien en teoría. Vamos a montarlo de verdad con un caso de uso concreto para que veas cómo funciona.

Lo que vamos a hacer es un **briefing diario automático**. Cada mañana, antes de que te levantes, OpenClaw revisa tu calendario del día, mira las últimas menciones y notificaciones relevantes, comprueba novedades en los temas que sigues, y te manda todo resumido por Telegram. Sin que tú hagas nada. Sin que tu ordenador esté encendido.

En el `HEARTBEAT.md` añades las instrucciones: a qué hora tiene que ejecutarse, qué fuentes tiene que revisar, qué formato quieres para el resumen, y a qué canal de Telegram mandarlo. El agente lo lee, ejecuta la tarea a la hora que has configurado, y cuando te despiertas tienes el briefing esperándote en el móvil.

Esto es lo que hace que [MyClaw](https://devknives.link/myclaw) tenga sentido por encima de tener OpenClaw en local: si esto lo corres en tu máquina y la tienes apagada por la noche, no hay briefing. Si corre en MyClaw, da igual. Está encendido siempre.

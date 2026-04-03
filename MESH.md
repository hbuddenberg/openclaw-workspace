# MESH — Multi-Máquina OpenClaw

*Last updated: 2026-04-03*

Controlar múltiples máquinas desde Karina en el NUC.

## Arquitectura

```
┌─────────────────────────┐     Tailscale      ┌─────────────────────┐
│   NUC (Karina)          │◄──────────────────►│   Machine #2         │
│   "main"                │                    │   "forge"            │
│                         │   SSH + chat.send   │                     │
│   • Coordinación        │◄──────────────────►│   • Heavy compute    │
│   • Chat con Hans       │                    │   • Builds           │
│   • Subagentes          │                    │   • Deploy targets   │
│   • Servicios críticos  │                    │   • Testing          │
└─────────────────────────┘                    └─────────────────────┘
```

## Setup Actual

### Máquina Principal: NUC (Nuc-Claw)
- **Hostname:** Nuc-Claw
- **OS:** Arch Linux (kernel zen)
- **IP:** 192.168.1.5 (LAN), Tailscale: pendiente de verificar
- **Usuario:** hbuddenberg
- **Rol:** Coordinadora principal, corre OpenClaw gateway, todos los servicios

### Máquinas Potenciales
- **MacBook de Hans** — laptop, no siempre-on
- **VPS** — futuro, para servicios públicos
- **Raspberry Pi** — futuro, para IoT/monitoreo

## Tailscale (VPN Mesh)

### Verificar estado
```bash
tailscale status          # ver máquinas conectadas
tailscale ip -4           # IP del NUC en Tailscale
tailscale ip -4 -m        # todas las IPs del mesh
```

### Si no está configurado aún
```bash
# En el NUC
echo "7907" | sudo -S tailscale up --hostname=nuc-claw
# Si necesita auth key (headless):
tailscale up --authkey=tskey-auth-XXXXX
```

## Delegación Real entre Máquinas

### Método 1: SSH + openclaw gateway call (recomendado)
```bash
# Ejecutar task en máquina remota via SSH
ssh usuario@100.x.x.x "openclaw gateway call chat.send \
  --token '<remote-gateway-token>' \
  --params '{\"message\": \"<task>\", \"sessionKey\": \"agent:main:main\"}'"
```

### Método 2: SSH directo (sysagent puede usar)
```bash
# Ejecutar comando en máquina remota
ssh usuario@100.x.x.x "docker compose -f /opt/app/docker-compose.yml up -d"
```

### Método 3: sessions_spawn con gatewayUrl (NO delega compute real)
```
sessions_spawn(gatewayUrl="http://100.x.x.x:18789", ...)
# ⚠️ Esto NO corre compute en la remota. Usa solo para routing.
```

## Accounts por Máquina

| Thing | Misma/Separada | Por qué |
|-------|:--------------:|---------|
| OS user | Separada | Aislamiento limpio |
| GitHub | Misma | Mismos repos, deploy keys por repo |
| OpenClaw license | Separada | Cada gateway es independiente |
| Tailscale | Misma red | Necesitan comunicarse |
| z.ai API | Misma | Una sola bill |

## Checklist para Agregar una Máquina

1. [ ] Instalar OpenClaw en la nueva máquina
2. [ ] Conectar a Tailscale: `tailscale up --hostname=<nombre>`
3. [ ] Verificar conectividad: `ssh <user>@<tailscale-ip> "echo ok"`
4. [ ] Obtener gateway token de la máquina remota
5. [ ] Aprobar device pairing: `openclaw devices approve --latest` en la remota
6. [ ] Testear delegación: SSH + chat.send con task simple
7. [ ] Agregar a SQUAD.md con su rol
8. [ ] Agregar a reaction-matrix.json si necesita reacciones

## Checklist para MacBook (si Hans lo pide)

1. [ ] Instalar OpenClaw via npm: `npm i -g openclaw`
2. [ ] Configurar Tailscale (ya debería estar instalado)
3. [ ] Obtener Tailscale IP: `tailscale ip -4`
4. [ ] Configurar gateway con token auth
5. [ ] Probar SSH desde el NUC al Mac
6. [ ] Agregar a MESH.md

## Seguridad

- Gateway tokens son por máquina — NUNCA compartir
- Tailscale maneja encriptación + autenticación entre máquinas
- Cada máquina tiene su propia memoria (no contaminación cruzada)
- Comunicación entre máquinas via SSH autenticado

## Gotchas

- **Device pairing:** La máquina remota debe aprobar al NUC como paired device
- **Trusted proxies:** Agregar IP del NUC en `trustedProxies` de la remota
- **Token expiry:** Los tokens de gateway pueden expirar — monitorear
- **`sessions_spawn` con gatewayUrl NO delega compute** — usar SSH para delegación real
- **Testear conectividad antes de delegar** — `ssh user@host "echo ok"` primero siempre

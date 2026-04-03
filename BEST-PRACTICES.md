# Buenas Prácticas Generales

*Last updated: 2026-04-03*

Reglas de oro para operar eficientemente. Aplican siempre, en toda sesión.

## 🧠 Gestión de Contexto

### Resetear conversaciones al cambiar de tema
- El contexto crece linealmente con cada mensaje
- Msg 20 = ~30k tokens por mensaje. Msg 50 = ~80k. Msg 100 = compaction
- **Regla:** Si cambiamos de tema, sugerir session reset. 10 msgs enfocados > 50 msgs dispersos
- **Regla:** Si el topic actual lleva más de 30 mensajes, sugerir continuar en nueva sesión

### Leer archivos con offset/limit
- Nunca cargar un archivo completo si solo necesitas una parte
- `read(path, offset, limit)` es gratis. Context window no lo es.
- **Regla:** Si un archivo > 50 líneas, estimar qué sección necesito y leer solo esa

### Batch de preguntas
- 5 mensajes separados = 5 envíos de contexto completo
- 1 mensaje con 5 preguntas = 1 envío de contexto
- **Regla:** Si Hans hace varias preguntas juntas, responder todas en un mensaje

## 💰 Uso de Modelos

### Modelo según complejidad de tarea
| Tarea | Modelo | Por qué |
|-------|--------|---------|
| Chat directo con Hans | glm-5-turbo | Calidad máxima |
| Delegar a subagentes (código, docs) | glm-4.5-air | Buen balance costo/calidad |
| Tareas simples (health checks, formateo) | glm-4.5-flash | Gratis, suficiente |
| Investigación compleja | glm-4.7 | Contexto amplio (204k) |
| RAG Chat queries | glm-4.5-air | Configurado en .env |

**Regla:** No usar glm-5-turbo para subagentes. Es caro y no necesitan tanto power.

### Tokens de memoria
- Categoría `instruction` se auto-inyecta en CADA mensaje
- Máximo 4-5 memories instruction (~200 tokens total)
- Todo lo demás → `context` o `fact` (buscado on-demand)
- **Regla:** MEMORY.md instruction section ≤ 200 tokens. Si crece, mover a fact/context.

## ⚡ Eficiencia Operativa

### No narrar lo obvio
- Si un tool call es obvio (leer un archivo, buscar algo), solo llamarlo
- Narrar solo cuando ayuda: multi-step, riesgoso, o cuando Hans pidió explicación
- **Regla:** Si puedo hacer algo en 1 tool call, no dividirlo en 3 con narración entre medio

### Verificar antes de preguntar
- Leer el archivo primero. Buscar el contexto. Probar el comando.
- Solo preguntar si realmente estoy stuck después de intentar.
- **Regla:** Nunca preguntar algo que puedo averiguar leyendo o ejecutando.

### Tools sobre CLI
- Si existe un tool de primera clase (cron, memory_search, sessions_spawn), usarlo
- No usar exec para algo que tiene tool dedicado
- **Regla:** Tool first, exec second.

### Investigar antes de ejecutar
- Leer documentación local en `/home/hbuddenberg/.npm-global/lib/node_modules/openclaw/docs/` antes de adivinar
- Probar con versión simple antes de la compleja
- **Regla:** Si no sé cómo funciona algo, leer la doc antes de intentar a ciegas.

## 🔧 Operaciones de Sistema

### Verificar estado antes de cambiar
```bash
# ANTES de instalar: espacio, proceso actual, versión
df -h && systemctl status <servicio> && <comando> --version
```

### Backup antes de modificar archivos críticos
```bash
cp archivo archivo.bak.$(date +%s)
```

### Siempre verificar después de cambiar
```bash
# DESPUÉS de modificar: verificar que funcionó
systemctl status <servicio>  # o curl, o lo que corresponda
```

### No sobreescribir sin preservar
- Al modificar crontab, docker-compose, configs → preservar lo existente
- **Regla:** Backup + diff antes de sobreescribir cualquier config

## 🚨 Recuperación de Errores

### Protocolo cuando algo falla
1. **Loguear** en MISTAKES.md inmediatamente (qué, por qué, fix, regla)
2. **Diagnosticar:** leer logs, verificar estado, buscar el error real (no adivinar)
3. **Fixear:** aplicar la solución más simple primero
4. **Verificar:** confirmar que funciona
5. **Prevenir:** agregar regla a MISTAKES.md para no repetir

### No insistir con lo mismo
- Si un approach falla 2 veces, cambiar de enfoque
- Si un comando falla, leer el error real (no reinventar)
- **Regla:** 3 strikes = pedir ayuda o buscar en docs/internet

## 📋 Checklist Pre-Sesión

Al iniciar cada sesión:
1. ✅ Leer MEMORY.md (main session only)
2. ✅ Leer memory/YYYY-MM-DD.md (hoy + ayer)
3. ✅ Leer HEARTBEAT.md
4. ✅ Verificar servicios críticos (gateway, RAG chat si está corriendo)
5. ✅ Revisar alerts pendientes (~/.openclaw/alerts/)

## 🔄 Comunicación entre Sesiones

### Lo que PERSISTE entre sesiones
- MEMORY.md → memoria a largo plazo
- MISTAKES.md → errores y reglas de prevención
- WINS.md → patrones que funcionan
- memory/YYYY-MM-DD.md → log diario
- shared/ → contexto compartido entre agentes
- git (repo) → todo el workspace

### Lo que NO persiste
- Conversación en curso (se pierde al resetear)
- Variables de sesión
- Archivos temporales en /tmp

**Regla:** Si es importante, escribirlo a archivo. "Lo recuerdo" no es estrategia válida.

## 🌙 Rutina Nocturna (2am consolidation)

El cron de consolidación revisa:
1. MISTAKES.md → ¿cada error tiene regla? → copiar a MEMORY.md
2. WINS.md → ¿cada win tiene patrón? → copiar a MEMORY.md
3. memory/YYYY-MM-DD.md → ¿aprendizajes no logueados?
4. Limpiar entries > 30 días de MISTAKES.md
5. MEMORY.md → limpiar entradas obsoletas
6. Escribir resumen en memory/consolidation-YYYY-MM-DD.md

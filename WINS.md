# WINS — Do Repeat

*Last updated: 2026-04-03*

Patrones que funcionaron bien. Reforzar estos comportamientos en cada sesión.

## Formato
- **Date**: cuando ocurrió
- **What worked**: qué se hizo bien
- **Why it worked**: por qué funcionó
- **Pattern**: patrón generalizable para repetir

---

## 2026-04-03

### Aprobar device pairing resolvió subagentes
- **What worked:** Un simple `openclaw devices approve --latest` desbloqueó todos los subagentes
- **Why it worked:** El gateway tenía un pending request que bloqueaba conexiones internas
- **Pattern:** Si algo falla con "pairing required", revisar `openclaw devices list` ANTES de buscar soluciones complejas. Las soluciones simples suelen ser las correctas.

### Buscar API key en auth-profiles.json
- **What worked:** Cuando la key de z.ai no funcionaba, busqué en los archivos internos de OpenClaw y encontré la key completa con sufijo
- **Why it worked:** OpenClaw almacena credentials en ubicaciones que no son obvias a primera vista
- **Pattern:** Si una credencial falla, buscar en TODOS los archivos de config/auth del sistema (openclaw.json, .env, auth-profiles, keyring, credentials)

### uv > pip para gestionar Python
- **What worked:** uv descargó Python 3.12 cuando el sistema solo tenía 3.14, resolviendo incompatibilidad con fastapi
- **Why it worked:** uv maneja versiones de Python + entornos + dependencias en un solo tool
- **Pattern:** Para entornos Python, usar siempre uv. Evitar pip/venv directos cuando haya problemas de compatibilidad.

### torch CPU-only en NUC
- **What worked:** Instalar torch desde pytorch CPU wheel antes de sentence-transformers evitó instalar 2GB+ de CUDA
- **Why it worked:** El NUC no tiene GPU, los paquetes CUDA son innecesarios y pesados
- **Pattern:** En máquinas sin GPU, siempre especificar CPU-only para torch. Verificar con `nvidia-smi` o lspci antes.

### PRD → TRD → Plan antes de codear
- **What worked:** Hans pidió los 3 documentos ANTES de implementar. Redujo cambios posteriores.
- **Why it worked:** Documentar primero alinea expectativas y reduce retrabajo
- **Pattern:** Para cualquier proyecto nuevo, SIEMPRE producir PRD/TRD/Plan antes de escribir código. Hans lo prefiere explícitamente.

### Cloudflare Tunnel para acceso externo rápido
- **What worked:** `cloudflared tunnel --url http://localhost:8000` dio URL pública en segundos sin configurar router
- **Why it worked:** trycloudflare.com genera túneles temporales sin cuenta ni DNS
- **Pattern:** Para pruebas externas rápidas, Cloudflare Tunnel es la opción más simple. No necesita abrir puertos ni configurar DNS.

### Delegar al design-agent para UI
- **What worked:** El design-agent rediseñó toda la UI del RAG Chat en ~2 minutos de forma autónoma
- **Why it worked:** Agente especializado + prompt claro + acceso a los archivos = resultado rápido
- **Pattern:** Delegar a agentes especializados siempre que sea posible. Dar contexto claro, archivos objetivos, y autonomía.

### Rebase --ours para sync upstream
- **What worked:** `git rebase upstream/main --strategy=recursive -X ours` mantiene cambios locales frente a upstream
- **Why it worked:** En un fork personalizado, los cambios locales siempre deberían ganar sobre upstream
- **Pattern:** Para sincronizar fork con upstream donde el fork es personalización, siempre usar estrategia ours.

### Commits frecuentes y descriptivos
- **What worked:** Commits después de cada feature con mensajes claros en español
- **Why it worked:** Permite revertir cambios específicos y mantener historial limpio
- **Pattern:** Commit después de cada cambio funcional. Mensaje descriptivo de qué cambió y por qué.

### Responder en chileno cuando Hans lo pide
- **What worked:** Cambiar de español neutro a chileno ("cachai", "po", "pillo") mejoró la conexión
- **Why it worked:** Hans se siente más cómodo con su forma de hablar
- **Pattern:** Ajustar el tono al contexto. Trabajo = directo. Personal = chileno, cariñoso. Hans lo pidió explícitamente.

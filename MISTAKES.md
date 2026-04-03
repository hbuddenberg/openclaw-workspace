# MISTAKES — Do Not Repeat

This file tracks specific mistakes the agent has made. The nightly consolidation job reviews it and ensures each entry has a standing prevention rule.

The goal is not to punish mistakes — it's to not make the same one twice.

## Format
- **Date**: when it happened
- **What went wrong**: specific description
- **Why**: root cause
- **Fix**: what was done to resolve it
- **Rule**: the standing rule to prevent recurrence

---

## 2026-04-03

### exec fish sin check interactivo → rompió OpenClaw exec (2 veces)
- **What went wrong:** `.bashrc` hacía `exec fish` sin verificar si era shell interactivo. OpenClaw ejecuta commands via bash non-interactive → fish interceptaba y moría.
- **Why:** No verificar `$- == *i*` antes de exec fish.
- **Fix:** Agregar `[[ $- == *i* ]] && exec fish` en .bashrc
- **Rule:** NUNCA ejecutar `exec fish` sin verificar shell interactivo primero. Todo .bashrc que haga exec debe checkear `$- == *i*`.

### main.py contenido en __init__.py
- **What went wrong:** Al crear el proyecto RAG, escribí todo el contenido de FastAPI en `app/__init__.py` en vez de `app/main.py`. Python no encontró `app.main`.
- **Why:** Crear archivo con write tool usando path incorrecto.
- **Fix:** Mover contenido a `app/main.py` y dejar `app/__init__.py` como import package.
- **Rule:** FastAPI entrypoint SIEMPRE va en `main.py`, nunca en `__init__.py`. Antes de crear archivos, verificar la estructura estándar del framework.

### Variable chunk_text usada como nombre y parámetro
- **What went wrong:** En `app/services/__init__.py`, la función `index_file` usaba `chunk_text` como nombre de variable en list comprehension y como función importada. Python lanzó "cannot access local variable".
- **Why:** Conflicto de nombres — variable shadowing de import.
- **Fix:** Renombrar variables a `txt` en vez de `chunk_text`.
- **Rule:** NUNCA usar el mismo nombre para una variable local que para una función importada. Usar nombres distintos (txt, chunk, item, etc.).

### Key de z.ai incompleta → 401 Authentication Error
- **What went wrong:** Hans me pasó la API key `4dfbdffbe3854db692d9a64cc2a2b114` pero la key real tiene un sufijo: `4dfbdffbe3854db692d9a64cc2a2b114.VrTaxde0DvnwSqzi`. La key completa estaba en `auth-profiles.json`.
- **Why:** La key de z.ai tiene un formato que OpenClaw maneja internamente. El usuario solo veía la primera parte.
- **Fix:** Leer `auth-profiles.json` para obtener la key completa.
- **Rule:** Siempre verificar API keys buscando en múltiples ubicaciones (config, .env, auth-profiles, keyring). Probar con curl antes de integrar.

### Sobreescribir crontab sin preservar entradas existentes
- **What went wrong:** Al agregar nuevo cron job de upstream sync, `crontab -l | grep -v X | crontab -` eliminó todos los otros jobs porque el grep previo falló silenciosamente.
- **Why:** No verificar que los crons existentes estaban siendo preservados antes de sobreescribir.
- **Fix:** Restaurar manualmente los 5 crons (backup, consolidation, vdirsyncer x2, upstream).
- **Rule:** SIEMPRE hacer backup del crontab antes de modificarlo. Verificar con `crontab -l` después del cambio que todas las entradas están presentes.

### Disk quota exceeded al instalar torch con CUDA
- **What went wrong:** sentence-transformers depende de torch, que por defecto instala nvidia-nccl (paquete CUDA de 2+ GB). El disco se llenó con quota error.
- **Why:** No especificar torch CPU-only en la instalación.
- **Fix:** Instalar torch desde `https://download.pytorch.org/whl/cpu` antes de sentence-transformers.
- **Rule:** En máquinas sin GPU, SIEMPRE instalar torch CPU-only. El NUC no tiene GPU. Usar `--index-url https://download.pytorch.org/whl/cpu`.

### Crear __init__.py vacío falló por content vacío
- **What went wrong:** Intenté crear un archivo vacío con write tool pero no acepta content vacío.
- **Why:** Restricción del tool — content es required.
- **Fix:** Escribir `# RAG Chat app package\n` como contenido mínimo.
- **Rule:** Para crear archivos vacíos o __init__.py, usar `touch` via exec o escribir un comentario como contenido mínimo.

### Sessions_spawn falló con "pairing required"
- **What went wrong:** Intentar spawnear subagentes daba error 1008 "pairing required" del gateway. No podía delegar a agentes.
- **Why:** El gateway trataba conexiones WS internas como dispositivos externos sin pairar. Había un request pendiente.
- **Fix:** `openclaw devices approve --latest` para aprobar el device pairing pendiente.
- **Rule:** Si subagentes fallan con pairing, revisar `openclaw devices list` y aprobar requests pendientes.

### Lanzar install commands sin verificar espacio en disco
- **What went wrong:** Varias instalaciones de paquetes Python fallaron por quota sin verificar disco primero.
- **Why:** No ejecutar `df -h` antes de operaciones grandes.
- **Fix:** Limpiar pip cache y usar `--no-cache-dir`.
- **Rule:** ANTES de instalar paquetes grandes, verificar `df -h`. Si hay poco espacio, limpiar caches primero.

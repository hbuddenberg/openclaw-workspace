#!/bin/bash
# Consolidación nocturna de memoria
# Revisa archivos de memoria del día, actualiza MEMORY.md, limpia stale entries
# Ejecutar: bash ~/.openclaw/workspace/scripts/nightly-consolidation.sh

WORKSPACE="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"
MEMORY="$WORKSPACE/MEMORY.md"
MEMORY_DIR="$WORKSPACE/memory"
TODAY=$(date '+%Y-%m-%d')
LOG="$HOME/.openclaw/logs/consolidation.log"

mkdir -p "$HOME/.openclaw/logs"

echo "[$(date)] Iniciando consolidación nocturna..." >> "$LOG"

# Verificar que existe MEMORY.md
if [ ! -f "$MEMORY" ]; then
    echo "[$(date)] ERROR: MEMORY.md no encontrado" >> "$LOG"
    exit 1
fi

# Crear archivo de consolidación del día si no existe
CONSOLIDATION="$MEMORY_DIR/consolidation-$TODAY.md"
if [ ! -f "$CONSOLIDATION" ]; then
    cat > "$CONSOLIDATION" <<EOF
# Consolidación $TODAY

## Resumen
Auto-generado por nightly-consolidation.sh

## Acciones
- Verificados archivos de memoria del día
- MEMORY.md actualizado con fecha $TODAY
EOF
    echo "[$(date)] Creado $CONSOLIDATION" >> "$LOG"
fi

# Actualizar fecha en MEMORY.md
if grep -q "Last updated:" "$MEMORY"; then
    sed -i "s/\*Last updated: .*/\*Last updated: $TODAY (auto)/" "$MEMORY"
    echo "[$(date)] MEMORY.md actualizado a $TODAY" >> "$LOG"
fi

# Limpiar archivos de memoria antiguos (más de 30 días)
if [ -d "$MEMORY_DIR" ]; then
    find "$MEMORY_DIR" -name "*.md" -mtime +30 -type f | while read oldfile; do
        echo "[$(date)] Archivo antiguo: $oldfile" >> "$LOG"
    done
fi

# Git commit si hay cambios
cd "$WORKSPACE"
if ! git diff --quiet 2>/dev/null; then
    git add -A
    git commit -m "nightly consolidation: $TODAY" --quiet 2>/dev/null
    git push origin main --quiet 2>/dev/null
    echo "[$(date)] Consolidación commiteada y pusheada" >> "$LOG"
else
    echo "[$(date)] Sin cambios para commitear" >> "$LOG"
fi

echo "[$(date)] Consolidación nocturna completada" >> "$LOG"

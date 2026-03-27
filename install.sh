#!/usr/bin/env bash
# install.sh — configura el workspace de openclaw-starter-kit
# Uso: bash install.sh
# Lo que hace: copia los ficheros del repo al directorio de trabajo de OpenClaw (~/.openclaw)
# y crea las carpetas necesarias si no existen.

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.openclaw"

echo ""
echo "openclaw-starter-kit / install.sh"
echo "=================================="
echo ""

# Comprueba que OpenClaw está instalado
if ! command -v openclaw &>/dev/null; then
  echo "ERROR: openclaw no está instalado o no está en el PATH."
  echo ""
  echo "Instálalo primero:"
  echo "  npm install -g openclaw"
  echo ""
  echo "O si prefieres que alguien lo monte por ti en un VPS:"
  echo "  https://devknives.link/myclaw"
  echo ""
  exit 1
fi

# Avisa si el directorio destino ya existe con contenido
if [ -d "$TARGET_DIR" ] && [ "$(ls -A "$TARGET_DIR" 2>/dev/null)" ]; then
  echo "AVISO: $TARGET_DIR ya existe y tiene contenido."
  echo ""
  read -p "¿Sobreescribir los ficheros existentes? Los que no estén en el repo no se tocan. [s/N] " confirm
  echo ""
  if [[ "$confirm" != "s" && "$confirm" != "S" ]]; then
    echo "Cancelado. No se ha modificado nada."
    exit 0
  fi
fi

echo "Copiando ficheros a $TARGET_DIR ..."
echo ""

# Crea el directorio destino si no existe
mkdir -p "$TARGET_DIR"
mkdir -p "$TARGET_DIR/memory"
mkdir -p "$TARGET_DIR/data"

# Lista de ficheros y carpetas a copiar (excluye .git, install.sh y README.md)
ITEMS=(
  "AGENTS.md"
  "HEARTBEAT.md"
  "IDENTITY.md"
  "MEMORY.md"
  "MESH.md"
  "MISTAKES.md"
  "SOUL.md"
  "SQUAD.md"
  "TOKEN-OPTIMIZATION.md"
  "TOOLS.md"
  "USER.md"
  "agents"
  "intel"
  "ops"
  "scripts"
  "shared"
)

for item in "${ITEMS[@]}"; do
  src="$REPO_DIR/$item"
  dst="$TARGET_DIR/$item"

  if [ -e "$src" ]; then
    if [ -d "$src" ]; then
      cp -r "$src" "$TARGET_DIR/"
      echo "  ✓ $item/"
    else
      cp "$src" "$dst"
      echo "  ✓ $item"
    fi
  fi
done

# Crea el fichero USER.md si no existe (no sobreescribir si ya tiene datos)
if [ ! -f "$TARGET_DIR/USER.md" ]; then
  cp "$REPO_DIR/USER.md" "$TARGET_DIR/USER.md"
fi

echo ""
echo "Hecho. Workspace instalado en $TARGET_DIR"
echo ""
echo "Siguientes pasos:"
echo "  1. Arranca el gateway:     openclaw gateway start"
echo "  2. Abre el dashboard:      openclaw dashboard"
echo "  3. Pega el prompt de configuración del README y rellena tus datos"
echo ""
echo "Docs: https://docs.openclaw.ai"
echo "Tutorial de instalación: https://edunavajas.com/blog/openclaw-instalacion-segura"
echo ""

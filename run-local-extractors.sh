#!/bin/bash
set -e

DATA_DIR="${DATA_DIR:-/tortoise}"
WOW_CLIENT="${WOW_CLIENT:-/wow-client}"

if [ ! -d "$WOW_CLIENT/Data" ]; then
  echo "ERROR: WoW client not found at $WOW_CLIENT/Data. Mount your WoW client directory."
  exit 1
fi

NEEDS_EXTRACTION=false

for dir in dbc maps vmaps mmaps; do
  if [ ! -d "$DATA_DIR/$dir" ] || [ -z "$(ls -A $DATA_DIR/$dir 2>/dev/null)" ]; then
    echo "Missing or empty: $DATA_DIR/$dir"
    NEEDS_EXTRACTION=true
  fi
done

if [ "$NEEDS_EXTRACTION" = false ]; then
  echo "All data directories present, skipping extraction."
  exit 0
fi

echo "Starting extraction..."

echo "[1/4] Extracting maps and dbc..."
mapextractor -i "$WOW_CLIENT" -o "$DATA_DIR"

echo "[2/4] Extracting vmap buildings..."
cd "$WOW_CLIENT"
vmapextractor -d "$WOW_CLIENT/Data"

echo "[3/4] Assembling vmaps..."
vmap_assembler "$WOW_CLIENT/Buildings" "$DATA_DIR/vmaps"

echo "[4/4] Generating mmaps (this will take a long time, hours for a slow cpu)..."
cd "$DATA_DIR"
MoveMapGen --silent

echo "Extraction complete!"

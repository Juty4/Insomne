#!/bin/bash

APP_ID="com.tuapp.Insomne"

echo "🗑️  Desinstalando Insomne..."

# Matar proceso
pkill -9 Insomne 2>/dev/null || true

# App
rm -rf /Applications/Insomne.app

# Sudoers
sudo rm -f /etc/sudoers.d/insomne

# Estado
rm -f ~/.insomne_state

# Caches de usuario
rm -rf ~/Library/Caches/$APP_ID
rm -rf ~/Library/HTTPStorages/$APP_ID

# Carpeta temporal del sistema (var/folders — varía por usuario)
TMPDIR_BASE=$(getconf DARWIN_USER_CACHE_DIR 2>/dev/null || echo "")
if [ -n "$TMPDIR_BASE" ]; then
    rm -rf "${TMPDIR_BASE}${APP_ID}" 2>/dev/null || true
fi

# Buscar y borrar cualquier resto en var/folders
find /private/var/folders -name "$APP_ID" -type d 2>/dev/null | while read dir; do
    rm -rf "$dir"
done

echo "✅ Insomne desinstalada completamente"

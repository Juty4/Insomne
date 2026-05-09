#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_NAME="Insomne"
VERSION="1.0"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"
WORK_DIR="$SCRIPT_DIR/dmg_work"
STAGING="$WORK_DIR/staging"
TMP_DMG="$WORK_DIR/tmp.dmg"
FINAL_DMG="$SCRIPT_DIR/$DMG_NAME"

echo "🔨 Compilando $APP_NAME..."
bash "$SCRIPT_DIR/build.sh"

echo "📦 Preparando DMG..."
rm -rf "$WORK_DIR"
mkdir -p "$STAGING"

# Quitar cuarentena de la app ANTES de meterla en el DMG
xattr -cr "/Applications/$APP_NAME.app"

cp -R "/Applications/$APP_NAME.app" "$STAGING/"
ln -s /Applications "$STAGING/Applications"

# Incluir script de desinstalación dentro del DMG
cp "$SCRIPT_DIR/uninstall.sh" "$STAGING/Desinstalar Insomne.command"
chmod +x "$STAGING/Desinstalar Insomne.command"

hdiutil create \
    -srcfolder "$STAGING" \
    -volname "$APP_NAME" \
    -fs HFS+ \
    -fsargs "-c c=64,a=16,b=16" \
    -format UDRW \
    -size 80m \
    "$TMP_DMG"

MOUNT_DIR=$(hdiutil attach -readwrite -noverify -noautoopen "$TMP_DMG" | grep "Apple_HFS" | awk '{print $NF}')
echo "📁 Montado en: $MOUNT_DIR"
sleep 2

# Fondo
mkdir -p "$MOUNT_DIR/.background"
cp "$SCRIPT_DIR/dmg_background.png" "$MOUNT_DIR/.background/background.png"

# Icono del volumen — claro por defecto
if [ -f "$SCRIPT_DIR/InsomneLight.iconset/icon_512x512.png" ]; then
    sips -s format icns "$SCRIPT_DIR/InsomneLight.iconset/icon_512x512.png" \
        --out "$MOUNT_DIR/.VolumeIcon.icns" 2>/dev/null || true
    SetFile -a C "$MOUNT_DIR" 2>/dev/null || true
fi

osascript << APPLESCRIPT
tell application "Finder"
    tell disk "$APP_NAME"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {100, 100, 760, 540}
        set viewOptions to the icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to 110
        set background picture of viewOptions to file ".background:background.png"
        set position of item "$APP_NAME.app" of container window to {165, 190}
        set position of item "Applications" of container window to {495, 190}
        close
        open
        update without registering applications
        delay 2
        close
    end tell
end tell
APPLESCRIPT

chmod -Rf go-w "$MOUNT_DIR"
sync
hdiutil detach "$MOUNT_DIR"
sleep 2

rm -f "$FINAL_DMG"
hdiutil convert "$TMP_DMG" \
    -format UDZO \
    -imagekey zlib-level=9 \
    -o "$FINAL_DMG"

rm -rf "$WORK_DIR"

echo ""
echo "✅ DMG creado: $FINAL_DMG"
echo "   Sube este fichero a GitHub Releases para compartirlo."

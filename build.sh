#!/bin/bash
set -e

APP_NAME="Insomne"
APP_DIR="/Applications/$APP_NAME.app"
CONTENTS="$APP_DIR/Contents"
MACOS="$CONTENTS/MacOS"
RESOURCES="$CONTENTS/Resources"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🔨 Compilando $APP_NAME..."
mkdir -p "$MACOS" "$RESOURCES"

ARCH=$(uname -m)
TARGET="${ARCH}-apple-macos13.0"

swiftc \
    "$SCRIPT_DIR/$APP_NAME/main.swift" \
    -o "$MACOS/$APP_NAME" \
    -sdk "$(xcrun --show-sdk-path --sdk macosx)" \
    -target "$TARGET" \
    -framework AppKit \
    -framework Foundation

echo "🎨 Generando iconos adaptativos..."

# Convertir ambos iconsets a .icns
if [ -d "$SCRIPT_DIR/InsomneDark.iconset" ]; then
    iconutil -c icns "$SCRIPT_DIR/InsomneDark.iconset" -o "$RESOURCES/AppIconDark.icns"
fi
if [ -d "$SCRIPT_DIR/InsomneLight.iconset" ]; then
    iconutil -c icns "$SCRIPT_DIR/InsomneLight.iconset" -o "$RESOURCES/AppIconLight.icns"
fi

# Crear icono adaptativo con iconutil usando ambas variantes
# macOS usa AppIconLight como base y AppIconDark para dark mode
# El truco es crear un icono que cambie con el tema usando tiffutil
if [ -f "$RESOURCES/AppIconLight.icns" ] && [ -f "$RESOURCES/AppIconDark.icns" ]; then
    # Extraer PNG de 512px de cada variante para el icono del Finder
    sips -s format png "$RESOURCES/AppIconLight.icns" --out "$RESOURCES/tmp_light.png" --resampleHeightWidth 512 512 2>/dev/null || true
    sips -s format png "$RESOURCES/AppIconDark.icns" --out "$RESOURCES/tmp_dark.png" --resampleHeightWidth 512 512 2>/dev/null || true

    # Usar el icono claro como AppIcon principal (por omisión del sistema)
    cp "$RESOURCES/AppIconLight.icns" "$RESOURCES/AppIcon.icns"
    rm -f "$RESOURCES/tmp_light.png" "$RESOURCES/tmp_dark.png"
fi

cat > "$CONTENTS/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDisplayName</key>
    <string>Insomne</string>
    <key>CFBundleExecutable</key>
    <string>Insomne</string>
    <key>CFBundleIdentifier</key>
    <string>com.tuapp.Insomne</string>
    <key>CFBundleName</key>
    <string>Insomne</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSRequiresAquaSystemAppearance</key>
    <false/>
    <key>NSAppleEventsUsageDescription</key>
    <string>Insomne necesita ejecutar comandos de sistema.</string>
</dict>
</plist>
PLIST

xattr -cr "$APP_DIR"
echo "✅ Insomne compilada en $APP_DIR"
echo ""
echo "Abriendo..."
pkill -9 Insomne 2>/dev/null || true
sleep 0.5
open "$APP_DIR"

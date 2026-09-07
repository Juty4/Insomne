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

# Obtener el SHA del commit actual (7 caracteres)
if git -C "$SCRIPT_DIR" rev-parse --short HEAD &>/dev/null; then
    BUILD_SHA=$(git -C "$SCRIPT_DIR" rev-parse --short HEAD)
else
    BUILD_SHA="local"
fi
echo "📌 Build SHA: $BUILD_SHA"

# Inyectar el SHA en el código fuente antes de compilar
SWIFT_SRC="$SCRIPT_DIR/$APP_NAME/main.swift"
SWIFT_TMP="/tmp/insomne_main_build.swift"
sed "s/let CURRENT_BUILD  = \"BUILD_SHA\"/let CURRENT_BUILD  = \"$BUILD_SHA\"/" "$SWIFT_SRC" > "$SWIFT_TMP"

swiftc \
    "$SWIFT_TMP" \
    -o "$MACOS/$APP_NAME" \
    -sdk "$(xcrun --show-sdk-path --sdk macosx)" \
    -target "$TARGET" \
    -framework AppKit \
    -framework Foundation

rm -f "$SWIFT_TMP"

echo "🎨 Generando iconos adaptativos..."

if [ -d "/Applications/Xcode.app" ]; then
    echo "⚙️ Usando Xcode actool para generar icono dinámico (Soporta Modo Oscuro nativo)..."
    export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
    ASSETS_DIR="/tmp/InsomneAssets.xcassets"
    APPICON_SET="$ASSETS_DIR/AppIcon.appiconset"
    mkdir -p "$APPICON_SET"
    
    cat > "$APPICON_SET/Contents.json" << 'EOF'
{
  "images" : [
    { "idiom" : "mac", "size" : "512x512", "scale" : "1x", "filename" : "light.png" },
    { "idiom" : "mac", "size" : "512x512", "scale" : "1x", "filename" : "dark.png", "appearances" : [ { "appearance" : "luminosity", "value" : "dark" } ] }
  ],
  "info" : { "version" : 1, "author" : "xcode" }
}
EOF
    cp "$SCRIPT_DIR/InsomneLight.iconset/icon_512x512.png" "$APPICON_SET/light.png" 2>/dev/null || true
    cp "$SCRIPT_DIR/InsomneDark.iconset/icon_512x512.png" "$APPICON_SET/dark.png" 2>/dev/null || true

    xcrun actool "$ASSETS_DIR" --compile "$RESOURCES" --platform macosx --minimum-deployment-target 13.0 --app-icon AppIcon --output-partial-info-plist /tmp/PartialInfo.plist > /dev/null
    rm -rf "$ASSETS_DIR"
else
    # Fallback si no hay Xcode completo: Compilar .icns estático usando iconutil
    if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ] && [ -d "$SCRIPT_DIR/InsomneDark.iconset" ]; then
        iconutil -c icns "$SCRIPT_DIR/InsomneDark.iconset" -o "$RESOURCES/AppIcon.icns"
        echo "🌙 Aplicando icono de Modo Oscuro al empaquetado (Estático)"
    elif [ -d "$SCRIPT_DIR/InsomneLight.iconset" ]; then
        iconutil -c icns "$SCRIPT_DIR/InsomneLight.iconset" -o "$RESOURCES/AppIcon.icns"
        echo "☀️ Aplicando icono de Modo Claro al empaquetado (Estático)"
    fi
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

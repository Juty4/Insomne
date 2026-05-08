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

# Convertir iconset a .icns
ICONSET="$SCRIPT_DIR/Insomne.iconset"
if [ -d "$ICONSET" ]; then
    iconutil -c icns "$ICONSET" -o "$RESOURCES/AppIcon.icns"
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
    <key>NSAppleEventsUsageDescription</key>
    <string>Insomne necesita ejecutar comandos de sistema.</string>
</dict>
</plist>
PLIST

xattr -cr "$APP_DIR"
echo "✅ Insomne.app compilada"

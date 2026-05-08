#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_NAME="Insomne"
VERSION="1.0"
PKG_NAME="${APP_NAME}-${VERSION}.pkg"
WORK_DIR="$SCRIPT_DIR/pkg_work"

echo "📦 Creando instalador $PKG_NAME..."

# 1. Compilar la app primero
bash "$SCRIPT_DIR/build.sh"

# 2. Preparar estructura del pkg
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR/root/Applications"
mkdir -p "$WORK_DIR/scripts"

# Copiar la app compilada
cp -R "/Applications/$APP_NAME.app" "$WORK_DIR/root/Applications/"

# Script postinstall: quita cuarentena y abre la app
cat > "$WORK_DIR/scripts/postinstall" << 'EOF'
#!/bin/bash
xattr -cr /Applications/Insomne.app
# Matar instancia anterior si existe
pkill -9 Insomne 2>/dev/null || true
sleep 0.5
open /Applications/Insomne.app
exit 0
EOF
chmod +x "$WORK_DIR/scripts/postinstall"

# 3. Construir el .pkg con pkgbuild
pkgbuild \
    --root "$WORK_DIR/root" \
    --scripts "$WORK_DIR/scripts" \
    --identifier "com.tuapp.Insomne" \
    --version "$VERSION" \
    --install-location "/" \
    "$SCRIPT_DIR/$PKG_NAME"

# Limpiar temporales
rm -rf "$WORK_DIR"

echo ""
echo "✅ Instalador creado: $SCRIPT_DIR/$PKG_NAME"
echo ""
echo "Para instalar: doble clic en $PKG_NAME"

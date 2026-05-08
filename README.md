# Insomne 🌙

App de barra de menú para macOS que mantiene el ordenador encendido con la tapa cerrada.

---

## Opción 1 — Instalador .pkg (recomendado)

1. Descarga y descomprime la carpeta `Insomne`
2. Abre Terminal y ejecuta:
```bash
cd ~/Downloads/Insomne
bash make_pkg.sh
```
3. Se genera `Insomne-1.0.pkg` en la misma carpeta
4. **Doble clic** en el `.pkg` → Siguiente → Instalar → listo

> A partir de ahí puedes compartir el `.pkg` con cualquiera. Solo necesitan hacer doble clic.

---

## Opción 2 — Homebrew (tap propio)

### Paso 1: Subir el código a GitHub

1. Crea un repo en GitHub llamado `insomne` (público)
2. Sube todos los ficheros de esta carpeta
3. Ve a **Releases** → **Create a new release** → tag `v1.0`
4. Adjunta el fichero `Insomne-1.0.pkg` que generaste antes
5. Publica el release y copia la URL del `.pkg`

### Paso 2: Obtener el SHA256 del pkg

```bash
shasum -a 256 Insomne-1.0.pkg
```
Copia el hash que aparece.

### Paso 3: Crear el tap de Homebrew

1. Crea otro repo en GitHub llamado exactamente `homebrew-tap` (público)
2. Dentro crea el fichero `Casks/insomne.rb` con este contenido:

```ruby
cask "insomne" do
  version "1.0"
  sha256 "PEGA_AQUI_EL_SHA256_DEL_PKG"

  url "https://github.com/TU_USUARIO/insomne/releases/download/v1.0/Insomne-1.0.pkg"
  name "Insomne"
  desc "Mantén tu Mac encendido con la tapa cerrada"
  homepage "https://github.com/TU_USUARIO/insomne"

  pkg "Insomne-1.0.pkg"

  uninstall pkgutil: "com.tuapp.Insomne",
            delete:  "/Applications/Insomne.app"
end
```

3. Sustituye `TU_USUARIO` por tu usuario de GitHub y el SHA256

### Paso 4: Instalar con brew

Cualquiera podrá instalar Insomne con:
```bash
brew tap TU_USUARIO/tap
brew install --cask insomne
```

---

## Desinstalar

```bash
rm -rf /Applications/Insomne.app
sudo rm -f /etc/sudoers.d/insomne
rm -f ~/.insomne_state
```

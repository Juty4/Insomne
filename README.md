# Insomne 🌙

<p align="center">
  <img src="IconoClaro.png" width="120" alt="Insomne icon" />
</p>

<p align="center">
  macOS menu bar app that keeps your Mac awake with the lid closed.
</p>

---

## English

### What it does

Insomne sits in your menu bar and lets you keep your Mac running with the lid closed — no Display Sleep, no system sleep. One click to enable, one click to disable.

- **⚡ Active** — your Mac stays on with the lid closed
- **⚡̶ Inactive** — normal macOS sleep behaviour

### Install

1. Download `Insomne-1.0.dmg` from the [Releases](https://github.com/Juty4/Insomne/releases) page
2. Open the DMG and drag **Insomne** to your **Applications** folder
3. Open Insomne from Spotlight or Finder
4. On first launch it will ask for your admin password **once** to set up the system command — after that, no password needed while the app is open

> If macOS blocks the app, go to **System Settings → Privacy & Security** and click **Open Anyway**.

### Uninstall

```bash
pkill -9 Insomne 2>/dev/null; rm -rf /Applications/Insomne.app; sudo rm -f /etc/sudoers.d/insomne; rm -f ~/.insomne_state
```

---

## Español

### Qué hace

Insomne vive en tu barra de menú y te permite mantener el Mac encendido con la tapa cerrada — sin que entre en reposo. Un clic para activarlo, otro para desactivarlo.

- **⚡ Activo** — el Mac se mantiene encendido con la tapa cerrada
- **⚡̶ Inactivo** — comportamiento normal de macOS

### Instalar

1. Descarga `Insomne-1.0.dmg` desde la página de [Releases](https://github.com/Juty4/Insomne/releases)
2. Abre el DMG y arrastra **Insomne** a tu carpeta **Aplicaciones**
3. Abre Insomne desde Spotlight o el Finder
4. La primera vez pedirá tu contraseña de administrador **una sola vez** para configurar el comando del sistema — a partir de ahí no hace falta mientras la app esté abierta

> Si macOS bloquea la app, ve a **Ajustes del Sistema → Privacidad y Seguridad** y pulsa **Abrir de todas formas**.

### Desinstalar

```bash
pkill -9 Insomne 2>/dev/null; rm -rf /Applications/Insomne.app; sudo rm -f /etc/sudoers.d/insomne; rm -f ~/.insomne_state
```

---

## Build from source

```bash
git clone https://github.com/Juty4/Insomne.git
cd Insomne
bash build.sh
```

Requires Xcode Command Line Tools (`xcode-select --install`).

---

## Requirements

- macOS 13 Ventura or later
- Apple Silicon or Intel

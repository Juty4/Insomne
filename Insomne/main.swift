import AppKit

// ─── Constantes ────────────────────────────────────────────────────────────

let GITHUB_USER    = "Juty4"
let GITHUB_REPO    = "Insomne"
// Este valor se reemplaza automáticamente por el SHA del commit al compilar con build.sh
let CURRENT_BUILD  = "BUILD_SHA"

// ─── AppDelegate ───────────────────────────────────────────────────────────

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!
    var isEnabled: Bool = false
    
    // Menú Items almacenados para actualizarlos sin reconstruir el menú
    var statusMenuItem: NSMenuItem!
    var toggleMenuItem: NSMenuItem!

    let sudoersFile = "/etc/sudoers.d/insomne"

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        // Cargar estado desde UserDefaults (Forma nativa de Apple)
        isEnabled = UserDefaults.standard.bool(forKey: "isInsomneEnabled")
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        buildMenu()
        updateStatusIcon()
        updateMenuItems()

        setupSudoersIfNeeded()

        // Comprobar actualizaciones al arrancar (en background)
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) {
            self.checkForUpdates(silent: true)
        }
    }

    // MARK: - Sudoers

    func setupSudoersIfNeeded() {
        guard !FileManager.default.fileExists(atPath: sudoersFile) else { return }
        let username = NSUserName()
        // SEGURIDAD: Solo permitimos pmset. Eliminamos rm para evitar vulnerabilidades críticas.
        let rule = "\(username) ALL=(ALL) NOPASSWD: /usr/bin/pmset"
        let script = "do shell script \"echo '\(rule)' | tee \(sudoersFile) && chmod 440 \(sudoersFile)\" with administrator privileges"
        DispatchQueue.global(qos: .userInitiated).async {
            var err: NSDictionary?
            NSAppleScript(source: script)?.executeAndReturnError(&err)
        }
    }

    // MARK: - Icon

    func updateStatusIcon() {
        guard let button = statusItem?.button else { return }
        let iconName = isEnabled ? "bolt.fill" : "bolt.slash.fill"
        if let image = NSImage(systemSymbolName: iconName, accessibilityDescription: nil) {
            image.isTemplate = true // macOS cambia el color automáticamente para modo Claro/Oscuro
            button.image = image
        }
        button.toolTip = isEnabled ? "Insomne: Activo" : "Insomne: Inactivo"
    }

    // MARK: - Menu

    func buildMenu() {
        let menu = NSMenu()

        statusMenuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        statusMenuItem.isEnabled = false
        menu.addItem(statusMenuItem)
        
        menu.addItem(.separator())

        toggleMenuItem = NSMenuItem(title: "", action: #selector(toggleLidLock), keyEquivalent: "t")
        toggleMenuItem.target = self
        menu.addItem(toggleMenuItem)

        menu.addItem(.separator())

        let updateItem = NSMenuItem(title: "Buscar actualizaciones", action: #selector(checkUpdatesManual), keyEquivalent: "u")
        updateItem.target = self
        menu.addItem(updateItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(title: "Cerrar aplicación", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }
    
    func updateMenuItems() {
        statusMenuItem.title = isEnabled ? "Estado: ✅ Encendido" : "Estado: ⚫ Apagado"
        toggleMenuItem.title = isEnabled ? "Apagar" : "Encender"
    }

    // MARK: - Toggle

    @objc func toggleLidLock() {
        let newValue = isEnabled ? "0" : "1"
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            if self.runPmset(value: newValue) {
                let nowEnabled = newValue == "1"
                
                // Guardar estado de forma nativa
                UserDefaults.standard.set(nowEnabled, forKey: "isInsomneEnabled")
                
                DispatchQueue.main.async {
                    self.isEnabled = nowEnabled
                    self.updateStatusIcon()
                    self.updateMenuItems()
                }
            }
        }
    }

    // MARK: - Actualizaciones

    @objc func checkUpdatesManual() {
        checkForUpdates(silent: false)
    }

    func checkForUpdates(silent: Bool) {
        let urlString = "https://api.github.com/repos/\(GITHUB_USER)/\(GITHUB_REPO)/commits/main"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("Insomne/\(CURRENT_BUILD)", forHTTPHeaderField: "User-Agent")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                if !silent { DispatchQueue.main.async { self.showUpdateError("Error de conexión a internet.") } }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 403 {
                if !silent { DispatchQueue.main.async { self.showUpdateError("Límite de peticiones de GitHub alcanzado. Intenta de nuevo en una hora.") } }
                return
            }

            guard
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let sha = json["sha"] as? String
            else {
                if !silent { DispatchQueue.main.async { self.showUpdateError("Respuesta inválida del servidor.") } }
                return
            }

            let latestSHA = String(sha.prefix(7))
            let repoURL = "https://github.com/\(GITHUB_USER)/\(GITHUB_REPO)"

            let commitMessage = (json["commit"] as? [String: Any])
                .flatMap { $0["message"] as? String }
                .map { $0.components(separatedBy: "\n").first ?? $0 }
                ?? "Nueva actualización disponible"

            DispatchQueue.main.async {
                if latestSHA != CURRENT_BUILD && CURRENT_BUILD != "BUILD_SHA" {
                    self.showUpdateAvailable(sha: latestSHA, message: commitMessage, url: repoURL)
                } else if !silent {
                    self.showNoUpdates()
                }
            }
        }.resume()
    }

    func showUpdateAvailable(sha: String, message: String, url: String) {
        let alert = NSAlert()
        alert.messageText = "🎉 Hay una actualización disponible"
        alert.informativeText = "Último cambio: \(message)\n\n¿Quieres actualizar e instalar la nueva versión ahora?"
        alert.alertStyle = .informational
        
        alert.addButton(withTitle: "Actualizar automáticamente")
        alert.addButton(withTitle: "Ver en GitHub")
        alert.addButton(withTitle: "Ahora no")

        let response = alert.runModal()
        
        if response == .alertFirstButtonReturn {
            performAutoUpdate()
        } else if response == .alertSecondButtonReturn {
            if let downloadURL = URL(string: url) {
                NSWorkspace.shared.open(downloadURL)
            }
        }
    }

    func performAutoUpdate() {
        let updateScript = """
        #!/bin/bash
        sleep 2
        echo "Iniciando actualización de Insomne..."
        cd /tmp
        rm -rf Insomne_updater
        git clone https://github.com/\(GITHUB_USER)/\(GITHUB_REPO).git Insomne_updater
        cd Insomne_updater
        bash build.sh
        cd /tmp
        rm -rf Insomne_updater
        """
        
        let scriptPath = "/tmp/insomne_update.sh"
        
        do {
            let scriptURL = URL(fileURLWithPath: scriptPath)
            try updateScript.write(to: scriptURL, atomically: true, encoding: .utf8)
            
            let task = Process()
            task.launchPath = "/usr/bin/nohup"
            task.arguments = ["/bin/bash", scriptPath]
            try task.run()
            
            NSApplication.shared.terminate(nil)
            exit(0)
            
        } catch {
            showUpdateError("No se pudo iniciar la actualización automática. Inténtalo de forma manual.")
        }
    }

    func showNoUpdates() {
        let alert = NSAlert()
        alert.messageText = "✅ Insomne está al día"
        alert.informativeText = "Tienes la última versión instalada (v\(CURRENT_BUILD))."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    func showUpdateError(_ message: String) {
        let alert = NSAlert()
        alert.messageText = "No se pudo comprobar actualizaciones"
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    // MARK: - Quit

    @objc func quitApp() {
        if isEnabled { 
            _ = runPmset(value: "0")
            UserDefaults.standard.set(false, forKey: "isInsomneEnabled") 
        }
        
        // SEGURIDAD: Ya no ejecutamos `sudo rm` al cerrar la aplicación.
        // El archivo sudoers se mantendrá para no pedir la contraseña en el futuro,
        // y se eliminará de forma segura solo usando uninstall.sh.
        
        NSApplication.shared.terminate(nil)
        exit(0)
    }

    // MARK: - pmset

    @discardableResult
    func runPmset(value: String) -> Bool {
        if FileManager.default.fileExists(atPath: sudoersFile) {
            let task = Process()
            task.launchPath = "/usr/bin/sudo"
            task.arguments = ["/usr/bin/pmset", "-a", "disablesleep", value]
            task.standardOutput = Pipe(); task.standardError = Pipe()
            do { try task.run(); task.waitUntilExit()
                if task.terminationStatus == 0 { return true }
            } catch {}
        }
        let script = "do shell script \"/usr/bin/pmset -a disablesleep \(value)\" with administrator privileges"
        var error: NSDictionary?
        NSAppleScript(source: script)?.executeAndReturnError(&error)
        if let err = error {
            let code = err[NSAppleScript.errorNumber] as? Int ?? 0
            if code == -128 { return false }
            let msg = err[NSAppleScript.errorMessage] as? String ?? "código \(code)"
            DispatchQueue.main.async {
                let alert = NSAlert()
                alert.messageText = "Insomne – Error"
                alert.informativeText = msg
                alert.alertStyle = .warning
                alert.runModal()
            }
            return false
        }
        return true
    }
}

// ─── Entry point ───────────────────────────────────────────────────────────

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()

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

    let stateFile = URL(fileURLWithPath: NSHomeDirectory())
        .appendingPathComponent(".insomne_state")
    let sudoersFile = "/etc/sudoers.d/insomne"

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        isEnabled = loadState()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        updateStatusIcon()
        buildMenu()

        setupSudoersIfNeeded()

        // Comprobar actualizaciones al arrancar (en background)
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) {
            self.checkForUpdates(silent: true)
        }

        // Escuchar cambios de tema del sistema
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(themeChanged),
            name: NSNotification.Name("AppleInterfaceThemeChangedNotification"),
            object: nil
        )
    }

    // MARK: - Tema del sistema

    @objc func themeChanged() {
        updateStatusIcon()
    }

    func isDarkMode() -> Bool {
        let appearance = NSApp.effectiveAppearance
        return appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }

    // MARK: - Sudoers

    func setupSudoersIfNeeded() {
        guard !FileManager.default.fileExists(atPath: sudoersFile) else { return }
        let username = NSUserName()
        let rule = "\(username) ALL=(ALL) NOPASSWD: /usr/bin/pmset, /bin/rm"
        let script = "do shell script \"echo '\(rule)' | tee \(sudoersFile) && chmod 440 \(sudoersFile)\" with administrator privileges"
        DispatchQueue.global(qos: .userInitiated).async {
            var err: NSDictionary?
            NSAppleScript(source: script)?.executeAndReturnError(&err)
        }
    }

    // MARK: - Estado

    func loadState() -> Bool {
        let value = try? String(contentsOf: stateFile, encoding: .utf8)
        return value?.trimmingCharacters(in: .whitespacesAndNewlines) == "1"
    }

    func saveState(_ enabled: Bool) {
        try? (enabled ? "1" : "0").write(to: stateFile, atomically: true, encoding: .utf8)
    }

    // MARK: - Icon

    func updateStatusIcon() {
        guard let button = statusItem?.button else { return }
        let iconName = isEnabled ? "bolt.fill" : "bolt.slash.fill"
        if let image = NSImage(systemSymbolName: iconName, accessibilityDescription: nil) {
            image.isTemplate = true
            button.image = image
        }
        button.toolTip = isEnabled ? "Insomne: Activo" : "Insomne: Inactivo"
    }

    // MARK: - Menu

    func buildMenu() {
        let menu = NSMenu()

        let statusLabel = NSMenuItem(
            title: isEnabled ? "Estado: ✅ Encendido" : "Estado: ⚫ Apagado",
            action: nil, keyEquivalent: "")
        statusLabel.isEnabled = false
        menu.addItem(statusLabel)
        menu.addItem(.separator())

        let toggleItem = NSMenuItem(
            title: isEnabled ? "Apagar" : "Encender",
            action: #selector(toggleLidLock), keyEquivalent: "t")
        toggleItem.target = self
        menu.addItem(toggleItem)

        menu.addItem(.separator())

        let updateItem = NSMenuItem(
            title: "Buscar actualizaciones",
            action: #selector(checkUpdatesManual), keyEquivalent: "u")
        updateItem.target = self
        menu.addItem(updateItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(
            title: "Cerrar aplicación",
            action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    // MARK: - Toggle

    @objc func toggleLidLock() {
        let newValue = isEnabled ? "0" : "1"
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            if self.runPmset(value: newValue) {
                let nowEnabled = newValue == "1"
                self.saveState(nowEnabled)
                DispatchQueue.main.async {
                    self.isEnabled = nowEnabled
                    self.updateStatusIcon()
                    self.buildMenu()
                }
            }
        }
    }

    // MARK: - Actualizaciones

    @objc func checkUpdatesManual() {
        checkForUpdates(silent: false)
    }

    func checkForUpdates(silent: Bool) {
        // Compara el SHA del último commit en main con el que tiene instalado
        let urlString = "https://api.github.com/repos/\(GITHUB_USER)/\(GITHUB_REPO)/commits/main"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("Insomne/\(CURRENT_BUILD)", forHTTPHeaderField: "User-Agent")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                if !silent { DispatchQueue.main.async { self.showUpdateError() } }
                return
            }

            guard
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let sha = json["sha"] as? String
            else {
                if !silent { DispatchQueue.main.async { self.showUpdateError() } }
                return
            }

            // SHA corto (7 caracteres) para comparar
            let latestSHA = String(sha.prefix(7))
            let repoURL = "https://github.com/\(GITHUB_USER)/\(GITHUB_REPO)"

            // Leer el mensaje del último commit
            let commitMessage = (json["commit"] as? [String: Any])
                .flatMap { $0["message"] as? String }
                .map { $0.components(separatedBy: "\n").first ?? $0 }
                ?? "Nueva actualización disponible"

            DispatchQueue.main.async {
                if latestSHA != CURRENT_BUILD {
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
        alert.informativeText = "Último cambio: \(message)\n\nVersión instalada: \(CURRENT_BUILD)\nÚltima versión: \(sha)"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Ver en GitHub")
        alert.addButton(withTitle: "Ahora no")

        if alert.runModal() == .alertFirstButtonReturn {
            if let downloadURL = URL(string: url) {
                NSWorkspace.shared.open(downloadURL)
            }
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

    func showUpdateError() {
        let alert = NSAlert()
        alert.messageText = "No se pudo comprobar actualizaciones"
        alert.informativeText = "Comprueba tu conexión a internet e inténtalo de nuevo."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    // MARK: - Quit

    @objc func quitApp() {
        if isEnabled { _ = runPmset(value: "0"); saveState(false) }
        let task = Process()
        task.launchPath = "/usr/bin/sudo"
        task.arguments = ["rm", "-f", sudoersFile]
        task.standardOutput = Pipe(); task.standardError = Pipe()
        try? task.run(); task.waitUntilExit()
        DispatchQueue.main.async {
            NSApplication.shared.terminate(nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { exit(0) }
        }
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

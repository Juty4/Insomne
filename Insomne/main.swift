import AppKit

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
    }

    // MARK: - Sudoers (una sola vez)

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
            action: #selector(toggleInsomne), keyEquivalent: "t")
        toggleItem.target = self
        menu.addItem(toggleItem)
        menu.addItem(.separator())

        let quitItem = NSMenuItem(
            title: "Cerrar aplicación",
            action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    // MARK: - Actions

    @objc func toggleInsomne() {
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

    @objc func quitApp() {
        print("DEBUG: quitApp llamado, PID: \(ProcessInfo.processInfo.processIdentifier)")
        if isEnabled { _ = runPmset(value: "0"); saveState(false) }
        // Eliminar sudoers sin pedir contraseña (usamos sudo mientras aún tenemos acceso)
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
        // Fallback osascript
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

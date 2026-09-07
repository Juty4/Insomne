import AppKit

let GITHUB_USER    = "Juty4"
let GITHUB_REPO    = "Insomne"
let CURRENT_BUILD  = "BUILD_SHA"

// ─── LOCALIZATION ──────────────────────────────────────────────────────────

let strings: [String: [String: String]] = [
    "es": [
        "status_on": "Estado: ✅ Encendido",
        "status_off": "Estado: ⚫ Apagado",
        "turn_on": "Encender",
        "turn_off": "Apagar",
        "settings": "Ajustes...",
        "quit": "Cerrar aplicación",
        "tooltip_on": "Insomne: Activo",
        "tooltip_off": "Insomne: Inactivo",
        
        "pref_title": "Ajustes de Insomne",
        "pref_lang": "Idioma:",
        "pref_icon": "Icono (Buscador):",
        "pref_icon_dark": "Oscuro",
        "pref_icon_light": "Claro",
        "pref_update_btn": "Buscar actualizaciones",
        
        "upd_avail_title": "🎉 Hay una actualización disponible",
        "upd_avail_msg": "Último cambio: %@\n\n¿Quieres actualizar e instalar la nueva versión ahora?",
        "upd_btn_auto": "Actualizar automáticamente",
        "upd_btn_git": "Ver en GitHub",
        "upd_btn_later": "Ahora no",
        "upd_no_title": "✅ Insomne está al día",
        "upd_no_msg": "Tienes la última versión instalada (v%@).",
        "upd_err_title": "No se pudo comprobar actualizaciones",
        "upd_err_start": "Iniciando actualización de Insomne...",
        "upd_err_fail": "No se pudo iniciar la actualización automática. Inténtalo de forma manual."
    ],
    "en": [
        "status_on": "Status: ✅ On",
        "status_off": "Status: ⚫ Off",
        "turn_on": "Turn On",
        "turn_off": "Turn Off",
        "settings": "Settings...",
        "quit": "Quit",
        "tooltip_on": "Insomne: Active",
        "tooltip_off": "Insomne: Inactive",
        
        "pref_title": "Insomne Settings",
        "pref_lang": "Language:",
        "pref_icon": "App Icon (Finder):",
        "pref_icon_dark": "Dark",
        "pref_icon_light": "Light",
        "pref_update_btn": "Check for updates",
        
        "upd_avail_title": "🎉 Update available",
        "upd_avail_msg": "Latest change: %@\n\nDo you want to update and install the new version now?",
        "upd_btn_auto": "Update automatically",
        "upd_btn_git": "View on GitHub",
        "upd_btn_later": "Not now",
        "upd_no_title": "✅ Insomne is up to date",
        "upd_no_msg": "You have the latest version installed (v%@).",
        "upd_err_title": "Could not check for updates",
        "upd_err_start": "Starting Insomne update...",
        "upd_err_fail": "Could not start automatic update. Please try manually."
    ],
    "fr": [
        "status_on": "Statut: ✅ Activé",
        "status_off": "Statut: ⚫ Désactivé",
        "turn_on": "Activer",
        "turn_off": "Désactiver",
        "settings": "Paramètres...",
        "quit": "Quitter l'application",
        "tooltip_on": "Insomne: Actif",
        "tooltip_off": "Insomne: Inactif",
        "pref_title": "Paramètres Insomne",
        "pref_lang": "Langue:",
        "pref_icon": "Icône (Finder):",
        "pref_icon_dark": "Sombre",
        "pref_icon_light": "Clair",
        "pref_update_btn": "Vérifier les mises à jour",
        "upd_avail_title": "🎉 Mise à jour disponible",
        "upd_avail_msg": "Dernière modification: %@\n\nVoulez-vous mettre à jour et installer la nouvelle version maintenant?",
        "upd_btn_auto": "Mettre à jour automatiquement",
        "upd_btn_git": "Voir sur GitHub",
        "upd_btn_later": "Plus tard",
        "upd_no_title": "✅ Insomne est à jour",
        "upd_no_msg": "Vous avez la dernière version installée (v%@).",
        "upd_err_title": "Impossible de vérifier les mises à jour",
        "upd_err_start": "Démarrage de la mise à jour d'Insomne...",
        "upd_err_fail": "Impossible de démarrer la mise à jour automatique. Veuillez essayer manuellement."
    ],
    "de": [
        "status_on": "Status: ✅ Ein",
        "status_off": "Status: ⚫ Aus",
        "turn_on": "Einschalten",
        "turn_off": "Ausschalten",
        "settings": "Einstellungen...",
        "quit": "Beenden",
        "tooltip_on": "Insomne: Aktiv",
        "tooltip_off": "Insomne: Inaktiv",
        "pref_title": "Insomne Einstellungen",
        "pref_lang": "Sprache:",
        "pref_icon": "App-Symbol:",
        "pref_icon_dark": "Dunkel",
        "pref_icon_light": "Hell",
        "pref_update_btn": "Nach Updates suchen",
        "upd_avail_title": "🎉 Update verfügbar",
        "upd_avail_msg": "Letzte Änderung: %@\n\nMöchten Sie die neue Version jetzt aktualisieren und installieren?",
        "upd_btn_auto": "Automatisch aktualisieren",
        "upd_btn_git": "Auf GitHub ansehen",
        "upd_btn_later": "Später",
        "upd_no_title": "✅ Insomne ist auf dem neuesten Stand",
        "upd_no_msg": "Sie haben die neueste Version installiert (v%@).",
        "upd_err_title": "Updates konnten nicht überprüft werden",
        "upd_err_start": "Update von Insomne wird gestartet...",
        "upd_err_fail": "Automatisches Update konnte nicht gestartet werden. Bitte manuell versuchen."
    ],
    "pt": [
        "status_on": "Status: ✅ Ligado",
        "status_off": "Status: ⚫ Desligado",
        "turn_on": "Ligar",
        "turn_off": "Desligar",
        "settings": "Configurações...",
        "quit": "Sair",
        "tooltip_on": "Insomne: Ativo",
        "tooltip_off": "Insomne: Inativo",
        "pref_title": "Configurações Insomne",
        "pref_lang": "Idioma:",
        "pref_icon": "Ícone do App:",
        "pref_icon_dark": "Escuro",
        "pref_icon_light": "Claro",
        "pref_update_btn": "Verificar atualizações",
        "upd_avail_title": "🎉 Atualização disponível",
        "upd_avail_msg": "Última alteração: %@\n\nDeseja atualizar e instalar a nova versão agora?",
        "upd_btn_auto": "Atualizar automaticamente",
        "upd_btn_git": "Ver no GitHub",
        "upd_btn_later": "Agora não",
        "upd_no_title": "✅ Insomne está atualizado",
        "upd_no_msg": "Você tem a versão mais recente instalada (v%@).",
        "upd_err_title": "Não foi possível verificar",
        "upd_err_start": "Iniciando atualização...",
        "upd_err_fail": "Não foi possível iniciar a atualização automática."
    ],
    "zh": [
        "status_on": "状态: ✅ 已开启",
        "status_off": "状态: ⚫ 已关闭",
        "turn_on": "开启",
        "turn_off": "关闭",
        "settings": "设置...",
        "quit": "退出",
        "tooltip_on": "Insomne: 运行中",
        "tooltip_off": "Insomne: 未运行",
        "pref_title": "Insomne 设置",
        "pref_lang": "语言:",
        "pref_icon": "应用图标:",
        "pref_icon_dark": "深色",
        "pref_icon_light": "浅色",
        "pref_update_btn": "检查更新",
        "upd_avail_title": "🎉 发现新版本",
        "upd_avail_msg": "最新更改: %@\n\n您想现在自动更新并安装新版本吗？",
        "upd_btn_auto": "自动更新",
        "upd_btn_git": "在 GitHub 查看",
        "upd_btn_later": "稍后",
        "upd_no_title": "✅ 已是最新版本",
        "upd_no_msg": "您已安装最新版本 (v%@)。",
        "upd_err_title": "无法检查更新",
        "upd_err_start": "正在启动更新...",
        "upd_err_fail": "无法启动自动更新，请手动重试。"
    ]
]

func loc(_ key: String, _ args: CVarArg...) -> String {
    let lang = UserDefaults.standard.string(forKey: "appLanguage") ?? "es"
    let dict = strings[lang] ?? strings["es"]!
    let format = dict[key] ?? key
    if args.isEmpty { return format }
    return String(format: format, arguments: args)
}

// ─── AppDelegate ───────────────────────────────────────────────────────────

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!
    var isEnabled: Bool = false
    
    var statusMenuItem: NSMenuItem!
    var toggleMenuItem: NSMenuItem!
    var settingsMenuItem: NSMenuItem!
    var quitMenuItem: NSMenuItem!

    let sudoersFile = "/etc/sudoers.d/insomne"
    
    var prefWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        // Set default language if not set
        if UserDefaults.standard.string(forKey: "appLanguage") == nil {
            UserDefaults.standard.set("es", forKey: "appLanguage")
        }
        if UserDefaults.standard.string(forKey: "appIconTheme") == nil {
            UserDefaults.standard.set("dark", forKey: "appIconTheme")
        }

        isEnabled = UserDefaults.standard.bool(forKey: "isInsomneEnabled")
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        buildMenu()
        updateStatusIcon()
        updateMenuItems()

        setupSudoersIfNeeded()

        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) {
            self.checkForUpdates(silent: true)
        }
    }

    func setupSudoersIfNeeded() {
        guard !FileManager.default.fileExists(atPath: sudoersFile) else { return }
        let username = NSUserName()
        let rule = "\(username) ALL=(ALL) NOPASSWD: /usr/bin/pmset"
        let script = "do shell script \"echo '\(rule)' | tee \(sudoersFile) && chmod 440 \(sudoersFile)\" with administrator privileges"
        DispatchQueue.global(qos: .userInitiated).async {
            var err: NSDictionary?
            NSAppleScript(source: script)?.executeAndReturnError(&err)
        }
    }

    func updateStatusIcon() {
        guard let button = statusItem?.button else { return }
        let iconName = isEnabled ? "bolt.fill" : "bolt.slash.fill"
        if let image = NSImage(systemSymbolName: iconName, accessibilityDescription: nil) {
            image.isTemplate = true 
            button.image = image
        }
        button.toolTip = isEnabled ? loc("tooltip_on") : loc("tooltip_off")
    }

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

        settingsMenuItem = NSMenuItem(title: "", action: #selector(openSettings), keyEquivalent: ",")
        settingsMenuItem.target = self
        menu.addItem(settingsMenuItem)

        menu.addItem(.separator())

        quitMenuItem = NSMenuItem(title: "", action: #selector(quitApp), keyEquivalent: "q")
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)

        statusItem.menu = menu
    }
    
    func updateMenuItems() {
        statusMenuItem.title = isEnabled ? loc("status_on") : loc("status_off")
        toggleMenuItem.title = isEnabled ? loc("turn_off") : loc("turn_on")
        settingsMenuItem.title = loc("settings")
        quitMenuItem.title = loc("quit")
        statusItem?.button?.toolTip = isEnabled ? loc("tooltip_on") : loc("tooltip_off")
    }

    @objc func toggleLidLock() {
        let newValue = isEnabled ? "0" : "1"
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            if self.runPmset(value: newValue) {
                let nowEnabled = newValue == "1"
                UserDefaults.standard.set(nowEnabled, forKey: "isInsomneEnabled")
                DispatchQueue.main.async {
                    self.isEnabled = nowEnabled
                    self.updateStatusIcon()
                    self.updateMenuItems()
                }
            }
        }
    }

    // MARK: - Ajustes / Settings

    @objc func openSettings() {
        if prefWindow != nil {
            prefWindow?.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 320, height: 200),
                              styleMask: [.titled, .closable],
                              backing: .buffered, defer: false)
        window.title = loc("pref_title")
        window.center()
        window.isReleasedWhenClosed = false
        
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 320, height: 200))
        
        // Language Label
        let lblLang = NSTextField(labelWithString: loc("pref_lang"))
        lblLang.isEditable = false; lblLang.isBordered = false; lblLang.drawsBackground = false
        lblLang.frame = NSRect(x: 20, y: 150, width: 140, height: 20)
        view.addSubview(lblLang)
        
        // Language PopUp
        let popLang = NSPopUpButton(frame: NSRect(x: 160, y: 145, width: 140, height: 25), pullsDown: false)
        let langCodes = ["es", "en", "fr", "de", "pt", "zh"]
        popLang.addItems(withTitles: ["Español", "English", "Français", "Deutsch", "Português", "中文"])
        let currentLang = UserDefaults.standard.string(forKey: "appLanguage") ?? "es"
        if let idx = langCodes.firstIndex(of: currentLang) {
            popLang.selectItem(at: idx)
        }
        popLang.target = self
        popLang.action = #selector(languageChanged(_:))
        view.addSubview(popLang)
        
        // Icon Label
        let lblIcon = NSTextField(labelWithString: loc("pref_icon"))
        lblIcon.isEditable = false; lblIcon.isBordered = false; lblIcon.drawsBackground = false
        lblIcon.frame = NSRect(x: 20, y: 100, width: 140, height: 20)
        view.addSubview(lblIcon)
        
        // Icon PopUp
        let popIcon = NSPopUpButton(frame: NSRect(x: 160, y: 95, width: 140, height: 25), pullsDown: false)
        popIcon.addItems(withTitles: [loc("pref_icon_dark"), loc("pref_icon_light")])
        let currentIcon = UserDefaults.standard.string(forKey: "appIconTheme") ?? "dark"
        popIcon.selectItem(at: currentIcon == "light" ? 1 : 0)
        popIcon.target = self
        popIcon.action = #selector(iconChanged(_:))
        view.addSubview(popIcon)
        
        // Update Button
        let btnUpdate = NSButton(frame: NSRect(x: 60, y: 30, width: 200, height: 30))
        btnUpdate.title = loc("pref_update_btn")
        btnUpdate.bezelStyle = .rounded
        btnUpdate.target = self
        btnUpdate.action = #selector(checkUpdatesManual)
        view.addSubview(btnUpdate)
        
        window.contentView = view
        prefWindow = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: window, queue: nil) { [weak self] _ in
            self?.prefWindow = nil
        }
    }
    
    @objc func languageChanged(_ sender: NSPopUpButton) {
        let langCodes = ["es", "en", "fr", "de", "pt", "zh"]
        let lang = langCodes[sender.indexOfSelectedItem]
        UserDefaults.standard.set(lang, forKey: "appLanguage")
        // Update UI immediately
        updateMenuItems()
        if let win = prefWindow {
            let p = win.frame.origin
            win.close()
            openSettings() // Reload window to translate labels
            prefWindow?.setFrameOrigin(p)
        }
    }
    
    @objc func iconChanged(_ sender: NSPopUpButton) {
        let theme = sender.indexOfSelectedItem == 1 ? "light" : "dark"
        UserDefaults.standard.set(theme, forKey: "appIconTheme")
        
        let appPath = Bundle.main.bundlePath
        let themeName = theme.capitalized
        let script = """
        #!/bin/bash
        cd "\(appPath)/Contents/Resources"
        cp "AppIcon\(themeName).icns" "AppIcon.icns"
        touch "\(appPath)"
        killall Finder
        """
        
        DispatchQueue.global(qos: .userInitiated).async {
            let task = Process()
            task.launchPath = "/bin/bash"
            task.arguments = ["-c", script]
            try? task.run()
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
                if !silent { DispatchQueue.main.async { self.showUpdateError("Error de conexión.") } }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 403 {
                if !silent { DispatchQueue.main.async { self.showUpdateError("Límite de GitHub. Intenta luego.") } }
                return
            }

            guard
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let sha = json["sha"] as? String
            else {
                if !silent { DispatchQueue.main.async { self.showUpdateError("Respuesta inválida.") } }
                return
            }

            let latestSHA = String(sha.prefix(7))
            let repoURL = "https://github.com/\(GITHUB_USER)/\(GITHUB_REPO)"

            let commitMessage = (json["commit"] as? [String: Any])
                .flatMap { $0["message"] as? String }
                .map { $0.components(separatedBy: "\n").first ?? $0 }
                ?? "Update available"

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
        alert.messageText = loc("upd_avail_title")
        alert.informativeText = loc("upd_avail_msg", message)
        alert.alertStyle = .informational
        
        alert.addButton(withTitle: loc("upd_btn_auto"))
        alert.addButton(withTitle: loc("upd_btn_git"))
        alert.addButton(withTitle: loc("upd_btn_later"))

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
        let errStart = loc("upd_err_start")
        let updateScript = """
        #!/bin/bash
        sleep 2
        echo "\(errStart)"
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
            showUpdateError(loc("upd_err_fail"))
        }
    }

    func showNoUpdates() {
        let alert = NSAlert()
        alert.messageText = loc("upd_no_title")
        alert.informativeText = loc("upd_no_msg", CURRENT_BUILD)
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    func showUpdateError(_ message: String) {
        let alert = NSAlert()
        alert.messageText = loc("upd_err_title")
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
        NSApplication.shared.terminate(nil)
        exit(0)
    }

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
            return false
        }
        return true
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()

import UIKit

class MainViewController: UIViewController {
    
    var state = SessionState()
    var scanner = SlotScanner.shared
    var injector = DylibInjector.shared
    
    // UI Components
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    let dyld4PathLabel = UILabel()
    let dyld4PathValue = UILabel()
    let dyld4Button = UIButton()
    
    let uuidLabel = UILabel()
    let uuidInput = UITextField()
    let uuidFromPhoneButton = UIButton()
    let uuidAutoButton = UIButton()
    
    let dylibPathLabel = UILabel()
    let dylibPathValue = UILabel()
    let dylibButton = UIButton()
    
    let dylibNameLabel = UILabel()
    let dylibNameInput = UITextField()
    
    let scanButton = UIButton()
    let slotCountLabel = UILabel()
    let bestSlotLabel = UILabel()
    
    let slotTableView = UITableView()
    var slotTableHeightConstraint: NSLayoutConstraint?
    
    let consoleLabel = UILabel()
    let consoleView = UITextView()
    
    let injectButton = UIButton()
    let resetButton = UIButton()
    
    let statusLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SMART INJECTOR v10.0"
        view.backgroundColor = AppConfig.bgMain
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = AppConfig.bgNav
        navigationController?.navigationBar.backgroundColor = AppConfig.bgNav
        
        setupUI()
        ConsoleLogger.shared.onLogMessage = { [weak self] msg, color in
            self?.appendToConsole(msg, color: color)
        }
    }
    
    func setupUI() {
        scrollView.backgroundColor = AppConfig.bgMain
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
        
        // File Selection Card
        addSectionHeader("📁 CHỌN FILE")
        
        // Dyld4
        dyld4PathLabel.text = "File dyld4:"
        dyld4PathLabel.textColor = AppConfig.fgSecondary
        dyld4PathLabel.font = .systemFont(ofSize: 12)
        stackView.addArrangedSubview(dyld4PathLabel)
        
        dyld4PathValue.text = "Chưa chọn"
        dyld4PathValue.textColor = AppConfig.fgPrimary
        dyld4PathValue.font = .systemFont(ofSize: 13)
        dyld4PathValue.numberOfLines = 2
        stackView.addArrangedSubview(dyld4PathValue)
        
        dyld4Button.setTitle("Chọn dyld4", for: .normal)
        dyld4Button.addTarget(self, action: #selector(selectDyld4), for: .touchUpInside)
        stylePrimaryButton(dyld4Button)
        stackView.addArrangedSubview(dyld4Button)
        
        // UUID
        addSectionHeader("🆔 UUID")
        
        uuidLabel.text = "UUID iPhone:"
        uuidLabel.textColor = AppConfig.fgSecondary
        uuidLabel.font = .systemFont(ofSize: 12)
        stackView.addArrangedSubview(uuidLabel)
        
        uuidInput.placeholder = "Nhập hoặc lấy từ iPhone/dyld4"
        uuidInput.textColor = AppConfig.fgPrimary
        uuidInput.backgroundColor = AppConfig.bgEntry
        uuidInput.borderStyle = .roundedRect
        uuidInput.layer.cornerRadius = 8
        uuidInput.layer.masksToBounds = true
        uuidInput.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView.addArrangedSubview(uuidInput)
        
        let uuidButtonStack = UIStackView()
        uuidButtonStack.axis = .horizontal
        uuidButtonStack.spacing = 8
        uuidButtonStack.distribution = .fillEqually
        
        uuidFromPhoneButton.setTitle("Từ iPhone", for: .normal)
        uuidFromPhoneButton.addTarget(self, action: #selector(getUUIDFromPhone), for: .touchUpInside)
        styleSecondaryButton(uuidFromPhoneButton)
        uuidButtonStack.addArrangedSubview(uuidFromPhoneButton)
        
        uuidAutoButton.setTitle("Tự động từ dyld4", for: .normal)
        uuidAutoButton.addTarget(self, action: #selector(getUUIDFromDyld4), for: .touchUpInside)
        styleSecondaryButton(uuidAutoButton)
        uuidButtonStack.addArrangedSubview(uuidAutoButton)
        
        stackView.addArrangedSubview(uuidButtonStack)
        
        // Dylib
        addSectionHeader("📦 DYLIB")
        
        dylibPathLabel.text = "File dylib:"
        dylibPathLabel.textColor = AppConfig.fgSecondary
        dylibPathLabel.font = .systemFont(ofSize: 12)
        stackView.addArrangedSubview(dylibPathLabel)
        
        dylibPathValue.text = "Chưa chọn"
        dylibPathValue.textColor = AppConfig.fgPrimary
        dylibPathValue.font = .systemFont(ofSize: 13)
        dylibPathValue.numberOfLines = 2
        stackView.addArrangedSubview(dylibPathValue)
        
        dylibButton.setTitle("Chọn dylib", for: .normal)
        dylibButton.addTarget(self, action: #selector(selectDylib), for: .touchUpInside)
        stylePrimaryButton(dylibButton)
        stackView.addArrangedSubview(dylibButton)
        
        dylibNameLabel.text = "Tên dylib output:"
        dylibNameLabel.textColor = AppConfig.fgSecondary
        dylibNameLabel.font = .systemFont(ofSize: 12)
        stackView.addArrangedSubview(dylibNameLabel)
        
        dylibNameInput.placeholder = "VD: my_tweak.dylib"
        dylibNameInput.textColor = AppConfig.fgPrimary
        dylibNameInput.backgroundColor = AppConfig.bgEntry
        dylibNameInput.borderStyle = .roundedRect
        dylibNameInput.layer.cornerRadius = 8
        dylibNameInput.layer.masksToBounds = true
        dylibNameInput.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView.addArrangedSubview(dylibNameInput)
        
        // Scan
        addSectionHeader("🔍 SMART SCAN")
        
        scanButton.setTitle("Bắt đầu SMART SCAN", for: .normal)
        scanButton.addTarget(self, action: #selector(startSmartScan), for: .touchUpInside)
        stylePrimaryButton(scanButton)
        stackView.addArrangedSubview(scanButton)
        
        slotCountLabel.text = "Slots: 0"
        slotCountLabel.textColor = AppConfig.fgAccent
        slotCountLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        stackView.addArrangedSubview(slotCountLabel)
        
        bestSlotLabel.text = ""
        bestSlotLabel.textColor = AppConfig.fgAccent
        bestSlotLabel.font = .systemFont(ofSize: 12)
        stackView.addArrangedSubview(bestSlotLabel)
        
        // Slot Table
        slotTableView.delegate = self
        slotTableView.dataSource = self
        slotTableView.register(UITableViewCell.self, forCellReuseIdentifier: "slot")
        slotTableView.backgroundColor = AppConfig.bgCard
        slotTableView.layer.cornerRadius = 8
        slotTableView.layer.masksToBounds = true
        slotTableView.separatorColor = AppConfig.bgNav
        slotTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.addArrangedSubview(slotTableView)
        
        // Console
        consoleLabel.text = "📋 CONSOLE"
        consoleLabel.textColor = AppConfig.fgAccent
        consoleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        stackView.addArrangedSubview(consoleLabel)
        
        consoleView.backgroundColor = AppConfig.bgConsole
        consoleView.textColor = AppConfig.fgPrimary
        consoleView.isEditable = false
        consoleView.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
        consoleView.layer.cornerRadius = 8
        consoleView.layer.masksToBounds = true
        consoleView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        stackView.addArrangedSubview(consoleView)
        
        // Actions
        injectButton.setTitle("✅ INJECT & PATCH", for: .normal)
        injectButton.addTarget(self, action: #selector(executeInject), for: .touchUpInside)
        stylePrimaryButton(injectButton)
        stackView.addArrangedSubview(injectButton)
        
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        styleSecondaryButton(resetButton)
        stackView.addArrangedSubview(resetButton)
        
        statusLabel.text = ""
        statusLabel.textColor = AppConfig.fgAccent
        statusLabel.textAlignment = .center
        statusLabel.font = .systemFont(ofSize: 12)
        stackView.addArrangedSubview(statusLabel)
    }
    
    func addSectionHeader(_ text: String) {
        let header = UILabel()
        header.text = text
        header.textColor = AppConfig.fgAccent
        header.font = .systemFont(ofSize: 14, weight: .semibold)
        stackView.addArrangedSubview(header)
    }
    
    func stylePrimaryButton(_ button: UIButton) {
        button.setTitleColor(AppConfig.bgMain, for: .normal)
        button.backgroundColor = AppConfig.bgSelect
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.heightAnchor.constraint(equalToConstant: UIConfig.buttonHeight).isActive = true
    }
    
    func styleSecondaryButton(_ button: UIButton) {
        button.setTitleColor(AppConfig.bgSelect, for: .normal)
        button.backgroundColor = AppConfig.bgCard
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = AppConfig.bgSelect.cgColor
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func selectDyld4() {
        ConsoleLogger.shared.log("Mở file picker", level: .info)
    }
    
    @objc func selectDylib() {
        ConsoleLogger.shared.log("Mở file picker dylib", level: .info)
    }
    
    @objc func getUUIDFromPhone() {
        ConsoleLogger.shared.log("Kết nối iPhone qua USB...", level: .info)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ConsoleLogger.shared.log("Chưa hỗ trợ trên thiết bị này", level: .warning)
        }
    }
    
    @objc func getUUIDFromDyld4() {
        guard let data = state.dyld4Data else {
            ConsoleLogger.shared.log("Chọn file dyld4 trước", level: .warning)
            return
        }
        
        if let uuid = DyldPatcher.shared.extractUUID(from: data) {
            uuidInput.text = uuid
            state.uuid = uuid
            ConsoleLogger.shared.log("Tìm thấy UUID: \(uuid)", level: .success)
        } else {
            ConsoleLogger.shared.log("Không tìm thấy UUID trong dyld4", level: .warning)
        }
    }
    
    @objc func startSmartScan() {
        guard let data = state.dyld4Data else {
            ConsoleLogger.shared.log("Vui lòng chọn file dyld4 trước", level: .error)
            return
        }
        
        ConsoleLogger.shared.log("Bắt đầu SMART SCAN...", level: .info)
        
        state.slots = scanner.smartScan(data)
        state.bestSlot = scanner.findBestSlot(state.slots)
        
        ConsoleLogger.shared.log("Tìm thấy \(state.slots.count) vị trí", level: .success)
        
        if let best = state.bestSlot {
            bestSlotLabel.text = "⭐ BEST: 0x\(String(format: "%08X", best.offset))"
            ConsoleLogger.shared.log("Vị trí tốt nhất: 0x\(String(format: "%08X", best.offset))", level: .info)
        }
        
        slotCountLabel.text = "Slots: \(state.slots.count)"
        slotTableView.reloadData()
    }
    
    @objc func executeInject() {
        guard !state.uuid.isEmpty else {
            ConsoleLogger.shared.log("Vui lòng nhập UUID", level: .error)
            return
        }
        
        guard let selectedSlot = state.selectedSlot else {
            ConsoleLogger.shared.log("Vui lòng chọn slot", level: .error)
            return
        }
        
        guard let dyld4Data = state.dyld4Data else {
            ConsoleLogger.shared.log("Không có dữ liệu dyld4", level: .error)
            return
        }
        
        let dylibName = (dylibNameInput.text ?? "tweak").appending(
            (dylibNameInput.text?.hasSuffix(".dylib") ?? false) ? "" : ".dylib"
        )
        
        ConsoleLogger.shared.log("═══════════════════════════", level: .info)
        ConsoleLogger.shared.log("Đang inject dylib...", level: .info)
        ConsoleLogger.shared.log("UUID: \(state.uuid)", level: .debug)
        ConsoleLogger.shared.log("Vị trí: 0x\(String(format: "%08X", selectedSlot.offset))", level: .debug)
        ConsoleLogger.shared.log("Dylib: \(dylibName)", level: .debug)
        
        let newPath = "/private/var/mobile/Containers/Data/Application/\(state.uuid)/Library/Caches/com.apple.dyld/\(dylibName)"
        
        let patchResult = DyldPatcher.shared.patchDyld4(
            data: dyld4Data,
            slotOffset: selectedSlot.offset,
            slotLength: selectedSlot.length,
            newPath: newPath,
            uuid: state.uuid,
            dylibName: dylibName
        )
        
        if patchResult.success, let patchedData = patchResult.patchedData {
            ConsoleLogger.shared.log("Patch thành công!", level: .success)
            
            let outputFolder = FileOperations.shared.createSuccessFolder()
            ConsoleLogger.shared.log("Thư mục output: \(outputFolder)", level: .info)
            
            let success = FileOperations.shared.saveResultsToFolder(
                outputFolder,
                patchedDyld4: patchedData,
                dylibPath: state.dylibPath,
                dylibName: dylibName,
                uuid: state.uuid,
                slotOffset: selectedSlot.offset
            )
            
            if success {
                ConsoleLogger.shared.log("✅ INJECT THÀNH CÔNG!", level: .success)
                statusLabel.text = "✅ Inject thành công!"
                statusLabel.textColor = AppConfig.fgAccent
            } else {
                ConsoleLogger.shared.log("Lỗi xuất file", level: .error)
                statusLabel.text = "❌ Lỗi xuất file"
                statusLabel.textColor = AppConfig.fgError
            }
        } else {
            ConsoleLogger.shared.log("Lỗi patch: \(patchResult.error ?? "Unknown")", level: .error)
            statusLabel.text = "❌ Patch thất bại"
            statusLabel.textColor = AppConfig.fgError
        }
    }
    
    @objc func reset() {
        state = SessionState()
        uuidInput.text = ""
        dylibNameInput.text = ""
        dyld4PathValue.text = "Chưa chọn"
        dylibPathValue.text = "Chưa chọn"
        slotCountLabel.text = "Slots: 0"
        bestSlotLabel.text = ""
        statusLabel.text = ""
        consoleView.text = ""
        ConsoleLogger.shared.log("✅ Đã reset", level: .success)
    }
    
    func appendToConsole(_ message: String, color: UIColor) {
        DispatchQueue.main.async { [weak self] in
            let attributedString = NSAttributedString(string: message + "\n", attributes: [
                .foregroundColor: color,
                .font: UIFont.monospacedSystemFont(ofSize: 11, weight: .regular)
            ])
            
            self?.consoleView.textStorage.append(attributedString)
            
            let range = NSRange(location: (self?.consoleView.text ?? "").count, length: 0)
            self?.consoleView.scrollRangeToVisible(range)
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.slots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "slot", for: indexPath)
        let slot = state.slots[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = "[\(indexPath.row)] \(slot.path.prefix(50))..."
        config.textProperties.color = AppConfig.fgPrimary
        config.textProperties.font = .systemFont(ofSize: 12)
        
        if slot.offset == state.bestSlot?.offset {
            config.text = "⭐ " + (config.text ?? "")
        }
        
        cell.contentConfiguration = config
        cell.backgroundColor = AppConfig.bgCard
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        state.selectedSlot = state.slots[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

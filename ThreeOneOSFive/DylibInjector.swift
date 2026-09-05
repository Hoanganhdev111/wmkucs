import Foundation

class DylibInjector {
    
    static let shared = DylibInjector()
    
    struct InjectionConfig {
        let dylibPath: String
        let dyld4Path: String
        let uuid: String
        let dylibName: String
        let slotOffset: UInt32
        let slotLength: UInt32
    }
    
    struct InjectionResult {
        let success: Bool
        let patchedDyld4: Data?
        let outputPath: String?
        let error: String?
        let log: [String]
    }
    
    func inject(config: InjectionConfig) -> InjectionResult {
        var logs: [String] = []
        
        logs.append("════════════════════════════════════")
        logs.append("[*] Đang inject dylib...")
        logs.append("[*] UUID: \(config.uuid)")
        logs.append("[*] Vị trí: offset 0x\(String(format: "%08X", config.slotOffset))")
        logs.append("[*] Tên dylib: \(config.dylibName)")
        
        do {
            let dyld4Data = try Data(contentsOf: URL(fileURLWithPath: config.dyld4Path))
            logs.append("[+] Đã đọc dyld4: \(dyld4Data.count) bytes")
            
            let newPath = "/private/var/mobile/Containers/Data/Application/\(config.uuid)/Library/Caches/com.apple.dyld/\(config.dylibName)"
            logs.append("[*] Đường dẫn mới: \(newPath)")
            
            let patchResult = DyldPatcher.shared.patchDyld4(
                data: dyld4Data,
                slotOffset: config.slotOffset,
                slotLength: config.slotLength,
                newPath: newPath,
                uuid: config.uuid,
                dylibName: config.dylibName
            )
            
            if !patchResult.success {
                logs.append("[!] Lỗi patch: \(patchResult.error ?? "Unknown")")
                return InjectionResult(success: false, patchedDyld4: nil, 
                                     outputPath: nil, error: patchResult.error, log: logs)
            }
            
            logs.append("[+] Patch thành công!")
            logs.append("[✅] INJECT THÀNH CÔNG!")
            
            return InjectionResult(success: true, patchedDyld4: patchResult.patchedData,
                                 outputPath: newPath, error: nil, log: logs)
            
        } catch let error {
            logs.append("[!] Lỗi: \(error.localizedDescription)")
            return InjectionResult(success: false, patchedDyld4: nil,
                                 outputPath: nil, error: error.localizedDescription, log: logs)
        }
    }
    
    func createSuccessFolder() -> String {
        let fm = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let folderName = "(wm)-success-\(timestamp)"
        let fullPath = (documentsPath as NSString).appendingPathComponent(folderName)
        
        try? fm.createDirectory(atPath: fullPath, withIntermediateDirectories: true)
        return fullPath
    }
    
    func exportFiles(config: InjectionConfig, 
                    patchedDyld4: Data,
                    outputDir: String) -> Bool {
        let fm = FileManager.default
        
        let dyld4Output = (outputDir as NSString).appendingPathComponent("Locket.dyld4")
        let dylibOutput = (outputDir as NSString).appendingPathComponent(config.dylibName)
        
        do {
            try patchedDyld4.write(to: URL(fileURLWithPath: dyld4Output))
            try FileManager.default.copyItem(atPath: config.dylibPath, toPath: dylibOutput)
            
            let readme = """
            ════════════════════════════════════
            SMART INJECTOR v10.0
            (wm)-success
            ════════════════════════════════════
            
            Thư mục: \(outputDir)
            Thời gian: \(Date())
            UUID: \(config.uuid)
            Slot offset: 0x\(String(format: "%08X", config.slotOffset))
            
            ════════════════════════════════════
            HƯỚNG DẪN COPY QUA 3105:
            - Copy \(config.dylibName) vào: /private/var/mobile/Containers/Data/Application/\(config.uuid)/Library/Caches/com.apple.dyld/
            - Copy Locket.dyld4 vào cùng thư mục
            - Kill Locket và mở lại
            ════════════════════════════════════
            """
            
            let readmePath = (outputDir as NSString).appendingPathComponent("README.txt")
            try readme.write(toFile: readmePath, atomically: true, encoding: .utf8)
            
            return true
        } catch {
            return false
        }
    }
}

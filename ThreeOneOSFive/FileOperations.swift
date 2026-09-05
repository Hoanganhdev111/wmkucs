import Foundation

class FileOperations {
    
    static let shared = FileOperations()
    
    func readFile(at path: String) throws -> Data {
        return try Data(contentsOf: URL(fileURLWithPath: path))
    }
    
    func writeFile(_ data: Data, at path: String) throws {
        try data.write(to: URL(fileURLWithPath: path))
    }
    
    func copyFile(from: String, to: String) throws {
        try FileManager.default.copyItem(atPath: from, toPath: to)
    }
    
    func createDirectory(at path: String) throws {
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
    }
    
    func fileExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    func getDocumentsPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    func createSuccessFolder() -> String {
        let documentsPath = getDocumentsPath()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HHmmss"
        let timestamp = formatter.string(from: Date())
        
        let folderName = "(wm)-success-\(timestamp)"
        let fullPath = (documentsPath as NSString).appendingPathComponent(folderName)
        
        try? createDirectory(at: fullPath)
        return fullPath
    }
    
    func saveResultsToFolder(_ folder: String,
                           patchedDyld4: Data,
                           dylibPath: String,
                           dylibName: String,
                           uuid: String,
                           slotOffset: UInt32) -> Bool {
        
        let dyld4Output = (folder as NSString).appendingPathComponent("Locket.dyld4")
        let dylibOutput = (folder as NSString).appendingPathComponent(dylibName)
        let readmeOutput = (folder as NSString).appendingPathComponent("README.txt")
        
        do {
            try patchedDyld4.write(to: URL(fileURLWithPath: dyld4Output))
            try FileManager.default.copyItem(atPath: dylibPath, toPath: dylibOutput)
            
            let readmeContent = """
            ════════════════════════════════════
            SMART INJECTOR v10.0
            (wm)-success
            ════════════════════════════════════
            
            Thư mục: \(folder)
            Thời gian: \(Date())
            UUID: \(uuid)
            Slot offset: 0x\(String(format: "%08X", slotOffset))
            
            ════════════════════════════════════
            HƯỚNG DẪN COPY QUA 3105:
            
            1. Copy \(dylibName) vào:
               /private/var/mobile/Containers/Data/Application/\(uuid)/Library/Caches/com.apple.dyld/
            
            2. Copy Locket.dyld4 vào cùng thư mục
            
            3. Kill Locket và mở lại
            
            ════════════════════════════════════
            """
            
            try readmeContent.write(toFile: readmeOutput, atomically: true, encoding: .utf8)
            return true
            
        } catch {
            return false
        }
    }
}

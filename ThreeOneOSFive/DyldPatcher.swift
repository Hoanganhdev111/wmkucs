import Foundation

class DyldPatcher {
    
    struct PatchResult {
        let success: Bool
        let patchedData: Data?
        let error: String?
        let newPath: String
        let offset: UInt32
    }
    
    static let shared = DyldPatcher()
    
    func patchDyld4(data: Data, 
                    slotOffset: UInt32, 
                    slotLength: UInt32,
                    newPath: String,
                    uuid: String,
                    dylibName: String) -> PatchResult {
        
        guard newPath.count < slotLength else {
            let err = "Đường dẫn quá dài! (\(newPath.count) > \(slotLength))"
            return PatchResult(success: false, patchedData: nil, 
                             error: err, newPath: "", offset: slotOffset)
        }
        
        var patchedData = data
        let newPathData = newPath.data(using: .utf8) ?? Data()
        let rangeStart = Int(slotOffset)
        let rangeEnd = rangeStart + Int(slotLength)
        
        guard rangeEnd <= patchedData.count else {
            return PatchResult(success: false, patchedData: nil,
                             error: "Vị trí slot không hợp lệ", 
                             newPath: "", offset: slotOffset)
        }
        
        let zeroBytes = [UInt8](repeating: 0, count: Int(slotLength))
        patchedData.replaceSubrange(rangeStart..<rangeEnd, with: zeroBytes)
        
        if newPathData.count > 0 {
            patchedData.replaceSubrange(rangeStart..<(rangeStart + newPathData.count), 
                                       with: newPathData)
        }
        
        let constructedPath = "/private/var/mobile/Containers/Data/Application/\(uuid)/Library/Caches/com.apple.dyld/\(dylibName)"
        
        return PatchResult(success: true, patchedData: patchedData, 
                         error: nil, newPath: constructedPath, offset: slotOffset)
    }
    
    func extractStrings(from data: Data, minLength: Int = 4) -> [(offset: UInt32, string: String)] {
        var results: [(offset: UInt32, string: String)] = []
        var currentString = ""
        var startOffset: UInt32 = 0
        
        let bytes = [UInt8](data)
        
        for (index, byte) in bytes.enumerated() {
            if (32...126).contains(byte) {
                if currentString.isEmpty {
                    startOffset = UInt32(index)
                }
                currentString.append(Character(UnicodeScalar(byte)))
            } else {
                if currentString.count >= minLength {
                    results.append((offset: startOffset, string: currentString))
                }
                currentString = ""
            }
        }
        
        if currentString.count >= minLength {
            results.append((offset: startOffset, string: currentString))
        }
        
        return results
    }
    
    func extractUUID(from data: Data) -> String? {
        guard let string = String(data: data, encoding: .utf8) else { return nil }
        
        let pattern = "[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let range = NSRange(string.startIndex..<string.endIndex, in: string)
            if let match = regex.firstMatch(in: string, range: range) {
                return String(string[Range(match.range, in: string)!])
            }
        }
        
        return nil
    }
}

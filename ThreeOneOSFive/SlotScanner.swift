import Foundation

struct SlotInfo {
    let offset: UInt32
    let length: UInt32
    let type: String
    let path: String
    let score: Int
}

class SlotScanner {
    
    static let shared = SlotScanner()
    
    private let priorityPatterns = [
        ".dylib",
        ".framework",
        "Frameworks/",
        "DynamicLibraries/",
        "Caches/com.apple.dyld/"
    ]
    
    func smartScan(_ data: Data) -> [SlotInfo] {
        var results: [SlotInfo] = []
        
        let strings = DyldPatcher.shared.extractStrings(from: data, minLength: 10)
        
        for (offset, string) in strings {
            for pattern in priorityPatterns {
                if string.contains(pattern) {
                    results.append(SlotInfo(
                        offset: offset,
                        length: UInt32(string.count) + 1,
                        type: "priority",
                        path: string,
                        score: 100
                    ))
                    break
                }
            }
        }
        
        for (offset, string) in strings {
            if (string.hasPrefix("/private/var/") || string.hasPrefix("/var/")) &&
               !results.contains(where: { $0.offset == offset }) {
                results.append(SlotInfo(
                    offset: offset,
                    length: UInt32(string.count) + 1,
                    type: "path",
                    path: string,
                    score: 50
                ))
            }
        }
        
        let bytes = [UInt8](data)
        var i = 0
        while i < bytes.count {
            if bytes[i] == 0x00 {
                let start = i
                while i < bytes.count && bytes[i] == 0x00 {
                    i += 1
                }
                if i - start >= 80 {
                    results.append(SlotInfo(
                        offset: UInt32(start),
                        length: UInt32(i - start),
                        type: "gap",
                        path: "[KHOẢNG TRỐNG] \(i - start) bytes",
                        score: 30
                    ))
                }
            } else {
                i += 1
            }
        }
        
        results.sort { $0.score > $1.score }
        return results
    }
    
    func findBestSlot(_ slots: [SlotInfo]) -> SlotInfo? {
        for slot in slots {
            if slot.path.contains(".dylib") {
                return slot
            }
        }
        
        for slot in slots {
            if slot.path.contains("Frameworks/") || slot.path.contains("DynamicLibraries/") {
                return slot
            }
        }
        
        for slot in slots {
            if slot.type == "path" && slot.path.hasPrefix("/private/var/") {
                return slot
            }
        }
        
        for slot in slots {
            if slot.type == "gap" && slot.length >= 120 {
                return slot
            }
        }
        
        return nil
    }
}

import UIKit

class ConsoleLogger {
    
    static let shared = ConsoleLogger()
    
    enum LogLevel: String {
        case success = "[✅]"
        case info = "[*]"
        case warning = "[!]"
        case error = "[❌]"
        case debug = "[+]"
    }
    
    var onLogMessage: ((String, UIColor) -> Void)?
    private var logs: [String] = []
    
    func log(_ message: String, level: LogLevel = .info) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let logMessage = "\(level.rawValue) \(message)"
        logs.append(logMessage)
        
        let color = colorForLevel(level)
        onLogMessage?(logMessage, color)
    }
    
    func colorForLevel(_ level: LogLevel) -> UIColor {
        switch level {
        case .success:
            return UIColor(red: 0.18, green: 0.82, blue: 0.35, alpha: 1.0)
        case .info:
            return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case .warning:
            return UIColor(red: 1.0, green: 0.62, blue: 0.06, alpha: 1.0)
        case .error:
            return UIColor(red: 1.0, green: 0.27, blue: 0.23, alpha: 1.0)
        case .debug:
            return UIColor(red: 0.05, green: 0.52, blue: 1.0, alpha: 1.0)
        }
    }
    
    func clear() {
        logs.removeAll()
    }
    
    func getLogs() -> [String] {
        return logs
    }
}

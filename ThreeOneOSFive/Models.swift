import Foundation

struct AppConfig {
    static let bgMain = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
    static let bgCard = UIColor(red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0)
    static let bgNav = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
    static let bgSelect = UIColor(red: 0.04, green: 0.52, blue: 1.0, alpha: 1.0)
    static let bgConsole = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0)
    static let bgEntry = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.0)
    
    static let fgPrimary = UIColor.white
    static let fgSecondary = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1.0)
    static let fgAccent = UIColor(red: 0.18, green: 0.82, blue: 0.35, alpha: 1.0)
    static let fgError = UIColor(red: 1.0, green: 0.27, blue: 0.23, alpha: 1.0)
    static let fgWarn = UIColor(red: 1.0, green: 0.62, blue: 0.06, alpha: 1.0)
}

struct UIConfig {
    static let cornerRadius: CGFloat = 12.0
    static let padding: CGFloat = 16.0
    static let buttonHeight: CGFloat = 48.0
    static let fontSize: CGFloat = 14.0
}

class SessionState: ObservableObject {
    var dyld4Data: Data?
    var slots: [SlotInfo] = []
    var selectedSlot: SlotInfo?
    var bestSlot: SlotInfo?
    var uuid: String = ""
    var dylibPath: String = ""
    var dylibName: String = ""
    var outputDyld4Name: String = "Locket.dyld4"
}

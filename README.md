# ThreeOneOSFive - SMART INJECTOR v10.0

Công cụ inject dylib + patch dyld4 với giao diện Sileo dark mode.

## 📋 Yêu cầu

- iOS 14.0+
- iPhone với quyền root/jailbreak
- Xcode 13.0+
- macOS 12.0+

## 🔧 Cấu trúc Project

```
ThreeOneOSFive/
├── ThreeOneOSFive/
│   ├── AppDelegate.swift           # App entry point
│   ├── SceneDelegate.swift         # Scene management
│   ├── MainViewController.swift     # Dark mode UI (Sileo style)
│   ├── DyldPatcher.swift          # Dyld4 patching core
│   ├── SlotScanner.swift          # Smart slot scanning
│   ├── DylibInjector.swift        # Dylib injection logic
│   ├── ConsoleLogger.swift        # Color console logging
│   ├── Models.swift               # Data structures
│   ├── FileOperations.swift       # File I/O
│   └── Info.plist                 # App configuration
├── .github/workflows/
│   └── build.yml                  # GitHub Actions CI/CD
├── ExportOptions.plist            # IPA export settings
└── README.md                       # This file
```

## 🚀 Tính năng chính

### 1. Smart Scan
- Quét dyld4 tìm slots khả dụng
- Ưu tiên: .dylib > Frameworks > System paths > Gaps
- Hiển thị offset, length, type, điểm số

### 2. Dylib Injection
- Chọn file dylib cần inject
- Patch dyld4 slot được chọn
- Tạo đường dẫn cache tự động

### 3. Dyld4 Patching
- Clear slot cũ (ghi 0x00)
- Ghi đường dẫn mới
- Xử lý UUID động

### 4. Giao diện Dark Mode
- Sileo-style Inky dark theme
- Console với color logging
- Real-time status updates

## 💻 GitHub Actions Setup

### Bước 1: Push to GitHub

```bash
cd ThreeOneOSFive
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USER/ThreeOneOSFive.git
git push -u origin main
```

### Bước 2: Enable Actions

1. Vào **Settings** → **Actions**
2. Chọn **Allow all actions and reusable workflows**

### Bước 3: Configure Signing (Optional)

1. Vào **Settings** → **Secrets and variables** → **Actions**
2. Thêm `CERTIFICATE_PASSWORD` (nếu dùng)
3. Upload certificate file

### Bước 4: Trigger Build

- Push to `main` hoặc `develop` tự động build
- Hoặc vào **Actions** tab → chọn workflow → **Run workflow**

## 📦 Build locally

```bash
# Xcode build
xcodebuild -project ThreeOneOSFive.xcodeproj \
  -scheme ThreeOneOSFive \
  -configuration Release \
  -sdk iphoneos \
  -arch arm64 \
  build

# Archive
xcodebuild archive \
  -project ThreeOneOSFive.xcodeproj \
  -archivePath build/ThreeOneOSFive.xcarchive

# Export IPA
xcodebuild -exportArchive \
  -archivePath build/ThreeOneOSFive.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath build/ipa
```

## 🎨 UI Color Scheme

| Element | Color | Hex |
|---------|-------|-----|
| Background | Inky | #1a1a1a |
| Card | Dark gray | #282828 |
| Accent | Blue | #0d84ff |
| Success | Green | #2dd157 |
| Error | Red | #ff4444 |
| Warning | Orange | #ff9e00 |

## 📱 Usage Flow

1. **Chọn dyld4**: Tap "Chọn dyld4" → chọn file từ Files app
2. **Nhập UUID**: Manual hoặc "Tự động từ dyld4"
3. **Chọn dylib**: Tap "Chọn dylib" → chọn .dylib file
4. **Tên dylib**: Nhập tên output (VD: my_tweak.dylib)
5. **SMART SCAN**: Tap → quét tìm slots
6. **Chọn Slot**: Tap row trong bảng, hoặc dùng suggested best slot
7. **INJECT**: Tap "✅ INJECT & PATCH"
8. **Export**: Files tạo trong Documents/(wm)-success-TIMESTAMP/

## 🔐 Security Notes

- App chạy sandbox trên iOS - có hạn chế file access
- Cần dùng Files app hoặc document picker
- Dyld4 patching không persist qua reboot (cần integrate vào app chính)

## 🛠️ Troubleshooting

### Build Error: "Undefined symbol"
- Kiểm tra File → Project Settings → Build System
- Nên dùng **New Build System**

### Import error trên GitHub Actions
- Thêm `xcpretty` output filter
- Kiểm tra `xcode-select -p` return path đúng

### IPA Export fail
- Kiểm m ExportOptions.plist method = `ad-hoc`
- Cần valid provisioning profile

## 📝 File Structure Chi tiết

- **AppDelegate**: UIApplication setup, scene config
- **SceneDelegate**: Window, root ViewController
- **MainViewController**: Toàn bộ UI + delegates
- **DyldPatcher**: Patch logic (clear + write)
- **SlotScanner**: Smart scan algorithm
- **DylibInjector**: Orchestrate inject flow
- **ConsoleLogger**: Color output system
- **Models**: AppConfig, UIConfig, SessionState
- **FileOperations**: File I/O wrapper

## 🔗 Workflow YAML Keys

- `on`: Trigger (push to main/develop)
- `jobs.build.runs-on`: macOS runner
- `steps`: Xcode build → test → archive → export
- `artifacts`: Upload IPA to workflow
- `release`: Auto-create GitHub release on tag

## 📄 License

(wm)-success v10.0 - Personal use only

---

**Version**: 10.0  
**Build Date**: 2024  
**Author**: (wm)

# Contributing to ThreeOneOSFive

## Development Setup

1. Clone repo
```bash
git clone https://github.com/YOUR_USER/ThreeOneOSFive.git
cd ThreeOneOSFive
```

2. Open Xcode
```bash
open ThreeOneOSFive.xcodeproj
```

3. Select target scheme "ThreeOneOSFive"

4. Build (Cmd + B)

## Code Style

- Swift style: Apple official guidelines
- Naming: camelCase for properties/methods, PascalCase for classes
- Comments: Only for complex logic, be concise
- Max line length: 100 chars

## Branch Naming

- Feature: `feature/scanner-improvements`
- Fix: `fix/dyld4-offset-bug`
- Refactor: `refactor/console-logging`

## Commit Messages

```
[TYPE] Brief description

- Detailed change 1
- Detailed change 2
```

Types: `[FEAT]`, `[FIX]`, `[REFACTOR]`, `[DOCS]`, `[TEST]`

## PR Process

1. Create feature branch from `develop`
2. Make changes, test locally
3. Push and create PR to `develop`
4. Wait for CI/CD on GitHub Actions
5. Address review comments
6. Merge when approved

## Testing

```bash
xcodebuild test -project ThreeOneOSFive.xcodeproj -scheme ThreeOneOSFive
```

## Performance Notes

- Avoid blocking main thread in console logging
- Use DispatchQueue for file I/O
- Profile memory usage with Instruments

## Questions?

Open an issue or discussion tab.

---

**Happy coding!** 🚀

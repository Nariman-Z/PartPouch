# Contributing to PartPouch 📦

Thank you for taking the time to contribute to **PartPouch**! We welcome contributions from developers, electronics engineers, makers, and open-source enthusiasts.

---

## 📋 Table of Contents
- [Code of Conduct](#-code-of-conduct)
- [How to Contribute](#-how-to-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Submitting Pull Requests](#submitting-pull-requests)
- [Development Workflow](#-development-workflow)
- [Coding Standards](#-coding-standards)
- [Testing Requirements](#-testing-requirements)

---

## 🤝 Code of Conduct
By participating in this project, you agree to maintain a respectful, welcoming, and inclusive environment for everyone.

---

## 🚀 How to Contribute

### Reporting Bugs
If you encounter a bug or unexpected behavior:
1. Search existing [Issues](https://github.com/nariman-z/PartPouch/issues) to ensure it hasn't already been reported.
2. If not found, open a new issue using a descriptive title.
3. Include relevant details:
   - Device model & OS version
   - Steps to reproduce the issue
   - Expected vs. actual behavior
   - Error logs or stack traces (if available)

### Suggesting Enhancements
Feature requests and architectural suggestions are encouraged!
- Open an Issue with tag `enhancement`.
- Clearly describe the use case and proposed solution.

### Submitting Pull Requests
1. **Fork** the repository and clone your fork locally.
2. Create a topic branch from `main`:
   ```bash
   git checkout -b feature/my-awesome-feature
   ```
3. Make your changes adhering to code formatting standards.
4. Run static analysis and tests:
   ```bash
   flutter analyze
   flutter test
   ```
5. Commit your changes with clear, imperative commit messages:
   ```bash
   git commit -m "Add: support for multi-location inventory transfer"
   ```
6. Push to your fork and create a **Pull Request** targeting `main`.

---

## ⚙️ Development Workflow

```bash
# 1. Clone the repository
git clone https://github.com/nariman-z/PartPouch.git
cd PartPouch

# 2. Fetch Flutter packages
flutter pub get

# 3. Generate Drift database and code files
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app locally
flutter run
```

---

## 🎨 Coding Standards
- **Flutter & Dart Guidelines**: Follow official [Effective Dart](https://dart.dev/effective-dart) rules.
- **State Management**: Use `flutter_riverpod` for clean dependency injection and reactive state flows.
- **Database Access**: Use `drift` schemas and data repositories inside `lib/features/*/data/`.
- **Localization**: Add UI strings to `AppTranslations` (`lib/core/localization/app_translations.dart`) to preserve English & Persian support.

---

## 🧪 Testing Requirements
All PRs modifying core logic or database code must include corresponding unit/widget tests:
```bash
flutter test
```

Thank you for helping make **PartPouch** the ultimate component management ecosystem! 📦✨

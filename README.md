<!-- Gradient Divider -->
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

<!-- Dynamic Header -->
<img height=350 alt="Repo Banner - PartPouch" src="https://capsule-render.vercel.app/api?type=waving&color=0:1E293B,100:0F172A&height=300&section=header&text=📦PartPouch&fontSize=50&fontColor=ffffff&animation=fadeIn&fontAlignY=38&desc=Modern%20Electronic%20Component%20%20Inventory%20Management%20Ecosystem&descAlignY=60&descAlign=50"></img>

<!--Title-->
<p align="center">
  <b>PartPouch - Offline-First Electronic Component & Workshop Inventory Manager (v1.0)</b>
  <br> <small> <i>- A precision-engineered mobile inventory system with real-time stock balances, multi-location storage hierarchies, project BOM kitting, stocktaking audits, QR code labeling, and automated CI/CD releases -</i> </small> <br>
</p> 

---

## 📌 Project Status

> [!NOTE]
> **PartPouch Mobile Inventory Ecosystem (v1.0.0)**  
> This repository contains the complete open-source PartPouch mobile application built with **Flutter 3**, **Riverpod**, and **Drift (SQLite)**. It is fully offline-first, supports dual-language localization (English & Persian), features QR code scanning and label generation, and builds automatically via GitHub Actions CI/CD.

---

## 🔧 Introduction
**PartPouch** is a comprehensive, production-grade mobile inventory management platform tailored for electronics engineers, hardware startups, maker spaces, and repair technicians. Managing thousands of microscopic surface-mount components (0805/0603 resistors, IC packages, microcontrollers, sensors, passive components) across drawers, bins, and rooms requires absolute accuracy and zero latency.

PartPouch eliminates missing components and stockout delays by unifying:
- **Offline-First SQLite Engine:** High-performance local relational database powered by Drift.
- **Multi-Level Storage Hierarchy:** Sub-location mapping down to room, rack, shelf, drawer, and bin codes.
- **Stock Movement Auditing:** Transaction ledger logging every receipt, usage, transfer, and adjustment with cost calculations.
- **Project Bill of Materials (BOM) Kitting:** Grouping required parts per project assembly with automatic stock availability validation.
- **Vendor & Purchase Order Management:** Full lifecycle tracking from vendor quote drafts to incoming shipment receipts.
- **QR Code Scanner & Label Generator:** On-device camera scanning for rapid identification and printable QR payload generation.
- **Multilingual & Neumorphic UI:** Modern Material 3 interface with dark/light themes and Persian Vazirmatn typography support.

---

## 🚀 Key Features
| Operational Vector | Functional Characteristics |
|-------------------|--------------------------------------------------------------------------|
| **Component Database** | Categorized part cataloging • Datasheet URL linking • Package footprints • Internal SKUs • Min stock alerts |
| **Storage Hierarchy** | Multi-tiered location trees (Warehouse ➔ Room ➔ Rack ➔ Drawer ➔ Bin) • Location code indexing |
| **Stock Ledger** | Four transaction modes (Receive, Use, Transfer, Adjust) • Historical movements audit log • Unit cost tracking |
| **Project BOMs** | Assembly BOM builder • Stock reserve checking • Kitting allocation • Required vs Available status |
| **Purchase Orders** | Supplier relationship management • Order status pipeline (Draft ➔ Ordered ➔ Received) • Batch receipt import |
| **Stocktaking** | Cycle counting sessions • Reconciliation variance calculation • Audit approval workflows |
| **QR Code Scanner** | Camera-based barcode/QR scanner • Instant part lookup • Custom QR label code generation |
| **Analytics & Backup**| Interactive stock value charts (FL Chart) • Full JSON export/import backup • Demo data loader (`demo.json`) |
| **Localization & Theme**| Dual-language support (English & Persian) • Vazirmatn Google Font integration • Custom accent color picker |

---

## 💻 Tech Stack & System Architecture

```text
Flutter Presentation Layer (lib/features/*)
        |
        |  (Riverpod State Providers & GoRouter)
        v
Data Repositories & Services (lib/features/*/data)
        |
        |  (Type-Safe Reactive Queries)
        v
Drift SQLite Database Engine (lib/core/database)
        |
        |  (Local File System / Encrypted SQL Storage)
        v
Device Hardware (Camera / Local Storage / QR Engine)
```

### Core Technologies
- **Framework:** [Flutter 3.x](https://flutter.dev/) (Dart 3)
- **State Management:** [Flutter Riverpod 3.x](https://riverpod.dev/)
- **Database Engine:** [Drift (SQLite)](https://drift.simonbinder.eu/) with reactive streams & migrations
- **Navigation:** [GoRouter 17.x](https://pub.dev/packages/go_router)
- **Visual Analytics:** [FL Chart 1.x](https://pub.dev/packages/fl_chart)
- **Hardware Integrations:** [Mobile Scanner](https://pub.dev/packages/mobile_scanner) & [QR Flutter](https://pub.dev/packages/qr_flutter)
- **Typography:** Custom Vazirmatn font weight spectrum (100 to 900) for clean bilingual text rendering

---

## 📖 Full App Tutorial & User Guide

### 1. Initial Setup & Seeding Sample Data
Upon first launching PartPouch:
1. Open the **More / Settings** screen from the bottom navigation bar.
2. Navigate to **Data Backup & Restore**.
3. Tap **Load Demo Data** to populate your local database with 50+ pre-configured electronic components, multi-room storage locations, stock movement ledgers, suppliers, active project BOMs, and sample stocktake audits from `demo.json`.

### 2. Managing Components & Stock Levels
- **Adding a Component:** Tap the `+` Floating Action Button on the Inventory screen. Enter the component name, category (e.g., Microcontrollers, Resistors, Capacitors, Sensors), manufacturer part number (MPN), package footprint (e.g., 0805 SMD, DIP-8, QFN-32), datasheet URL, and minimum stock threshold.
- **Low Stock Alerts:** When total stock drops below the minimum threshold, PartPouch automatically flags the item in the **Low Stock** hub and highlights it with a warning badge on the dashboard.

### 3. Storage Hierarchy & Bin Locations
Organize components using physical storage trees:
1. Go to the **Locations** tab.
2. Create top-level locations (e.g., `Main Workshop`, `Lab Storage`).
3. Add child sub-locations (e.g., `Rack A ➔ Shelf 2 ➔ Drawer 15`).
4. Assign specific component stock balances to exact sub-location codes.

### 4. Stock Movements (Receive, Use, Transfer, Adjust)
- **Receive Stock:** Log incoming component purchases with unit costs, automatically updating total quantity and average unit value.
- **Use / Consume Stock:** Deduct components used during breadboarding, prototype assembly, or production runs.
- **Transfer Stock:** Move quantities from one storage bin to another with full audit logging.
- **Manual Adjustment:** Correct inventory counts following damage, loss, or quick manual checks.

### 5. Project Bill of Materials (BOM) & Kitting
1. Navigate to **Projects**.
2. Create a project (e.g., *Smart Power Metering Relay*).
3. Add required components and quantities to the Project BOM.
4. Check **Kitting Status**: PartPouch evaluates current warehouse stock against BOM requirements and indicates if parts are fully available or need purchasing.

### 6. Purchase Orders & Supplier Management
1. Go to **Suppliers & Purchase Orders**.
2. Register vendor details (DigiKey, Mouser, LCSC, SparkFun).
3. Draft a Purchase Order with line items and target delivery dates.
4. When shipments arrive, tap **Receive Items** to bulk-import items directly into designated storage locations.

### 7. Stocktaking & Physical Audits
1. Open **Stocktake** from the More tab.
2. Start a new Stocktake Session for a target location.
3. Count physical inventory items and input numbers into PartPouch.
4. Review calculated variances (Discrepancies) and tap **Reconcile Stock** to sync database quantities with actual physical counts.

### 8. QR Code Generation & Camera Scanner
- **QR Label Generation:** View any component's detail page and tap **Generate QR Code** to view or export printable QR codes containing part payload data.
- **Camera Scanning:** Tap the QR Scanner icon in the top header to open the live camera scanner. Scan any component QR code to jump directly to its stock detail page or perform fast stock adjustments.

### 9. Customization, Themes & Multilingual Support
- **Theme Modes:** Switch seamlessly between Dark Mode, Light Mode, and System Theme in Settings.
- **Custom Accent Color:** Choose your favorite primary color accent.
- **Language Selection:** Toggle between **English** and **Persian (Farsi)**. The UI automatically adjusts layouts, alignment, and typography using the optimized **Vazirmatn** font family.

---

## 🏗️ Repository Structure

```text
PartPouch/
├── .github/
│   └── workflows/
│       └── release.yml          # Automated GitHub Actions CI/CD release workflow
├── android/                     # Android native project files & Gradle configuration
├── assets/
│   ├── fonts/                   # Vazirmatn TTF font family (Thin to Black)
│   ├── icons/                   # App launcher icons
│   └── images/                  # Onboarding & promotional graphics
├── lib/
│   ├── app/                     # App initialization, GoRouter routes & theme definitions
│   ├── core/                    # Constants, Drift database schema, formatters & UI widgets
│   └── features/
│       ├── dashboard/           # Summary dashboard & stat visualizers
│       ├── inventory/           # Component listing, filter, detail & editing screens
│       ├── locations/           # Multi-tiered storage location hierarchy
│       ├── onboarding/          # First-launch welcome walkthrough
│       ├── projects/            # Project BOMs & kitting allocation
│       ├── purchasing/          # Suppliers & Purchase Order workflows
│       ├── reports/             # Stock distribution & cost reporting screens
│       ├── scanning/            # QR code payload parser & camera scanner
│       ├── search/              # Global instant search bar
│       ├── settings/            # Theme, language, & JSON export/import service
│       ├── stock_movements/     # Activity ledger & stock transaction dialogs
│       ├── stocktake/           # Stocktaking sessions & audit reconciliation
│       └── suppliers/           # Supplier profile management
├── test/                        # Automated unit, widget, and domain ledger tests
├── .gitignore                   # Comprehensive git ignore rules
├── CHANGELOG.md                 # Version ledger and release history
├── CONTRIBUTING.md              # Open source contribution guidelines
├── demo.json                    # Pre-packaged sample inventory dataset
├── LICENSE                      # MIT License
├── pubspec.yaml                 # Flutter package dependencies & asset configurations
└── README.md                    # Project documentation
```

---

## 🛠️ Local Development & Setup

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.12+ recommended)
- [Android Studio](https://developer.android.com/studio) or VS Code with Flutter extension
- Java JDK 17

### Quick Start Commands

```bash
# 1. Clone the repository
git clone https://github.com/nariman-z/PartPouch.git
cd PartPouch

# 2. Install dependencies
flutter pub get

# 3. Generate Drift database models & code files
dart run build_runner build --delete-conflicting-outputs

# 4. Generate app launcher icons
dart run flutter_launcher_icons

# 5. Run tests
flutter test

# 6. Launch application on connected device or emulator
flutter run
```

---

## ⚡ CI/CD & Automated Release Pipeline

PartPouch includes a high-performance **GitHub Actions** release workflow located at `.github/workflows/release.yml`.

### Automated Release Workflow
When a new version tag (e.g. `v1.0.0`) is pushed to GitHub:
1. **Runner Environment:** Spins up an `ubuntu-latest` runner with Java 17 and Flutter SDK caching.
2. **Analysis & Testing:** Executes static analysis (`flutter analyze`) and unit test suites (`flutter test`).
3. **Optimized Compilation:** Builds a standalone release APK (`flutter build apk --release`).
4. **Automated GitHub Release:** Publishes a new release asset `PartPouch-v1.0.0.apk` attached directly to the GitHub tag release notes.

To trigger a release manually:
```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

---

## 🤝 Contributing

Contributions, bug reports, and feature proposals are warmly welcomed! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) guide before submitting pull requests.

---

## ⚠️ Disclaimer

PartPouch is provided "as is" without warranty of any kind. It is designed to assist engineers and makers in managing physical inventory stock. Always maintain regular database JSON backups via the Settings screen.

---

## 📜 License
Licensed under the terms of the **MIT License**. See the full [LICENSE](LICENSE) file for details.

---

<div align="center">

### Made with ❤️ by [Nariman_Z](https://github.com/nariman-z)  
🌐 [Personal Website](https://nariman-z.pages.dev/)

</div>

<!-- Gradient Divider -->
<img src="https://user-images.githubusercontent.com/73097560/115834477-dbab4500-a447-11eb-908a-139a6edaec5c.gif">

_Last Update: November 2026_

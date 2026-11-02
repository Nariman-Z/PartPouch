# 📜 Changelog

All notable changes to **PartPouch** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.1.0] - 2026-11-02

### 🎨 UI & UX Refinements
- **Corner Status Ribbons**: Added angled status ribbons (`PpCornerRibbon`) on project cards and project detail views displaying real-time status (Planning, In Progress, On Hold, Completed) with vibrant thematic colors.
- **Component Card Bottom Line Cleanup**: Refined component cards to display piece counts and concise location codes (e.g., `8 pcs • Box 02`), stripping redundant descriptions.
- **Project BOM Cards Redesign**: Overhauled BOM item cards in project detail view to match the component card architecture with category badges, full descriptions, footprint specs, stock readiness, and unit costs.
- **DatePicker Surface & Dialog Theming**: Styled date selection fields and calendar picker dialogs to match PartPouch dark slate surface and accent color palette.
- **Purchase Order Line Items Layout**: Separated category badges, component titles, descriptions, and footprint specs across dedicated lines to avoid text truncation on mobile viewports.
- **Low Stock Alerts Layout**: Enhanced low stock list cards with dedicated category badges, full-width component titles, and compact action buttons.
- **QR Scanner Viewport Polish**: Positioned alignment instructions as clean floating text and redesigned manual part lookup as a frosted glass pill.
- **Dynamic Version Indicator**: Centralized app versioning in `AppConstants.appVersion` and updated the Settings screen to dynamically display the active version.

---

## [1.0.0] - 2026-11-01

### 🚀 Initial Public Release

#### 📦 Core Features
- **Component & Inventory Management**: Complete CRUD operations for electronic components, microcontrollers, passive parts, sensors, ICs, and displays.
- **Stock Movement Ledger**: Track incoming receipts, usages, stock transfers between locations, and manual adjustments with complete historical audit logs.
- **Multi-Location Storage Hierarchy**: Organize inventory across warehouses, rooms, shelves, drawers, and bins.
- **Project Bill of Materials (BOM)**: Create projects, associate required component quantities, check stock availability, and execute component kitting.
- **Purchase Order System**: Generate purchase orders, track vendor statuses (Draft, Ordered, Received, Cancelled), and receive stock directly into inventory.
- **Stocktaking & Cycle Counting**: Perform inventory audits, log physical counts, and automatically reconcile variances.
- **QR Code Scanner & Label Generator**: Built-in camera scanner for component lookups and instant QR payload generation for physical labeling.
- **Analytics & Low Stock Reporting**: Dashboard stat cards, component distribution charts, cost summaries, and automated low-stock warnings based on minimum thresholds.
- **Data Portability**: Full JSON database import & export for easy backups, demo data seeding (`demo.json`), and migrations.
- **Theme & Localization**: Dark, light, and custom theme modes with full dual-language support (English & Persian) featuring high-legibility Vazirmatn typography.

#### ⚙️ Technical Architecture
- Built with **Flutter 3.x**, **Riverpod** state management, and **Drift** (SQLite) persistence engine.
- Responsive mobile shell layout with bottom navigation, drawer hubs, and global search.
- CI/CD release workflow via GitHub Actions.

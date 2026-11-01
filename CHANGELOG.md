# 📜 Changelog

All notable changes to **PartPouch** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

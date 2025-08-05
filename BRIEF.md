Below is the adjusted mobile app design guide tailored for a Flutter tech stack while preserving your original structure and intent.

App Architecture Overview

Core App Structure
- Cross-platform: Flutter (iOS, Android, Web optional via Flutter Web for kiosk/manager use)
- Architecture: Offline-first with background sync
- Pattern: Feature-first folder structure with layered architecture (presentation, application, domain, data)
- Hybrid delivery: Consider publishing both as native apps and a lightweight PWA via Flutter Web (if your POS flows can be simplified for web)

Technology Stack Recommendations
- UI: Flutter (Material 3 + Cupertino where needed), Dart
- State Management: `flutter_riverpod` or `provider` (Riverpod recommended for testability and scalability). If you want Zustand-like simplicity, use `riverpod` with immutable state classes.
- Navigation: `go_router` (URL-based, deep-linking-friendly) or `auto_route`
- Offline Storage:
  - Key-value: `flutter_secure_storage` (secure) + `shared_preferences` (non-sensitive), or `hive` for fast local KV
  - Structured data: `drift` (SQLite ORM) or `isar` (NoSQL, very fast). For POS, `drift` is ideal for SQL + conflict resolution.
- Networking: `dio` with interceptors, retry, and offline queue; `connectivity_plus` for network status
- Background/Sync: `workmanager` (Android) + `background_fetch` or `flutter_background_service` (iOS considerations)
- Push Notifications: `firebase_messaging` + `flutter_local_notifications`
- Barcode/Camera: `mobile_scanner` or `google_mlkit_barcode_scanning`, `camera`
- Printing: `esc_pos_utils`/`esc_pos_printer` for LAN receipt printers, `blue_thermal_printer` for Bluetooth
- Payments (if applicable): Integrate platform-specific SDKs via platform channels
- Internationalization: `flutter_intl` with ARB files
- Theming: Material 3 ColorScheme, dynamic color (Android 12+) for optional enhancement

Mobile-First Design Principles

Visual Design System
Use Flutter Theme with Material 3. Map your palette and typographies in ThemeData:

Colors:
- Primary (Emerald): #059669
- Success (Green): #16a34a
- Error (Red): #dc2626
- Secondary/Neutral: #6b7280

Typography:
- Headers: 18–24, weight w600
- Body: 14–16, weight w400
- Captions: 12–14, weight w500
- Buttons: 14–16, weight w600
Implement via `TextTheme` and `ElevatedButtonTheme`.

Spacing:
- Base unit: 4
- Common: 8, 12, 16, 24
- Screen margins: 16 (use `EdgeInsets.symmetric(horizontal: 16)`)

Component Hierarchy
- Navigation: BottomNavigationBar with 5 tabs using `NavigationBar` (Material 3), routed by `go_router`
- Cards: `Card` with `elevation` or `Material` + `InkWell` for touch feedback
- Buttons: `ElevatedButton` minimum size 44px height
- Forms: `Form` + `TextFormField` with input formatters; grouped via `ExpansionTile` or custom sections
- Lists: `ListView.builder` or `SliverList`; swipe via `flutter_slidable`

App Navigation Structure

Bottom Tab Navigation (5 Primary Tabs)
1. Home/Dashboard
2. POS
3. Inventory
4. Staff
5. Settings

Implementation:
- Use `ShellRoute` with `go_router` to host `NavigationBar`
- Keep POS as a separate stack to reduce rebuilds

Secondary Navigation
- Drawer: `NavigationDrawer` for Reports, Support
- Stack: `Navigator`/`go_router` for details and forms
- Modals: `showModalBottomSheet` (use `isScrollControlled: true`) for quick actions

Screen-by-Screen Design

1. Authentication Screens
Sign-In
- `TextFormField` for email/password with suffix icon show/hide
- `ElevatedButton` “Sign In”
- `CheckboxListTile` for Remember me
- “Forgot password?” `TextButton`
- Biometric: `local_auth` to enable Touch ID/Face ID

Store Selection (Owners)
- `ListView` of `Card` rows with store name + business badge (`Chip`)
- Search via `SearchBar` (Material 3) or `TextField`
- Quick switching: persist last store via `shared_preferences`/`hive`

2. Dashboard/Home
Today’s Overview
- AppBar: Store name + badge
- Shift status chip
- Quick actions: Row of `FilledButton.tonal` with icons (New Sale, Add Item, View Reports)
- Metrics grid: `GridView.count` (2x2)
- Recent activity: `ListView` showing last transactions, inventory alerts, clock-ins

3. POS Screen (Critical)
Mobile POS Layout
Header:
- Store name + current user (Avatar)
- Shift timer (if active) `Chip` with running timer
- Table selector (F&B) or Customer selector via modal bottom sheet

Main Content:
- Categories: Horizontal chips (`ChoiceChip`/`FilterChip`) with scroll
- Product/Menu grid: `GridView` 2 columns; large touch targets; images cached with `cached_network_image`
- Sticky search bar: Use `SliverAppBar` pinned with search

Floating Cart Button:
- `FloatingActionButton.extended` bottom-right with count + total
- On tap, show bottom sheet

Order Summary Sheet:
- Draggable bottom sheet (`DraggableScrollableSheet` or `showModalBottomSheet`) 85% height
- Line items with `Stepper` or plus/minus buttons
- Customer/table assignment
- Payment methods (tabs for Cash, Card, Other)
- “Complete order” `FilledButton`

POS Quick Actions
- Scan barcode: `IconButton` -> camera sheet
- Add custom item
- Apply discount
- Split bill (F&B)
- Print receipt
- Process refund
Use `PopupMenuButton` or quick action row above the grid.

4. Inventory Screen
Inventory Management
Top Actions:
- FAB `FloatingActionButton` for Add New Item
- Search `SearchBar`
- Filter by category via chips
- Scan barcode shortcut

Product List:
- `ListTile`/`Card` with image, name, price
- Stock indicator: colored `Chip` or progress bar (Green/Yellow/Red)
- Quick stock +/- via `IconButton`
- Swipe actions with `flutter_slidable`: Edit, Delete, Duplicate

Categories:
- Horizontal tabs via `TabBar` or chips: All, Low Stock, Out of Stock, Custom categories

5. Staff/Team Screen
Employee Management
Team Overview:
- Who’s working today, clock-in/out status
- Role indicators (`Chip`)

Employee List:
- `ListTile` with `CircleAvatar` + name
- Role badge (Owner/Manager/Employee)
- Status (Working/Off)
- Last clock-in time

Quick Actions:
- Add employee
- Timesheets
- Permissions
- Store assignments (Owners only)

6. Settings Screen
Settings Organization
Use `ListView` with section headers.
- Account: Profile, Change password, Notification preferences
- Store: Hours, Payment methods, Tax, Receipt customization
- App: Offline mode, Backup, Theme (Light/Dark/System), Language
- Support: Help center, Contact support, App version

Mobile-Specific Features

1. Offline Functionality
Critical Offline
- Sales/orders: Store in `drift` tables with pending sync flag
- Inventory: Cached locally; allow create/update offline with conflict policy
- Clock-in/out: Queue events
- Reports (cached)

Sync Indicators
- Global online/offline banner using `connectivity_plus`
- Sync status icon in AppBar
- Per-entity sync status badges
- Conflict dialogs with resolution options

2. Camera Integration
Barcode Scanning
- `mobile_scanner` for continuous scanning in POS and Inventory
- Map EAN/UPC to products locally; fallback to server when online

Receipt Scanning
- `camera` or `image_picker` + ML Kit text recognition (optional) for expense/receiving

3. Push Notifications
- `firebase_messaging`
- Foreground: `flutter_local_notifications` to show alerts
- Topics/segments: low inventory, new orders (kitchen), shifts, system updates
- Actionable notifications for managers (approve, view)

4. Touch Optimizations
Gestures
- Swipe to delete (Slidable)
- Pull to refresh (`RefreshIndicator`)
- Long press for quick actions (context menu)
- Pinch to zoom images/charts using `InteractiveViewer`

Haptic Feedback
- `HapticFeedback.lightImpact()` for success
- `HapticFeedback.vibrate()` for errors
- Use sparingly on critical actions

Role-Based Mobile Experience

Owner
- Multi-store toggle in AppBar or profile menu
- Aggregated analytics cards
- Approvals and insights
Manager
- Single store ops, targets, staff scheduling, inventory
- Open/close shifts, handle issues
Employee
- Simple dashboard: schedule, tasks, sales targets
- Quick POS access, clock in/out

Data Synchronization Strategy

Real-time Sync Priority
High (immediate):
1. Sales transactions
2. Inventory updates
3. Clock-ins/outs
4. Orders

Medium (periodic/background):
1. Product catalog
2. Price updates
3. Schedules
4. Reports summary

Low (background):
1. Analytics
2. Historical reports
3. Logs
4. Preferences

Implementation
- Local-first writes to `drift` with `sync_status`
- Outbox pattern: queue requests via `dio` interceptor and retry policy
- Backoff with jitter; resume on connectivity changes
- `workmanager`/`background_fetch` to run sync jobs

Conflict Resolution
Server-wins:
- Price changes
- Availability
- Permissions

Last-modified-wins:
- Inventory quantities
- Customer info
- Order notes

User-prompted:
- Large inventory discrepancies
- Scheduling conflicts

Progressive Enhancement Features

Phase 1: Core POS
- Sales, inventory lookup, simple reporting, employee management
- Offline-first with sync
Phase 2: Advanced
- Kitchen display (separate Flutter app or module)
- Table management
- Advanced reporting
- Multi-location
Phase 3: Intelligence
- AI insights
- Predictive inventory
- Customer analytics
- Integrations

UI/UX Mockup Priorities
Critical Screens
1. POS Interface
2. Product Grid
3. Order Summary
4. Dashboard
5. Inventory List

Responsive Breakpoints
- Use `LayoutBuilder` and adaptive grids:
  - Small phones: 320–375: 2-column grids
  - Large phones: 376–414: 2–3 columns adapt
  - Small tablets: 768–834: 3–4 columns
  - Large tablets: 835+: 4–6 columns
- Use `adaptive_breakpoints` package if needed

Technical Implementation Notes

State Management
- `riverpod` for global app state, feature-specific providers
- Persist critical providers with local DB sources
- Separate `domain` entities from `data models`

API Integration
- `dio` with:
  - Auth interceptor (token refresh)
  - Offline queue (outbox table in `drift`)
  - Optimistic updates with rollback on failure

Performance
- `AutomaticKeepAliveClientMixin` to keep POS and tabs alive
- Lazy load non-critical screens
- Memoize selectors with Riverpod
- Use `CachedNetworkImage` and image compression
- Virtualized lists: `ListView.builder`, `SliverList`
- Background prefetch on Wi-Fi and charging

Sample Folder Structure
- `lib/`
  - `app/` (router, theme, localization)
  - `features/`
    - `auth/`
    - `pos/`
    - `inventory/`
    - `staff/`
    - `settings/`
  - `common/` (widgets, utils, services)
  - `data/` (datasources, repositories, models)
  - `domain/` (entities, use_cases)
  - `infra/` (db with `drift`, network with `dio`, sync)

Key Flutter Widgets/Packages Mapping
- Bottom tabs: `NavigationBar` + `go_router` ShellRoute
- Modals: `showModalBottomSheet`, `DraggableScrollableSheet`
- Swipe actions: `flutter_slidable`
- Barcodes: `mobile_scanner`
- DB: `drift` + `sqlite3_flutter_libs`
- Push: `firebase_messaging`, `flutter_local_notifications`
- Background tasks: `workmanager`, `background_fetch`
- Printing: `esc_pos_utils`, `blue_thermal_printer`

Migration Notes from Web/Zustand
- Map your existing business logic to domain/use-case classes callable from Riverpod providers
- Replace Zustand stores with Riverpod `StateNotifier` or `AsyncNotifier`
- Keep server contracts identical (REST), reuse DTOs in Dart with `json_serializable`
- Define a sync engine that mirrors your web app’s conflict policies

This plan maintains your mobile-first, role-based, offline-capable POS while aligning with Flutter’s ecosystem and best practices.
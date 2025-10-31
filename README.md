# Altura POS - Offline-First Point of Sale System

An offline-first Point of Sale (POS) application for Food & Beverage businesses built with Flutter, following Clean Architecture principles.

## 📋 Project Overview

Altura POS is designed to function primarily offline with automatic synchronization when internet connectivity is available. The system prioritizes reliability and performance for food service operations.

### Key Features

- ✅ **Offline-First Architecture**: All core operations work without internet
- ✅ **Automatic Synchronization**: Background sync when online
- ✅ **Clean Architecture**: Clear separation of concerns
- ✅ **Material 3 Design**: Modern, responsive UI
- ✅ **Multi-Platform**: Android, iOS, Web, and Desktop support
- ✅ **Role-Based Access**: Cashier, Manager, and Admin roles

## 🏗️ Architecture

The project follows **Clean Architecture** with three distinct layers:

```
lib/
├── core/               # Cross-cutting concerns
│   ├── constants/      # App colors, strings, endpoints, database constants
│   ├── errors/         # Failures and exceptions
│   ├── network/        # API client, interceptors
│   ├── services/       # Connectivity, sync services
│   └── utils/          # Formatters, validators, logger
├── data/               # Data layer
│   ├── models/         # Data models with JSON serialization
│   ├── datasources/    # Local and remote data sources
│   ├── local/          # Drift database tables and DAOs
│   └── repositories/   # Repository implementations
├── domain/             # Business logic layer
│   ├── entities/       # Domain entities
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Business use cases
└── presentation/       # UI layer
    ├── providers/      # Riverpod state management
    ├── screens/        # App screens and widgets
    ├── theme/          # Material 3 themes
    └── widgets/        # Reusable widgets
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK 3.9.2 or higher
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd AlturaPos
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

### Core Dependencies
- `flutter_riverpod` - State management
- `drift` - Type-safe SQL database
- `dio` - HTTP client
- `freezed` - Immutable data classes
- `connectivity_plus` - Network status monitoring
- `workmanager` - Background tasks

### Utilities
- `intl` - Internationalization and formatting
- `path_provider` - File system paths
- `shared_preferences` - Key-value storage
- `flutter_secure_storage` - Secure credential storage

### UI & Visualization
- `fl_chart` - Charts and graphs
- `pdf` & `printing` - Receipt generation
- `share_plus` - Sharing functionality

## 📱 Core Entities

### User
- Roles: Cashier, Manager, Admin
- Branch assignment
- Session management

### Menu System
- Categories with display ordering
- Menu items with variants and modifiers
- Real-time availability management

### Orders
- Order types: Dine-in, Take-away
- Order status: Draft, Confirmed, Completed, Cancelled
- Line item tracking with modifiers

### Transactions
- Payment methods: Cash, QRIS, Card, Other
- Change calculation
- Receipt generation

### Sync Queue
- Offline operation tracking
- Automatic sync when online
- Conflict resolution

## 🔧 Development Status

### ✅ Completed Phases

- **Phase 1: Foundation Setup**
  - Project initialization
  - Dependencies configuration
  - Folder structure
  - Linting rules

- **Phase 2: Core Infrastructure**
  - Constants (colors, strings, endpoints, database)
  - Utilities (formatters, validators, logger)
  - Error handling (failures, exceptions)
  - Connectivity service
  - API client with interceptors

- **Phase 3: Domain Layer**
  - Domain entities (User, Category, MenuItem, Order, Transaction, SyncQueue)
  - Repository interfaces
  - Use cases (Auth, Menu, Order management)

### 🚧 In Progress

- **Phase 4: Data Layer** - Database tables, models, datasources
- **Phase 5: Presentation Layer** - Themes, common widgets
- **Phase 6-13: Feature Implementation** - UI screens and business logic
- **Phase 14: Testing** - Unit, widget, and integration tests
- **Phase 15: Polish** - Optimization and documentation

## 🎨 Design System

### Color Palette

**Light Theme:**
- Primary: Orange (#FF6F00)
- Secondary: Blue Grey (#455A64)
- Background: White (#FFFFFF)
- Surface: Light Grey (#F5F5F5)

**Dark Theme:**
- Primary: Light Orange (#FFB74D)
- Secondary: Light Blue Grey (#90A4AE)
- Background: Dark (#121212)
- Surface: Dark Grey (#1E1E1E)

### Typography
Following Material 3 typography scale with custom sizing for POS use cases.

## 🔐 Authentication

- Local-first authentication with offline support
- Secure credential storage
- Session management with auto-refresh
- Role-based access control

## 💾 Data Persistence

- **Primary Database**: Drift (SQLite)
- **Secure Storage**: flutter_secure_storage for credentials
- **Preferences**: shared_preferences for settings

## 🔄 Sync Strategy

1. **Queue-based sync**: All offline changes queued
2. **Priority ordering**: Critical data synced first
3. **Retry logic**: Exponential backoff for failures
4. **Conflict resolution**: Timestamp-based with configurable strategies

## 📊 Analytics

- Today's sales metrics
- Top selling items
- Category performance
- Payment method distribution
- Cashier performance tracking

## 🧪 Testing

Run tests with:
```bash
# Unit tests
flutter test

# Integration tests  
flutter test integration_test/

# Coverage
flutter test --coverage
```

## 📄 License

This project is proprietary software. All rights reserved.

## 👥 Contributors

Development by the Altura POS Team.

## 📞 Support

For support, please contact: support@alturapos.com

---

**Built with ❤️ using Flutter**

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

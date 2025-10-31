# Altura POS - Implementation Guide

## Project Structure

This document provides detailed information about the Altura POS project structure and implementation guidelines.

## Clean Architecture Layers

### 1. Domain Layer (`lib/domain/`)
The innermost layer containing business logic and entities. **No dependencies on external frameworks.**

#### Entities (`domain/entities/`)
- `user.dart` - User entity with roles (Cashier, Manager, Admin)
- `category.dart` - Menu category entity
- `menu_item.dart` - Menu item with variants and modifiers
- `order.dart` - Order entity with order items
- `transaction.dart` - Payment transaction entity
- `sync_status.dart` - Sync queue item entity

#### Repositories (`domain/repositories/`)
Abstract interfaces defining data operations:
- `user_repository.dart` - User authentication and management
- `menu_repository.dart` - Menu and category operations
- `order_repository.dart` - Order CRUD operations
- `sync_repository.dart` - Synchronization operations

#### Use Cases (`domain/usecases/`)
Business logic implementations:
- `auth/` - Authentication use cases
- `menu/` - Menu management use cases  
- `order/` - Order processing use cases
- `payment/` - Payment processing use cases
- `sync/` - Synchronization use cases

### 2. Data Layer (`lib/data/`)
Implements domain repository interfaces and handles data persistence.

#### Models (`data/models/`)
Data models with JSON serialization (using Freezed + json_serializable):
- Convert between domain entities and data transfer objects
- Handle JSON serialization/deserialization

#### Data Sources (`data/datasources/`)
- `local/` - Drift database operations
- `remote/` - API HTTP client operations

#### Local Database (`data/local/`)
- `database.dart` - Drift database configuration
- `tables/` - Database table definitions
- `daos/` - Data Access Objects for queries

#### Repositories (`data/repositories/`)
Concrete implementations of domain repository interfaces:
- Combine local and remote data sources
- Handle offline-first logic
- Manage sync queue

### 3. Presentation Layer (`lib/presentation/`)
UI components and state management.

#### Providers (`presentation/providers/`)
Riverpod providers for state management:
- `auth_provider.dart` - Authentication state
- `menu_provider.dart` - Menu items state
- `cart_provider.dart` - Shopping cart state
- `order_provider.dart` - Order management state
- `sync_provider.dart` - Sync status state

#### Screens (`presentation/screens/`)
Feature-based screen organization:
- `auth/` - Login screen
- `dashboard/` - Main dashboard
- `menu/` - Menu management
- `order/` - Order creation
- `payment/` - Payment processing
- `receipt/` - Receipt preview
- `analytics/` - Sales analytics
- `settings/` - App settings

#### Widgets (`presentation/widgets/`)
- `common/` - Reusable widgets (buttons, text fields, etc.)
- `layout/` - Layout components (app drawer, responsive layout)

#### Theme (`presentation/theme/`)
- Material 3 theme configuration
- Light and dark themes

### 4. Core Layer (`lib/core/`)
Cross-cutting concerns and shared utilities.

#### Constants (`core/constants/`)
- `app_colors.dart` - Color palette
- `app_strings.dart` - Text constants
- `api_endpoints.dart` - API URLs
- `database_constants.dart` - Database configuration

#### Errors (`core/errors/`)
- `failures.dart` - Business logic failures (with Freezed)
- `exceptions.dart` - Technical exceptions

#### Network (`core/network/`)
- `api_client.dart` - Dio HTTP client
- `api_interceptor.dart` - Request/response interceptors
- `network_info.dart` - Connectivity helper

#### Services (`core/services/`)
- `connectivity_service.dart` - Network monitoring
- `sync_service.dart` - Background synchronization
- `encryption_service.dart` - Data encryption
- `pdf_service.dart` - Receipt PDF generation

#### Utils (`core/utils/`)
- `date_formatter.dart` - Date/time formatting
- `currency_formatter.dart` - Currency formatting
- `validators.dart` - Input validation
- `logger.dart` - Logging utility

## Coding Conventions

### Naming Conventions
- **Files**: snake_case (e.g., `menu_item.dart`)
- **Classes**: PascalCase (e.g., `MenuItem`)
- **Functions/Variables**: camelCase (e.g., `getMenuItems`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `DEFAULT_TAX_RATE`)
- **Private members**: prefix with `_` (e.g., `_privateMethod`)

### Code Generation
The project uses code generation for:
- **Freezed**: Immutable data classes with `@freezed` annotation
- **JsonSerializable**: JSON serialization with `@JsonSerializable()`
- **Riverpod**: Providers with `@riverpod` annotation  
- **Drift**: Database code with table annotations

Run code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

Watch for changes:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

### State Management with Riverpod
- Use `Provider` for dependencies
- Use `StateProvider` for simple state
- Use `StateNotifierProvider` for complex state
- Use `FutureProvider` for async data
- Use `StreamProvider` for reactive streams

### Error Handling
- Domain layer returns `Either<Failure, T>` from dartz package
- Use try-catch in data layer, convert to `Either`
- Present user-friendly messages in UI layer

## Offline-First Strategy

### Data Flow
1. **Write**: Always write to local database first
2. **Queue**: Add change to sync queue
3. **Sync**: Background service syncs when online
4. **Update**: Update local database on successful sync

### Sync Priority
1. User authentication
2. Transactions and orders
3. Menu availability changes
4. Menu data updates

### Conflict Resolution
- **Timestamp-based**: Latest change wins
- **Server priority**: Pricing and menu structure
- **Local priority**: Item availability toggles

## Testing Strategy

### Unit Tests
- Test all use cases
- Test repository logic
- Test utility functions
- Mock external dependencies

### Widget Tests
- Test UI components
- Test user interactions
- Test state updates

### Integration Tests
- Test complete user flows
- Test offline scenarios
- Test sync operations

## Environment Configuration

Create `.env` files for different environments:
- `.env.dev` - Development
- `.env.staging` - Staging
- `.env.prod` - Production

Variables:
- `API_BASE_URL`
- `DATABASE_NAME`
- `ENABLE_LOGGING`

## Build & Release

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ipa --release
```

### Web
```bash
flutter build web --release
```

## Performance Considerations

- Use `const` constructors where possible
- Implement lazy loading for large lists
- Cache frequently accessed data
- Optimize database queries with indexes
- Use pagination for API calls

## Security

- Encrypt sensitive data at rest
- Use HTTPS for all API calls
- Implement proper authentication
- Validate all user inputs
- Sanitize data before storage

## Accessibility

- Provide semantic labels
- Ensure sufficient color contrast
- Support screen readers
- Enable keyboard navigation
- Respect system font sizes

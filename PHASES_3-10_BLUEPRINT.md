# Altura POS - Phases 3-10 Implementation Blueprint

## Phase 3: Menu Management - Implementation Guide

### Repository Interfaces (domain/repositories/)

#### menu_repository.dart
\\\dart
abstract class MenuRepository {
  Future<Either<Failure, List<MenuItem>>> getMenuItems();
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, MenuItem>> getMenuItemById(String id);
  Future<Either<Failure, void>> updateMenuItem(MenuItem item);
  Future<Either<Failure, void>> toggleItemAvailability(String id);
  Future<Either<Failure, void>> syncMenuData();
}
\\\

### Use Cases (domain/usecases/menu/)

1. **get_menu_items.dart**: Fetch all menu items with caching
2. **get_categories.dart**: Load categories for filtering
3. **update_menu_item.dart**: Manager/admin can update items
4. **toggle_item_availability.dart**: Quick availability toggle

### Data Sources

#### Local (data/datasources/local/menu_local_datasource.dart)
- CRUD operations on Drift database
- Cache menu items for offline access
- Track last sync timestamp

#### Remote (data/datasources/remote/menu_remote_datasource.dart)
- Fetch menu data from API
- Push menu updates to server
- Handle pagination for large menus

### UI Components (presentation/screens/menu/)

#### menu_list_screen.dart
- Grid/List view of menu items
- Category filter tabs
- Search functionality
- Availability toggle for cashiers

#### Widgets
- **menu_item_card.dart**: Display item with image, price, availability
- **category_filter.dart**: Horizontal scrollable category tabs
- **availability_toggle.dart**: Quick toggle switch

### State Management (presentation/providers/)

\\\dart
final menuProvider = StateNotifierProvider<MenuNotifier, AsyncValue<List<MenuItem>>>((ref) {
  return MenuNotifier(ref.watch(menuRepositoryProvider));
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final menuSearchQueryProvider = StateProvider<String>((ref) => '');
\\\

---

## Phase 4: Order & Cart System - Implementation Guide

### State Management Pattern

#### cart_provider.dart
\\\dart
class CartState {
  final List<OrderItem> items;
  final OrderType orderType;
  final String? tableNumber;
  final double subtotal;
  final double tax;
  final double total;
}

class CartNotifier extends StateNotifier<CartState> {
  void addItem(MenuItem menuItem, {Variant? variant, List<Modifier>? modifiers});
  void updateQuantity(String itemId, int quantity);
  void removeItem(String itemId);
  void setOrderType(OrderType type);
  void setTableNumber(String? number);
  void clearCart();
  double calculateTotal();
}
\\\

### UI Screens

#### order_screen.dart (Split View)
- Left: Menu grid with search/filter
- Right: Cart with order summary
- Responsive: Stack on mobile, side-by-side on tablet

#### Widgets
- **menu_grid.dart**: Tap to add items
- **cart_item.dart**: Quantity controls, modifiers display
- **modifier_dialog.dart**: Select variants and add-ons
- **order_type_selector.dart**: Dine-in/Take-away toggle

### Business Logic

#### Order Calculation
\\\dart
double calculateItemTotal(OrderItem item) {
  double base = item.basePrice;
  if (item.selectedVariant != null) {
    base += item.selectedVariant!.priceAdjustment;
  }
  double modifiersTotal = item.selectedModifiers
      .fold(0.0, (sum, mod) => sum + mod.price);
  return (base + modifiersTotal) * item.quantity;
}

double calculateTax(double subtotal) {
  return subtotal * 0.10; // 10% tax
}
\\\

---

## Phase 5: Payment Processing - Implementation Guide

### Payment Flow

1. Review order total
2. Select payment method
3. Enter payment details (cash amount, etc.)
4. Validate payment
5. Create transaction record
6. Update order status
7. Generate receipt

### UI Components

#### payment_screen.dart
- Large total display
- Payment method chips (Cash, QRIS, Card)
- Conditional input (numpad for cash, QR for QRIS)
- Calculate and display change
- Confirm button

#### Widgets
- **payment_method_selector.dart**: Horizontal chips
- **amount_display.dart**: Large currency display
- **numpad.dart**: Custom number pad for cash input

### Transaction Creation

\\\dart
Future<Either<Failure, Transaction>> processPayment({
  required Order order,
  required PaymentMethod method,
  required double amountPaid,
}) async {
  // Validate amount
  if (amountPaid < order.totalAmount) {
    return Left(ValidationFailure('Insufficient payment'));
  }
  
  // Create transaction
  final transaction = Transaction(
    id: uuid.v4(),
    orderId: order.id,
    transactionNumber: generateTransactionNumber(),
    paymentMethod: method,
    totalAmount: order.totalAmount,
    amountPaid: amountPaid,
    changeAmount: amountPaid - order.totalAmount,
    cashierId: currentUser.id,
    isSynced: false,
    createdAt: DateTime.now(),
  );
  
  // Save locally
  await transactionLocalDataSource.createTransaction(transaction);
  
  // Queue for sync
  await syncQueueService.enqueue(transaction);
  
  return Right(transaction);
}
\\\

---

## Phase 6: Receipt Generation - Implementation Guide

### PDF Template

\\\dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Document generateReceipt(Transaction transaction, Order order) {
  final pdf = pw.Document();
  
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll80,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header
          pw.Center(child: pw.Text('ALTURA POS', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))),
          pw.Center(child: pw.Text('Branch Name Here')),
          pw.Divider(),
          
          // Transaction Info
          pw.Text('Receipt #: '),
          pw.Text('Date: '),
          pw.Text('Cashier: '),
          pw.Divider(),
          
          // Items
          ...order.items.map((item) => pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('x '),
              pw.Text(CurrencyFormatter.format(item.itemTotal)),
            ],
          )),
          pw.Divider(),
          
          // Totals
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('Subtotal:'),
            pw.Text(CurrencyFormatter.format(order.subtotal)),
          ]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('Tax:'),
            pw.Text(CurrencyFormatter.format(order.taxAmount)),
          ]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('Total:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(CurrencyFormatter.format(order.totalAmount), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ]),
          
          // Payment
          pw.Divider(),
          pw.Text('Payment: '),
          pw.Text('Paid: '),
          if (transaction.changeAmount > 0)
            pw.Text('Change: '),
          
          // Footer
          pw.Divider(),
          pw.Center(child: pw.Text('Thank you for your visit!')),
        ],
      ),
    ),
  );
  
  return pdf;
}
\\\

### Print & Share

\\\dart
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

Future<void> printReceipt(Transaction transaction, Order order) async {
  final pdf = generateReceipt(transaction, order);
  await Printing.layoutPdf(onLayout: (_) => pdf.save());
}

Future<void> shareReceipt(Transaction transaction, Order order) async {
  final pdf = generateReceipt(transaction, order);
  final bytes = await pdf.save();
  await Share.shareXFiles([
    XFile.fromData(bytes, name: 'receipt_.pdf', mimeType: 'application/pdf')
  ]);
}
\\\

---

## Phase 7: Synchronization - Implementation Guide

### Sync Service Architecture

\\\dart
class SyncService {
  final SyncQueueRepository syncQueueRepo;
  final ConnectivityService connectivityService;
  final ApiClient apiClient;
  
  Future<void> syncAll() async {
    if (!await connectivityService.isConnected) return;
    
    // Get pending items
    final pendingItems = await syncQueueRepo.getPendingItems();
    
    for (final item in pendingItems) {
      try {
        await syncItem(item);
        await syncQueueRepo.markAsCompleted(item.id);
      } catch (e) {
        await syncQueueRepo.incrementRetryCount(item.id);
        if (item.retryCount >= 5) {
          await syncQueueRepo.markAsFailed(item.id, e.toString());
        }
      }
    }
  }
  
  Future<void> syncItem(SyncQueue item) async {
    switch (item.entityType) {
      case 'order':
        await apiClient.post('/orders', data: jsonDecode(item.payload));
        break;
      case 'transaction':
        await apiClient.post('/transactions', data: jsonDecode(item.payload));
        break;
      // ... other entity types
    }
  }
}
\\\

### Background Sync with Workmanager

\\\dart
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final syncService = SyncService();
    await syncService.syncAll();
    return true;
  });
}

void initializeBackgroundSync() {
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    'sync_task',
    'syncData',
    frequency: Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
  );
}
\\\

### Conflict Resolution

\\\dart
Future<void> resolveConflict(SyncQueue local, dynamic remote) async {
  switch (local.entityType) {
    case 'menu_item':
      // Server wins for pricing
      await menuLocalDataSource.update(MenuItem.fromJson(remote));
      break;
    case 'availability':
      // Most recent timestamp wins
      final localTime = DateTime.parse(local.payload['updatedAt']);
      final remoteTime = DateTime.parse(remote['updatedAt']);
      if (remoteTime.isAfter(localTime)) {
        await menuLocalDataSource.update(MenuItem.fromJson(remote));
      }
      break;
  }
}
\\\

---

## Phase 8: Analytics Dashboard - Implementation Guide

### Analytics Queries (data/datasources/local/)

\\\dart
class AnalyticsLocalDataSource {
  final AppDatabase db;
  
  Future<double> getTodaySales() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    
    final result = await (db.select(db.transactions)
      ..where((t) => t.createdAt.isBiggerOrEqualValue(startOfDay))
    ).map((row) => row.totalAmount).get();
    
    return result.fold(0.0, (sum, amount) => sum + amount);
  }
  
  Future<List<TopSellingItem>> getTopSellingItems({int limit = 10}) async {
    // Join order_items with menu_items, group by item, sum quantities
    final query = db.select(db.orderItems).join([
      innerJoin(db.menuItems, db.menuItems.id.equalsExp(db.orderItems.menuItemId))
    ]);
    
    // Group and aggregate (pseudo-code, actual implementation needs Drift aggregation)
    // GROUP BY menuItemId
    // ORDER BY SUM(quantity) DESC
    // LIMIT limit
  }
  
  Future<Map<int, double>> getSalesByHour() async {
    // Aggregate transactions by hour of day
  }
}
\\\

### Chart Widgets (presentation/screens/analytics/widgets/)

\\\dart
import 'package:fl_chart/fl_chart.dart';

class SalesChart extends StatelessWidget {
  final Map<int, double> salesByHour;
  
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(/* hour labels */),
        lineBarsData: [
          LineChartBarData(
            spots: salesByHour.entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
\\\

### Dashboard Layout

\\\dart
class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Analytics')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(child: SummaryCard(title: 'Today Sales', value: 'Rp 2,500,000')),
                SizedBox(width: 16),
                Expanded(child: SummaryCard(title: 'Orders', value: '45')),
              ],
            ),
            SizedBox(height: 24),
            
            // Sales Chart
            Card(child: Padding(padding: EdgeInsets.all(16), child: SalesChart(...))),
            SizedBox(height: 24),
            
            // Top Items
            Card(child: TopItemsList(...)),
          ],
        ),
      ),
    );
  }
}
\\\

---

## Phase 9: Polish & Optimization - Implementation Guide

### Responsive Design

\\\dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 600) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
\\\

### Loading States

\\\dart
class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading...', style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

// Skeleton Loader
class MenuItemSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(height: 150, color: Colors.grey[300]),
          ListTile(
            title: Container(height: 16, width: 100, color: Colors.grey[300]),
            subtitle: Container(height: 14, width: 60, color: Colors.grey[300]),
          ),
        ],
      ),
    );
  }
}
\\\

### Error Handling

\\\dart
class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
          SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: Text('Retry')),
          ],
        ],
      ),
    );
  }
}
\\\

---

## Phase 10: Testing - Implementation Guide

### Unit Test Example

\\\dart
// test/domain/usecases/order/calculate_order_total_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalculateOrderTotal', () {
    test('should calculate correct total with tax', () {
      // Arrange
      final order = Order(
        /* ... */
        subtotal: 100000,
        taxAmount: 10000,
        discountAmount: 0,
        totalAmount: 110000,
      );
      
      // Act
      final result = calculateOrderTotal(order);
      
      // Assert
      expect(result, 110000);
    });
    
    test('should apply discount correctly', () {
      // Test implementation
    });
  });
}
\\\

### Widget Test Example

\\\dart
// test/presentation/widgets/menu_item_card_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('MenuItemCard displays item info correctly', (tester) async {
    // Arrange
    final menuItem = MenuItem(
      id: '1',
      name: 'Test Item',
      basePrice: 25000,
      /* ... */
    );
    
    // Act
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: MenuItemCard(item: menuItem))),
    );
    
    // Assert
    expect(find.text('Test Item'), findsOneWidget);
    expect(find.text('Rp 25,000'), findsOneWidget);
  });
}
\\\

### Integration Test Example

\\\dart
// integration_test/order_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Complete order flow', (tester) async {
    // 1. Launch app
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    
    // 2. Login
    await tester.enterText(find.byKey(Key('username')), 'cashier1');
    await tester.enterText(find.byKey(Key('password')), 'password');
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pumpAndSettle();
    
    // 3. Create order
    await tester.tap(find.text('New Order'));
    await tester.pumpAndSettle();
    
    // 4. Add items
    await tester.tap(find.byKey(Key('menuItem_1')));
    await tester.pumpAndSettle();
    
    // 5. Checkout
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    
    // 6. Process payment
    await tester.tap(find.text('Cash'));
    await tester.enterText(find.byKey(Key('amountInput')), '50000');
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    
    // 7. Verify receipt
    expect(find.text('Order Complete'), findsOneWidget);
  });
}
\\\

---

## Quick Start Commands

\\\ash
# Run all tests
flutter test

# Run specific test file
flutter test test/domain/usecases/order/calculate_order_total_test.dart

# Run integration tests
flutter test integration_test/

# Generate test coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Run with coverage threshold
flutter test --coverage --coverage-threshold=80
\\\

---

**Document**: Implementation Blueprint for Phases 3-10
**Created**: October 31, 2025
**Status**: Ready for Implementation
**Estimated Effort**: 8-9 weeks remaining

import 'package:drift/drift.dart';
import 'package:altura_pos/data/local/database.dart';

part 'order_dao.g.dart';

/// Data Access Object for Orders and Transactions tables
@DriftAccessor(tables: [Orders, Transactions])
class OrderDao extends DatabaseAccessor<AppDatabase> with _$OrderDaoMixin {
  OrderDao(super.db);

  // Order operations
  
  /// Get all orders
  Future<List<Order>> getAllOrders() {
    return (select(orders)..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .get();
  }

  /// Get orders by status
  Future<List<Order>> getOrdersByStatus(String status) {
    return (select(orders)
          ..where((o) => o.status.equals(status))
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .get();
  }

  /// Get orders by date range
  Future<List<Order>> getOrdersByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return (select(orders)
          ..where(
            (o) =>
                o.createdAt.isBiggerOrEqualValue(startDate) &
                o.createdAt.isSmallerOrEqualValue(endDate),
          )
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .get();
  }

  /// Get today's orders
  Future<List<Order>> getTodayOrders() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return getOrdersByDateRange(startOfDay, endOfDay);
  }

  /// Get order by ID
  Future<Order?> getOrderById(String id) {
    return (select(orders)..where((o) => o.id.equals(id))).getSingleOrNull();
  }

  /// Insert order
  Future<int> insertOrder(OrdersCompanion order) {
    return into(orders).insert(order);
  }

  /// Update order
  Future<bool> updateOrder(Order order) {
    return update(orders).replace(order);
  }

  /// Update order status
  Future<int> updateOrderStatus(String id, String status) {
    return (update(orders)..where((o) => o.id.equals(id))).write(
      OrdersCompanion(status: Value(status)),
    );
  }

  /// Mark order as completed
  Future<int> completeOrder(String id) {
    return (update(orders)..where((o) => o.id.equals(id))).write(
      OrdersCompanion(
        status: const Value('completed'),
        completedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Get unsynced orders
  Future<List<Order>> getUnsyncedOrders() {
    return (select(orders)..where((o) => o.isSynced.equals(false))).get();
  }

  /// Mark order as synced
  Future<int> markOrderAsSynced(String id) {
    return (update(orders)..where((o) => o.id.equals(id))).write(
      const OrdersCompanion(isSynced: Value(true)),
    );
  }

  // Transaction operations
  
  /// Get transaction by order ID
  Future<Transaction?> getTransactionByOrderId(String orderId) {
    return (select(transactions)..where((t) => t.orderId.equals(orderId)))
        .getSingleOrNull();
  }

  /// Get transaction by ID
  Future<Transaction?> getTransactionById(String id) {
    return (select(transactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Insert transaction
  Future<int> insertTransaction(TransactionsCompanion transaction) {
    return into(transactions).insert(transaction);
  }

  /// Get today's transactions
  Future<List<Transaction>> getTodayTransactions() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    
    return (select(transactions)
          ..where(
            (t) =>
                t.createdAt.isBiggerOrEqualValue(startOfDay) &
                t.createdAt.isSmallerOrEqualValue(endOfDay),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Get unsynced transactions
  Future<List<Transaction>> getUnsyncedTransactions() {
    return (select(transactions)..where((t) => t.isSynced.equals(false))).get();
  }

  /// Mark transaction as synced
  Future<int> markTransactionAsSynced(String id) {
    return (update(transactions)..where((t) => t.id.equals(id))).write(
      const TransactionsCompanion(isSynced: Value(true)),
    );
  }

  /// Get transactions by date range
  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return (select(transactions)
          ..where(
            (t) =>
                t.createdAt.isBiggerOrEqualValue(startDate) &
                t.createdAt.isSmallerOrEqualValue(endDate),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }
}

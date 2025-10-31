import 'package:drift/drift.dart';
import '../drift/database.dart';
import '../../models/order_model.dart';
import '../../models/order_item_model.dart';

class OrderRepository {
  final AppDatabase _db;

  OrderRepository(this._db);

  /// Insert a complete order with its items
  Future<int> insertOrder(OrderModel order, List<OrderItemModel> items) async {
    return await _db.transaction(() async {
      // Insert order
      final orderId = await _db.insertOrder(
        OrdersCompanion(
          orderNumber: Value(order.orderNumber),
          orderType: Value(order.orderType),
          paymentMethod: Value(order.paymentMethod),
          subtotal: Value(order.subtotal),
          tax: Value(order.tax),
          total: Value(order.total),
          status: Value(order.status),
          syncStatus: Value(order.syncStatus),
          customerName: Value(order.customerName),
          tableNumber: Value(order.tableNumber),
          notes: Value(order.notes),
        ),
      );

      // Insert order items
      for (final item in items) {
        await _db.insertOrderItem(
          OrderItemsCompanion(
            orderId: Value(orderId),
            itemName: Value(item.itemName),
            quantity: Value(item.quantity),
            price: Value(item.price),
            total: Value(item.total),
            category: Value(item.category),
            notes: Value(item.notes),
          ),
        );
      }

      return orderId;
    });
  }

  /// Get order by ID with its items
  Future<Map<String, dynamic>?> getOrderWithItems(int orderId) async {
    final order = await _db.getOrderById(orderId);
    if (order == null) return null;

    final items = await _db.getItemsByOrderId(orderId);

    return {
      'order': _mapOrderEntityToModel(order),
      'items': items.map(_mapOrderItemEntityToModel).toList(),
    };
  }

  /// Get all orders
  Future<List<OrderModel>> getAllOrders({int? limit}) async {
    final entities = await _db.getAllOrders(limit: limit);
    return entities.map(_mapOrderEntityToModel).toList();
  }

  /// Get orders by status
  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    final entities = await _db.getOrdersByStatus(status);
    return entities.map(_mapOrderEntityToModel).toList();
  }

  /// Get orders by sync status
  Future<List<OrderModel>> getOrdersBySyncStatus(String syncStatus) async {
    final entities = await _db.getOrdersBySyncStatus(syncStatus);
    return entities.map(_mapOrderEntityToModel).toList();
  }

  /// Get orders within date range
  Future<List<OrderModel>> getOrdersByDateRange(DateTime start, DateTime end) async {
    final entities = await _db.getOrdersByDateRange(start, end);
    return entities.map(_mapOrderEntityToModel).toList();
  }

  /// Get pending sync orders
  Future<List<OrderModel>> getPendingSyncOrders() async {
    return await getOrdersBySyncStatus('Pending');
  }

  /// Update order sync status
  Future<bool> updateOrderSyncStatus(int orderId, String syncStatus) async {
    final order = await _db.getOrderById(orderId);
    if (order == null) return false;

    return await _db.updateOrder(
      OrdersCompanion(
        id: Value(orderId),
        syncStatus: Value(syncStatus),
        syncedAt: Value(syncStatus == 'Synced' ? DateTime.now() : null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete order and its items (cascades automatically)
  Future<int> deleteOrder(int orderId) async {
    return await _db.deleteOrder(orderId);
  }

  /// Delete orders older than specified days
  Future<int> deleteOldOrders(int daysOld) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    return await _db.deleteOldOrders(cutoffDate);
  }

  /// Get total orders count
  Future<int> getTotalOrdersCount() async {
    return await _db.getTotalOrdersCount();
  }

  /// Get total revenue
  Future<int> getTotalRevenue() async {
    return await _db.getTotalRevenue();
  }

  /// Get revenue grouped by order type
  Future<Map<String, int>> getRevenueByOrderType() async {
    return await _db.getRevenueByOrderType();
  }

  /// Get today's orders
  Future<List<OrderModel>> getTodaysOrders() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return await getOrdersByDateRange(startOfDay, endOfDay);
  }

  /// Get this week's orders
  Future<List<OrderModel>> getWeekOrders() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    return await getOrdersByDateRange(startDate, DateTime.now());
  }

  /// Get this month's orders
  Future<List<OrderModel>> getMonthOrders() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return await getOrdersByDateRange(startOfMonth, DateTime.now());
  }

  /// Clear all data (use with caution!)
  Future<void> clearAllData() async {
    await _db.clearAllData();
  }

  // Helper methods to map entities to models
  OrderModel _mapOrderEntityToModel(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      orderNumber: entity.orderNumber,
      orderType: entity.orderType,
      paymentMethod: entity.paymentMethod,
      subtotal: entity.subtotal,
      tax: entity.tax,
      total: entity.total,
      status: entity.status,
      syncStatus: entity.syncStatus,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncedAt: entity.syncedAt,
      customerName: entity.customerName,
      tableNumber: entity.tableNumber,
      notes: entity.notes,
    );
  }

  OrderItemModel _mapOrderItemEntityToModel(OrderItemEntity entity) {
    return OrderItemModel(
      id: entity.id,
      orderId: entity.orderId,
      itemName: entity.itemName,
      quantity: entity.quantity,
      price: entity.price,
      total: entity.total,
      category: entity.category,
      notes: entity.notes,
      createdAt: entity.createdAt,
    );
  }
}

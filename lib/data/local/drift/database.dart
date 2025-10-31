import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/orders_table.dart';
import 'tables/order_items_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Orders, OrderItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations here
        // Example:
        // if (from < 2) {
        //   await m.addColumn(orders, orders.newColumn);
        // }
      },
      beforeOpen: (details) async {
        // Enable foreign key constraints
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  // Order queries
  Future<int> insertOrder(OrdersCompanion order) async {
    return await into(orders).insert(order);
  }

  Future<OrderEntity?> getOrderById(int id) async {
    return await (select(orders)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<OrderEntity>> getAllOrders({int? limit}) async {
    final query = select(orders)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    if (limit != null) {
      query.limit(limit);
    }
    return await query.get();
  }

  Future<List<OrderEntity>> getOrdersByStatus(String status) async {
    return await (select(orders)..where((t) => t.status.equals(status))).get();
  }

  Future<List<OrderEntity>> getOrdersBySyncStatus(String syncStatus) async {
    return await (select(orders)..where((t) => t.syncStatus.equals(syncStatus))).get();
  }

  Future<List<OrderEntity>> getOrdersByDateRange(DateTime start, DateTime end) async {
    return await (select(orders)
          ..where((t) => t.createdAt.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<bool> updateOrder(OrdersCompanion order) async {
    return await update(orders).replace(order);
  }

  Future<int> deleteOrder(int id) async {
    return await (delete(orders)..where((t) => t.id.equals(id))).go();
  }

  Future<int> deleteOldOrders(DateTime beforeDate) async {
    return await (delete(orders)..where((t) => t.createdAt.isSmallerThanValue(beforeDate))).go();
  }

  // Order items queries
  Future<int> insertOrderItem(OrderItemsCompanion item) async {
    return await into(orderItems).insert(item);
  }

  Future<List<OrderItemEntity>> getItemsByOrderId(int orderId) async {
    return await (select(orderItems)..where((t) => t.orderId.equals(orderId))).get();
  }

  Future<int> deleteOrderItems(int orderId) async {
    return await (delete(orderItems)..where((t) => t.orderId.equals(orderId))).go();
  }

  // Analytics queries
  Future<int> getTotalOrdersCount() async {
    final count = countAll();
    final query = selectOnly(orders)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Future<int> getTotalRevenue() async {
    final sum = orders.total.sum();
    final query = selectOnly(orders)..addColumns([sum]);
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }

  Future<Map<String, int>> getRevenueByOrderType() async {
    final sum = orders.total.sum();
    final query = selectOnly(orders)
      ..addColumns([orders.orderType, sum])
      ..groupBy([orders.orderType]);

    final results = await query.get();
    return {
      for (final row in results) row.read(orders.orderType)!: row.read(sum) ?? 0,
    };
  }

  // Clean up
  Future<void> clearAllData() async {
    await delete(orderItems).go();
    await delete(orders).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'altura_pos.db'));
    return NativeDatabase(file);
  });
}

import 'package:drift/drift.dart';

@DataClassName('OrderEntity')
class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  TextColumn get orderNumber => text()();
  
  // Order Type: Dine In, Take Away, Delivery
  TextColumn get orderType => text()();
  
  // Payment Method: Cash, Card, QRIS
  TextColumn get paymentMethod => text()();
  
  // Pricing
  IntColumn get subtotal => integer()(); // Store as cents/smallest unit
  IntColumn get tax => integer()();
  IntColumn get total => integer()();
  
  // Status: Pending, Completed, Cancelled
  TextColumn get status => text().withDefault(const Constant('Completed'))();
  
  // Sync Status: Pending, Synced, Failed
  TextColumn get syncStatus => text().withDefault(const Constant('Pending'))();
  
  // Metadata
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  
  // Optional fields
  TextColumn get customerName => text().nullable()();
  TextColumn get tableNumber => text().nullable()();
  TextColumn get notes => text().nullable()();
}

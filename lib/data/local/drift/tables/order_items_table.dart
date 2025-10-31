import 'package:drift/drift.dart';
import 'orders_table.dart';

@DataClassName('OrderItemEntity')
class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // Foreign key to Orders table
  IntColumn get orderId => integer().references(Orders, #id, onDelete: KeyAction.cascade)();
  
  // Item details
  TextColumn get itemName => text()();
  IntColumn get quantity => integer()();
  IntColumn get price => integer()(); // Price per unit in smallest currency unit
  IntColumn get total => integer()(); // quantity * price
  
  // Optional metadata
  TextColumn get category => text().nullable()();
  TextColumn get notes => text().nullable()();
  
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

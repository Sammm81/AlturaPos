import 'package:drift/drift.dart';

/// Orders table definition
class Orders extends Table {
  TextColumn get id => text()();
  TextColumn get orderNumber => text().unique()();
  TextColumn get orderType => text()();
  TextColumn get status => text()();
  TextColumn get tableNumber => text().nullable()();
  TextColumn get customerName => text().nullable()();
  TextColumn get itemsJson => text().withDefault(const Constant('[]'))();
  RealColumn get subtotal => real()();
  RealColumn get taxAmount => real()();
  RealColumn get discountAmount => real().withDefault(const Constant(0.0))();
  RealColumn get totalAmount => real()();
  TextColumn get cashierId => text()();
  TextColumn get branchId => text()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

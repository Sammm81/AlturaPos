import 'package:drift/drift.dart';

/// Transactions table definition
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get orderId => text()();
  TextColumn get transactionNumber => text().unique()();
  TextColumn get paymentMethod => text()();
  RealColumn get totalAmount => real()();
  RealColumn get amountPaid => real()();
  RealColumn get changeAmount => real()();
  TextColumn get paymentReference => text().nullable()();
  TextColumn get cashierId => text()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

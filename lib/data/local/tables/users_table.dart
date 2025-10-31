import 'package:drift/drift.dart';

/// Users table definition
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get username => text().withLength(min: 3, max: 50).unique()();
  TextColumn get fullName => text().withLength(min: 1, max: 100)();
  TextColumn get passwordHash => text()();
  TextColumn get role => text()();
  TextColumn get branchId => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

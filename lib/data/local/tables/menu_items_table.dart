import 'package:drift/drift.dart';

/// Menu items table definition
class MenuItems extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  RealColumn get basePrice => real()();
  TextColumn get imageUrl => text().nullable()();
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  BoolColumn get hasVariants => boolean().withDefault(const Constant(false))();
  TextColumn get variantsJson => text().withDefault(const Constant('[]'))();
  TextColumn get modifiersJson => text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

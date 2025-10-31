import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:altura_pos/core/constants/database_constants.dart';
import 'package:altura_pos/data/local/tables/users_table.dart';
import 'package:altura_pos/data/local/tables/categories_table.dart';
import 'package:altura_pos/data/local/tables/menu_items_table.dart';
import 'package:altura_pos/data/local/tables/orders_table.dart';
import 'package:altura_pos/data/local/tables/transactions_table.dart';
import 'package:altura_pos/data/local/tables/sync_queue_table.dart';

part 'database.g.dart';

/// Main database class
@DriftDatabase(
  tables: [
    Users,
    Categories,
    MenuItems,
    Orders,
    Transactions,
    SyncQueue,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => DatabaseConstants.databaseVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Add migrations here when schema changes
      },
      beforeOpen: (details) async {
        // Enable foreign keys
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, DatabaseConstants.databaseName));
    return NativeDatabase(file);
  });
}

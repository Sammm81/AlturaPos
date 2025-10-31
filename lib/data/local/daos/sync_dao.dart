import 'package:drift/drift.dart';
import 'package:altura_pos/data/local/database.dart';

part 'sync_dao.g.dart';

/// Data Access Object for Sync Queue table
@DriftAccessor(tables: [SyncQueue])
class SyncDao extends DatabaseAccessor<AppDatabase> with _$SyncDaoMixin {
  SyncDao(super.db);

  /// Get all pending sync items
  Future<List<SyncQueueItem>> getPendingSyncItems() {
    return (select(syncQueue)
          ..where((s) => s.status.equals('pending'))
          ..orderBy([(s) => OrderingTerm.asc(s.createdAt)]))
        .get();
  }

  /// Get sync items by status
  Future<List<SyncQueueItem>> getSyncItemsByStatus(String status) {
    return (select(syncQueue)
          ..where((s) => s.status.equals(status))
          ..orderBy([(s) => OrderingTerm.asc(s.createdAt)]))
        .get();
  }

  /// Get sync item by ID
  Future<SyncQueueItem?> getSyncItemById(String id) {
    return (select(syncQueue)..where((s) => s.id.equals(id)))
        .getSingleOrNull();
  }

  /// Insert sync item
  Future<int> insertSyncItem(SyncQueueCompanion item) {
    return into(syncQueue).insert(item);
  }

  /// Update sync item status
  Future<int> updateSyncStatus(
    String id,
    String status, {
    String? errorMessage,
  }) {
    return (update(syncQueue)..where((s) => s.id.equals(id))).write(
      SyncQueueCompanion(
        status: Value(status),
        errorMessage: Value(errorMessage),
        lastAttemptAt: Value(DateTime.now()),
      ),
    );
  }

  /// Increment retry count
  Future<int> incrementRetryCount(String id) async {
    final item = await getSyncItemById(id);
    if (item == null) return 0;
    
    return (update(syncQueue)..where((s) => s.id.equals(id))).write(
      SyncQueueCompanion(
        retryCount: Value(item.retryCount + 1),
        lastAttemptAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete sync item
  Future<int> deleteSyncItem(String id) {
    return (delete(syncQueue)..where((s) => s.id.equals(id))).go();
  }

  /// Delete completed sync items
  Future<int> deleteCompletedItems() {
    return (delete(syncQueue)..where((s) => s.status.equals('completed')))
        .go();
  }

  /// Get failed sync items
  Future<List<SyncQueueItem>> getFailedSyncItems() {
    return (select(syncQueue)..where((s) => s.status.equals('failed'))).get();
  }

  /// Count pending items
  Future<int> countPendingItems() async {
    final count = countAll();
    final query = selectOnly(syncQueue)
      ..addColumns([count])
      ..where(syncQueue.status.equals('pending'));
    
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}

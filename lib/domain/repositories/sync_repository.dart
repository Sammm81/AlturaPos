import 'package:dartz/dartz.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/sync_status.dart';

/// Sync repository interface
abstract class SyncRepository {
  /// Add item to sync queue
  Future<Either<Failure, void>> addToSyncQueue(SyncQueueItem item);

  /// Get pending sync items
  Future<Either<Failure, List<SyncQueueItem>>> getPendingSyncItems();

  /// Update sync item status
  Future<Either<Failure, void>> updateSyncStatus(
    String id,
    SyncStatus status, {
    String? errorMessage,
  });

  /// Delete sync item
  Future<Either<Failure, void>> deleteSyncItem(String id);

  /// Sync all pending items
  Future<Either<Failure, void>> syncAll();

  /// Get last sync timestamp
  Future<Either<Failure, DateTime?>> getLastSyncTimestamp();

  /// Update last sync timestamp
  Future<Either<Failure, void>> updateLastSyncTimestamp(DateTime timestamp);
}

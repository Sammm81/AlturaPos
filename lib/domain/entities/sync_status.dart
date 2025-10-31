import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_status.freezed.dart';

/// Sync operation enumeration
enum SyncOperation {
  create,
  update,
  delete,
}

/// Sync status enumeration
enum SyncStatus {
  pending,
  inProgress,
  completed,
  failed,
}

/// Sync queue entity
@freezed
class SyncQueueItem with _$SyncQueueItem {
  const factory SyncQueueItem({
    required String id,
    required String entityType,
    required String entityId,
    required SyncOperation operation,
    required String payload,
    @Default(0) int retryCount,
    DateTime? lastAttemptAt,
    required SyncStatus status,
    String? errorMessage,
    required DateTime createdAt,
  }) = _SyncQueueItem;
}

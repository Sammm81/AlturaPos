import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'sync_queue.freezed.dart';
part 'sync_queue.g.dart';

@freezed
class SyncQueue with _$SyncQueue {
  const factory SyncQueue({
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
  }) = _SyncQueue;

  factory SyncQueue.fromJson(Map<String, dynamic> json) => _$SyncQueueFromJson(json);
}

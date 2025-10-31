// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_queue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SyncQueueImpl _$$SyncQueueImplFromJson(Map<String, dynamic> json) =>
    _$SyncQueueImpl(
      id: json['id'] as String,
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      operation: $enumDecode(_$SyncOperationEnumMap, json['operation']),
      payload: json['payload'] as String,
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      lastAttemptAt: json['lastAttemptAt'] == null
          ? null
          : DateTime.parse(json['lastAttemptAt'] as String),
      status: $enumDecode(_$SyncStatusEnumMap, json['status']),
      errorMessage: json['errorMessage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SyncQueueImplToJson(_$SyncQueueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'operation': _$SyncOperationEnumMap[instance.operation]!,
      'payload': instance.payload,
      'retryCount': instance.retryCount,
      'lastAttemptAt': instance.lastAttemptAt?.toIso8601String(),
      'status': _$SyncStatusEnumMap[instance.status]!,
      'errorMessage': instance.errorMessage,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$SyncOperationEnumMap = {
  SyncOperation.create: 'create',
  SyncOperation.update: 'update',
  SyncOperation.delete: 'delete',
};

const _$SyncStatusEnumMap = {
  SyncStatus.pending: 'pending',
  SyncStatus.inProgress: 'inProgress',
  SyncStatus.completed: 'completed',
  SyncStatus.failed: 'failed',
};

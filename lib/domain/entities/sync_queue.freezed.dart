// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_queue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SyncQueue _$SyncQueueFromJson(Map<String, dynamic> json) {
  return _SyncQueue.fromJson(json);
}

/// @nodoc
mixin _$SyncQueue {
  String get id => throw _privateConstructorUsedError;
  String get entityType => throw _privateConstructorUsedError;
  String get entityId => throw _privateConstructorUsedError;
  SyncOperation get operation => throw _privateConstructorUsedError;
  String get payload => throw _privateConstructorUsedError;
  int get retryCount => throw _privateConstructorUsedError;
  DateTime? get lastAttemptAt => throw _privateConstructorUsedError;
  SyncStatus get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SyncQueue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncQueue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncQueueCopyWith<SyncQueue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncQueueCopyWith<$Res> {
  factory $SyncQueueCopyWith(SyncQueue value, $Res Function(SyncQueue) then) =
      _$SyncQueueCopyWithImpl<$Res, SyncQueue>;
  @useResult
  $Res call({
    String id,
    String entityType,
    String entityId,
    SyncOperation operation,
    String payload,
    int retryCount,
    DateTime? lastAttemptAt,
    SyncStatus status,
    String? errorMessage,
    DateTime createdAt,
  });
}

/// @nodoc
class _$SyncQueueCopyWithImpl<$Res, $Val extends SyncQueue>
    implements $SyncQueueCopyWith<$Res> {
  _$SyncQueueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncQueue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? operation = null,
    Object? payload = null,
    Object? retryCount = null,
    Object? lastAttemptAt = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            entityType: null == entityType
                ? _value.entityType
                : entityType // ignore: cast_nullable_to_non_nullable
                      as String,
            entityId: null == entityId
                ? _value.entityId
                : entityId // ignore: cast_nullable_to_non_nullable
                      as String,
            operation: null == operation
                ? _value.operation
                : operation // ignore: cast_nullable_to_non_nullable
                      as SyncOperation,
            payload: null == payload
                ? _value.payload
                : payload // ignore: cast_nullable_to_non_nullable
                      as String,
            retryCount: null == retryCount
                ? _value.retryCount
                : retryCount // ignore: cast_nullable_to_non_nullable
                      as int,
            lastAttemptAt: freezed == lastAttemptAt
                ? _value.lastAttemptAt
                : lastAttemptAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as SyncStatus,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncQueueImplCopyWith<$Res>
    implements $SyncQueueCopyWith<$Res> {
  factory _$$SyncQueueImplCopyWith(
    _$SyncQueueImpl value,
    $Res Function(_$SyncQueueImpl) then,
  ) = __$$SyncQueueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String entityType,
    String entityId,
    SyncOperation operation,
    String payload,
    int retryCount,
    DateTime? lastAttemptAt,
    SyncStatus status,
    String? errorMessage,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$SyncQueueImplCopyWithImpl<$Res>
    extends _$SyncQueueCopyWithImpl<$Res, _$SyncQueueImpl>
    implements _$$SyncQueueImplCopyWith<$Res> {
  __$$SyncQueueImplCopyWithImpl(
    _$SyncQueueImpl _value,
    $Res Function(_$SyncQueueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncQueue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? operation = null,
    Object? payload = null,
    Object? retryCount = null,
    Object? lastAttemptAt = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$SyncQueueImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _value.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        entityId: null == entityId
            ? _value.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        operation: null == operation
            ? _value.operation
            : operation // ignore: cast_nullable_to_non_nullable
                  as SyncOperation,
        payload: null == payload
            ? _value.payload
            : payload // ignore: cast_nullable_to_non_nullable
                  as String,
        retryCount: null == retryCount
            ? _value.retryCount
            : retryCount // ignore: cast_nullable_to_non_nullable
                  as int,
        lastAttemptAt: freezed == lastAttemptAt
            ? _value.lastAttemptAt
            : lastAttemptAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SyncStatus,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncQueueImpl implements _SyncQueue {
  const _$SyncQueueImpl({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payload,
    this.retryCount = 0,
    this.lastAttemptAt,
    required this.status,
    this.errorMessage,
    required this.createdAt,
  });

  factory _$SyncQueueImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncQueueImplFromJson(json);

  @override
  final String id;
  @override
  final String entityType;
  @override
  final String entityId;
  @override
  final SyncOperation operation;
  @override
  final String payload;
  @override
  @JsonKey()
  final int retryCount;
  @override
  final DateTime? lastAttemptAt;
  @override
  final SyncStatus status;
  @override
  final String? errorMessage;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SyncQueue(id: $id, entityType: $entityType, entityId: $entityId, operation: $operation, payload: $payload, retryCount: $retryCount, lastAttemptAt: $lastAttemptAt, status: $status, errorMessage: $errorMessage, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncQueueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.payload, payload) || other.payload == payload) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.lastAttemptAt, lastAttemptAt) ||
                other.lastAttemptAt == lastAttemptAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    entityType,
    entityId,
    operation,
    payload,
    retryCount,
    lastAttemptAt,
    status,
    errorMessage,
    createdAt,
  );

  /// Create a copy of SyncQueue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncQueueImplCopyWith<_$SyncQueueImpl> get copyWith =>
      __$$SyncQueueImplCopyWithImpl<_$SyncQueueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncQueueImplToJson(this);
  }
}

abstract class _SyncQueue implements SyncQueue {
  const factory _SyncQueue({
    required final String id,
    required final String entityType,
    required final String entityId,
    required final SyncOperation operation,
    required final String payload,
    final int retryCount,
    final DateTime? lastAttemptAt,
    required final SyncStatus status,
    final String? errorMessage,
    required final DateTime createdAt,
  }) = _$SyncQueueImpl;

  factory _SyncQueue.fromJson(Map<String, dynamic> json) =
      _$SyncQueueImpl.fromJson;

  @override
  String get id;
  @override
  String get entityType;
  @override
  String get entityId;
  @override
  SyncOperation get operation;
  @override
  String get payload;
  @override
  int get retryCount;
  @override
  DateTime? get lastAttemptAt;
  @override
  SyncStatus get status;
  @override
  String? get errorMessage;
  @override
  DateTime get createdAt;

  /// Create a copy of SyncQueue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncQueueImplCopyWith<_$SyncQueueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

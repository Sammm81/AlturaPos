// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  String get transactionNumber => throw _privateConstructorUsedError;
  PaymentMethod get paymentMethod => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get amountPaid => throw _privateConstructorUsedError;
  double get changeAmount => throw _privateConstructorUsedError;
  String? get paymentReference => throw _privateConstructorUsedError;
  String get cashierId => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
    Transaction value,
    $Res Function(Transaction) then,
  ) = _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call({
    String id,
    String orderId,
    String transactionNumber,
    PaymentMethod paymentMethod,
    double totalAmount,
    double amountPaid,
    double changeAmount,
    String? paymentReference,
    String cashierId,
    bool isSynced,
    DateTime createdAt,
  });
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? transactionNumber = null,
    Object? paymentMethod = null,
    Object? totalAmount = null,
    Object? amountPaid = null,
    Object? changeAmount = null,
    Object? paymentReference = freezed,
    Object? cashierId = null,
    Object? isSynced = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String,
            transactionNumber: null == transactionNumber
                ? _value.transactionNumber
                : transactionNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as PaymentMethod,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            amountPaid: null == amountPaid
                ? _value.amountPaid
                : amountPaid // ignore: cast_nullable_to_non_nullable
                      as double,
            changeAmount: null == changeAmount
                ? _value.changeAmount
                : changeAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            paymentReference: freezed == paymentReference
                ? _value.paymentReference
                : paymentReference // ignore: cast_nullable_to_non_nullable
                      as String?,
            cashierId: null == cashierId
                ? _value.cashierId
                : cashierId // ignore: cast_nullable_to_non_nullable
                      as String,
            isSynced: null == isSynced
                ? _value.isSynced
                : isSynced // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
    _$TransactionImpl value,
    $Res Function(_$TransactionImpl) then,
  ) = __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderId,
    String transactionNumber,
    PaymentMethod paymentMethod,
    double totalAmount,
    double amountPaid,
    double changeAmount,
    String? paymentReference,
    String cashierId,
    bool isSynced,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
    _$TransactionImpl _value,
    $Res Function(_$TransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? transactionNumber = null,
    Object? paymentMethod = null,
    Object? totalAmount = null,
    Object? amountPaid = null,
    Object? changeAmount = null,
    Object? paymentReference = freezed,
    Object? cashierId = null,
    Object? isSynced = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$TransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionNumber: null == transactionNumber
            ? _value.transactionNumber
            : transactionNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as PaymentMethod,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        amountPaid: null == amountPaid
            ? _value.amountPaid
            : amountPaid // ignore: cast_nullable_to_non_nullable
                  as double,
        changeAmount: null == changeAmount
            ? _value.changeAmount
            : changeAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        paymentReference: freezed == paymentReference
            ? _value.paymentReference
            : paymentReference // ignore: cast_nullable_to_non_nullable
                  as String?,
        cashierId: null == cashierId
            ? _value.cashierId
            : cashierId // ignore: cast_nullable_to_non_nullable
                  as String,
        isSynced: null == isSynced
            ? _value.isSynced
            : isSynced // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl({
    required this.id,
    required this.orderId,
    required this.transactionNumber,
    required this.paymentMethod,
    required this.totalAmount,
    required this.amountPaid,
    required this.changeAmount,
    this.paymentReference,
    required this.cashierId,
    this.isSynced = false,
    required this.createdAt,
  });

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String orderId;
  @override
  final String transactionNumber;
  @override
  final PaymentMethod paymentMethod;
  @override
  final double totalAmount;
  @override
  final double amountPaid;
  @override
  final double changeAmount;
  @override
  final String? paymentReference;
  @override
  final String cashierId;
  @override
  @JsonKey()
  final bool isSynced;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Transaction(id: $id, orderId: $orderId, transactionNumber: $transactionNumber, paymentMethod: $paymentMethod, totalAmount: $totalAmount, amountPaid: $amountPaid, changeAmount: $changeAmount, paymentReference: $paymentReference, cashierId: $cashierId, isSynced: $isSynced, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.transactionNumber, transactionNumber) ||
                other.transactionNumber == transactionNumber) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.amountPaid, amountPaid) ||
                other.amountPaid == amountPaid) &&
            (identical(other.changeAmount, changeAmount) ||
                other.changeAmount == changeAmount) &&
            (identical(other.paymentReference, paymentReference) ||
                other.paymentReference == paymentReference) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderId,
    transactionNumber,
    paymentMethod,
    totalAmount,
    amountPaid,
    changeAmount,
    paymentReference,
    cashierId,
    isSynced,
    createdAt,
  );

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(this);
  }
}

abstract class _Transaction implements Transaction {
  const factory _Transaction({
    required final String id,
    required final String orderId,
    required final String transactionNumber,
    required final PaymentMethod paymentMethod,
    required final double totalAmount,
    required final double amountPaid,
    required final double changeAmount,
    final String? paymentReference,
    required final String cashierId,
    final bool isSynced,
    required final DateTime createdAt,
  }) = _$TransactionImpl;

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId;
  @override
  String get transactionNumber;
  @override
  PaymentMethod get paymentMethod;
  @override
  double get totalAmount;
  @override
  double get amountPaid;
  @override
  double get changeAmount;
  @override
  String? get paymentReference;
  @override
  String get cashierId;
  @override
  bool get isSynced;
  @override
  DateTime get createdAt;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      transactionNumber: json['transactionNumber'] as String,
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      amountPaid: (json['amountPaid'] as num).toDouble(),
      changeAmount: (json['changeAmount'] as num).toDouble(),
      paymentReference: json['paymentReference'] as String?,
      cashierId: json['cashierId'] as String,
      isSynced: json['isSynced'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'transactionNumber': instance.transactionNumber,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'totalAmount': instance.totalAmount,
      'amountPaid': instance.amountPaid,
      'changeAmount': instance.changeAmount,
      'paymentReference': instance.paymentReference,
      'cashierId': instance.cashierId,
      'isSynced': instance.isSynced,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.qris: 'qris',
  PaymentMethod.card: 'card',
  PaymentMethod.other: 'other',
};

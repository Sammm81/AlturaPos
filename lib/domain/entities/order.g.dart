// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: json['id'] as String,
  orderNumber: json['orderNumber'] as String,
  orderType: $enumDecode(_$OrderTypeEnumMap, json['orderType']),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  tableNumber: json['tableNumber'] as String?,
  customerName: json['customerName'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  subtotal: (json['subtotal'] as num).toDouble(),
  taxAmount: (json['taxAmount'] as num).toDouble(),
  discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
  totalAmount: (json['totalAmount'] as num).toDouble(),
  cashierId: json['cashierId'] as String,
  branchId: json['branchId'] as String,
  notes: json['notes'] as String?,
  isSynced: json['isSynced'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'orderType': _$OrderTypeEnumMap[instance.orderType]!,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'tableNumber': instance.tableNumber,
      'customerName': instance.customerName,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'taxAmount': instance.taxAmount,
      'discountAmount': instance.discountAmount,
      'totalAmount': instance.totalAmount,
      'cashierId': instance.cashierId,
      'branchId': instance.branchId,
      'notes': instance.notes,
      'isSynced': instance.isSynced,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$OrderTypeEnumMap = {
  OrderType.dineIn: 'dineIn',
  OrderType.takeAway: 'takeAway',
};

const _$OrderStatusEnumMap = {
  OrderStatus.draft: 'draft',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
};

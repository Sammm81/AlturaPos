// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      id: json['id'] as String,
      menuItemId: json['menuItemId'] as String,
      menuItemName: json['menuItemName'] as String,
      basePrice: (json['basePrice'] as num).toDouble(),
      selectedVariant: json['selectedVariant'] == null
          ? null
          : Variant.fromJson(json['selectedVariant'] as Map<String, dynamic>),
      selectedModifiers:
          (json['selectedModifiers'] as List<dynamic>?)
              ?.map((e) => Modifier.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      itemTotal: (json['itemTotal'] as num).toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'menuItemId': instance.menuItemId,
      'menuItemName': instance.menuItemName,
      'basePrice': instance.basePrice,
      'selectedVariant': instance.selectedVariant,
      'selectedModifiers': instance.selectedModifiers,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'itemTotal': instance.itemTotal,
      'notes': instance.notes,
    };

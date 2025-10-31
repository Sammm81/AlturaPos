import 'package:freezed_annotation/freezed_annotation.dart';
import 'variant.dart';
import 'modifier.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required String menuItemId,
    required String menuItemName,
    required double basePrice,
    Variant? selectedVariant,
    @Default([]) List<Modifier> selectedModifiers,
    required int quantity,
    required double unitPrice,
    required double itemTotal,
    String? notes,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
}

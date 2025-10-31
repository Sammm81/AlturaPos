import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:altura_pos/domain/entities/menu_item.dart';

part 'order.freezed.dart';

/// Order type enumeration
enum OrderType {
  dineIn,
  takeAway,
}

/// Order status enumeration
enum OrderStatus {
  draft,
  confirmed,
  completed,
  cancelled,
}

/// Order item value object
@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required String menuItemId,
    required String menuItemName,
    required double basePrice,
    Variant? selectedVariant,
    @Default([]) List<Modifier> selectedModifiers,
    @Default(1) int quantity,
    required double unitPrice,
    required double itemTotal,
    String? notes,
  }) = _OrderItem;
}

/// Order entity
@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String orderNumber,
    required OrderType orderType,
    required OrderStatus status,
    String? tableNumber,
    String? customerName,
    @Default([]) List<OrderItem> items,
    required double subtotal,
    required double taxAmount,
    @Default(0.0) double discountAmount,
    required double totalAmount,
    required String cashierId,
    required String branchId,
    String? notes,
    @Default(false) bool isSynced,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _Order;
}

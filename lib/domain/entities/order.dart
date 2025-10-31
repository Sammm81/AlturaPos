import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';
import 'order_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

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

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

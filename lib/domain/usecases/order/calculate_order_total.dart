import 'package:altura_pos/core/constants/database_constants.dart';
import 'package:altura_pos/domain/entities/order.dart';

/// Use case for calculating order totals
class CalculateOrderTotal {
  /// Calculate subtotal from order items
  double calculateSubtotal(List<OrderItem> items) {
    return items.fold<double>(
      0.0,
      (total, item) => total + item.itemTotal,
    );
  }

  /// Calculate tax amount
  double calculateTax(double subtotal, {double taxRate = DatabaseConstants.defaultTaxRate}) {
    return subtotal * taxRate;
  }

  /// Calculate total amount
  double calculateTotal(double subtotal, double tax, double discount) {
    return subtotal + tax - discount;
  }

  /// Calculate item total for an order item
  double calculateItemTotal({
    required double basePrice,
    required double? variantAdjustment,
    required List<double> modifierPrices,
    required int quantity,
  }) {
    final unitPrice = basePrice + (variantAdjustment ?? 0.0) +
        modifierPrices.fold<double>(0.0, (sum, price) => sum + price);
    return unitPrice * quantity;
  }
}

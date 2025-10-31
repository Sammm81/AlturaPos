import 'package:intl/intl.dart';

/// Currency formatting utilities
class CurrencyFormatter {
  CurrencyFormatter._();

  // Default currency settings (Indonesian Rupiah)
  static const String defaultCurrencySymbol = 'Rp';
  static const String defaultCurrencyCode = 'IDR';
  static const int defaultDecimalDigits = 0;

  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: defaultCurrencySymbol,
    decimalDigits: defaultDecimalDigits,
    locale: 'id_ID',
  );

  static final NumberFormat _numberFormat = NumberFormat('#,##0', 'id_ID');
  static final NumberFormat _decimalFormat = NumberFormat('#,##0.00', 'id_ID');

  /// Format amount to currency string (e.g., 'Rp 50,000')
  static String formatCurrency(num amount) => _currencyFormat.format(amount);

  /// Format amount to currency string without symbol (e.g., '50,000')
  static String formatAmount(num amount) => _numberFormat.format(amount);

  /// Format amount with decimal places (e.g., '50,000.50')
  static String formatDecimal(num amount) => _decimalFormat.format(amount);

  /// Format amount with custom symbol
  static String formatWithSymbol(num amount, String symbol) {
    final format = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: defaultDecimalDigits,
      locale: 'id_ID',
    );
    return format.format(amount);
  }

  /// Parse currency string to number
  static double parseCurrency(String text) {
    final cleaned = text.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  /// Format percentage (e.g., '10%')
  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(0)}%';
  }

  /// Format compact currency for large amounts (e.g., '1.5M')
  static String formatCompact(num amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return formatAmount(amount);
    }
  }

  /// Calculate change amount
  static double calculateChange(double amountPaid, double totalAmount) {
    final change = amountPaid - totalAmount;
    return change > 0 ? change : 0.0;
  }

  /// Calculate tax amount
  static double calculateTax(double subtotal, double taxRate) {
    return subtotal * taxRate;
  }

  /// Calculate subtotal from total and tax rate
  static double calculateSubtotal(double total, double taxRate) {
    return total / (1 + taxRate);
  }

  /// Round to nearest currency unit (e.g., round to nearest 100)
  static double roundToCurrencyUnit(double amount, {int unit = 100}) {
    return (amount / unit).round() * unit.toDouble();
  }
}

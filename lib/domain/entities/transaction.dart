import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

/// Payment method enumeration
enum PaymentMethod {
  cash,
  qris,
  card,
  other,
}

/// Transaction entity
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String orderId,
    required String transactionNumber,
    required PaymentMethod paymentMethod,
    required double totalAmount,
    required double amountPaid,
    required double changeAmount,
    String? paymentReference,
    required String cashierId,
    @Default(false) bool isSynced,
    required DateTime createdAt,
  }) = _Transaction;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

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

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/transaction.dart';
import 'package:altura_pos/domain/usecases/transaction/create_transaction.dart';
import 'package:altura_pos/presentation/providers/repository_providers.dart';
import 'package:altura_pos/presentation/providers/order_provider.dart';
import 'package:altura_pos/presentation/providers/cart_provider.dart';
import 'package:altura_pos/presentation/providers/auth_provider.dart';
import 'package:uuid/uuid.dart';

/// Payment state
class PaymentState {
  final PaymentMethod selectedMethod;
  final double amountPaid;
  final double changeAmount;
  final Transaction? completedTransaction;
  final bool isProcessing;
  final String? errorMessage;

  const PaymentState({
    this.selectedMethod = PaymentMethod.cash,
    this.amountPaid = 0.0,
    this.changeAmount = 0.0,
    this.completedTransaction,
    this.isProcessing = false,
    this.errorMessage,
  });

  PaymentState copyWith({
    PaymentMethod? selectedMethod,
    double? amountPaid,
    double? changeAmount,
    Transaction? completedTransaction,
    bool? isProcessing,
    String? errorMessage,
  }) {
    return PaymentState(
      selectedMethod: selectedMethod ?? this.selectedMethod,
      amountPaid: amountPaid ?? this.amountPaid,
      changeAmount: changeAmount ?? this.changeAmount,
      completedTransaction: completedTransaction ?? this.completedTransaction,
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: errorMessage,
    );
  }

  PaymentState clearError() {
    return PaymentState(
      selectedMethod: selectedMethod,
      amountPaid: amountPaid,
      changeAmount: changeAmount,
      completedTransaction: completedTransaction,
      isProcessing: isProcessing,
      errorMessage: null,
    );
  }
}

/// Payment notifier
class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentNotifier(
    this._createTransaction,
    this._ref,
  ) : super(const PaymentState());

  final CreateTransaction _createTransaction;
  final Ref _ref;
  final _uuid = const Uuid();

  /// Set payment method
  void setPaymentMethod(PaymentMethod method) {
    state = state.copyWith(
      selectedMethod: method,
      amountPaid: 0.0,
      changeAmount: 0.0,
    );
  }

  /// Set amount paid
  void setAmountPaid(double amount) {
    final cartState = _ref.read(cartProvider);
    final totalAmount = cartState.totalAmount;
    final change = amount - totalAmount;

    state = state.copyWith(
      amountPaid: amount,
      changeAmount: change > 0 ? change : 0.0,
    );
  }

  /// Process payment
  Future<bool> processPayment({String? paymentReference}) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    // Get current user
    final currentUser = _ref.read(currentUserProvider);
    if (currentUser == null) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'User not authenticated',
      );
      return false;
    }

    // Get cart state
    final cartState = _ref.read(cartProvider);
    if (cartState.isEmpty) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Cart is empty',
      );
      return false;
    }

    // Validate payment amount for cash
    if (state.selectedMethod == PaymentMethod.cash) {
      if (state.amountPaid < cartState.totalAmount) {
        state = state.copyWith(
          isProcessing: false,
          errorMessage: 'Insufficient amount paid',
        );
        return false;
      }
    }

    // Create order from cart
    final orderCreated = await _ref.read(orderProvider.notifier).createOrderFromCart();
    if (!orderCreated) {
      final orderError = _ref.read(orderProvider).errorMessage;
      state = state.copyWith(
        isProcessing: false,
        errorMessage: orderError ?? 'Failed to create order',
      );
      return false;
    }

    // Get the created order
    final order = _ref.read(currentOrderProvider);
    if (order == null) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Order not found',
      );
      return false;
    }

    // Generate transaction number
    final transactionNumber = _generateTransactionNumber();

    // Create transaction
    final transaction = Transaction(
      id: _uuid.v4(),
      orderId: order.id,
      transactionNumber: transactionNumber,
      paymentMethod: state.selectedMethod,
      totalAmount: cartState.totalAmount,
      amountPaid: state.selectedMethod == PaymentMethod.cash
          ? state.amountPaid
          : cartState.totalAmount,
      changeAmount: state.changeAmount,
      paymentReference: paymentReference,
      cashierId: currentUser.id,
      createdAt: DateTime.now(),
    );

    // Save transaction
    final result = await _createTransaction(transaction);

    return result.fold(
      (failure) {
        final errorMessage = _getErrorMessage(failure);
        state = state.copyWith(
          isProcessing: false,
          errorMessage: errorMessage,
        );
        return false;
      },
      (completedTransaction) async {
        // Complete the order
        final orderCompleted = await _ref.read(orderProvider.notifier).completeCurrentOrder();
        
        if (!orderCompleted) {
          state = state.copyWith(
            isProcessing: false,
            errorMessage: 'Failed to complete order',
          );
          return false;
        }

        state = state.copyWith(
          completedTransaction: completedTransaction,
          isProcessing: false,
        );
        return true;
      },
    );
  }

  /// Reset payment state
  void reset() {
    state = const PaymentState();
  }

  /// Clear error message
  void clearError() {
    state = state.clearError();
  }

  /// Generate transaction number
  String _generateTransactionNumber() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    return 'TRX${timestamp.toString().substring(timestamp.toString().length - 8)}';
  }

  /// Get error message from failure
  String _getErrorMessage(Failure failure) {
    return failure.when(
      server: (message, statusCode) => message,
      network: (message) => message,
      database: (message, error) => message,
      authentication: (message) => message,
      validation: (message) => message,
      cache: (message) => message,
      unknown: (message) => message,
    );
  }
}

/// Payment provider
final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  final transactionRepository = ref.watch(transactionRepositoryProvider);

  return PaymentNotifier(
    CreateTransaction(transactionRepository),
    ref,
  );
});

/// Selected payment method provider
final selectedPaymentMethodProvider = Provider<PaymentMethod>((ref) {
  return ref.watch(paymentProvider).selectedMethod;
});

/// Is processing payment provider
final isProcessingPaymentProvider = Provider<bool>((ref) {
  return ref.watch(paymentProvider).isProcessing;
});

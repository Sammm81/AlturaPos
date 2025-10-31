import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/constants/app_strings.dart';
import 'package:altura_pos/core/utils/formatters.dart';
import 'package:altura_pos/domain/entities/transaction.dart';
import 'package:altura_pos/presentation/providers/payment_provider.dart';
import 'package:altura_pos/presentation/providers/cart_provider.dart';
import 'package:altura_pos/presentation/providers/order_provider.dart';
import 'package:altura_pos/presentation/widgets/payment/payment_method_selector.dart';
import 'package:altura_pos/presentation/widgets/payment/cash_payment_panel.dart';
import 'package:altura_pos/presentation/widgets/common/custom_button.dart';
import 'package:altura_pos/presentation/widgets/common/error_display.dart';
import 'package:altura_pos/presentation/widgets/common/loading_indicator.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);
    final cartState = ref.watch(cartProvider);
    final theme = Theme.of(context);

    // Listen to payment errors
    ref.listen<PaymentState>(paymentProvider, (previous, next) {
      if (next.errorMessage != null) {
        ErrorSnackBar.show(context, next.errorMessage!);
      }

      // Navigate to receipt on successful payment
      if (next.completedTransaction != null && 
          previous?.completedTransaction == null) {
        _showPaymentSuccess();
      }
    });

    if (cartState.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.payment),
        ),
        body: const ErrorDisplay(
          message: 'No items in cart',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.payment),
      ),
      body: paymentState.isProcessing
          ? const LoadingIndicator(message: 'Processing payment...')
          : _buildPaymentContent(theme, paymentState, cartState),
    );
  }

  Widget _buildPaymentContent(
    ThemeData theme,
    PaymentState paymentState,
    CartState cartState,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = screenWidth >= 600;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Order summary card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _SummaryRow(
                          label: AppStrings.subtotal,
                          value: Formatters.currency(cartState.subtotal),
                        ),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          label: '${AppStrings.tax} (${(cartState.taxRate * 100).toInt()}%)',
                          value: Formatters.currency(cartState.taxAmount),
                        ),
                        if (cartState.discountAmount > 0) ...[
                          const SizedBox(height: 8),
                          _SummaryRow(
                            label: AppStrings.discount,
                            value: '- ${Formatters.currency(cartState.discountAmount)}',
                            valueColor: theme.colorScheme.error,
                          ),
                        ],
                        const Divider(height: 24),
                        _SummaryRow(
                          label: AppStrings.total,
                          value: Formatters.currency(cartState.totalAmount),
                          labelStyle: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          valueStyle: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Payment method selector
                Text(
                  AppStrings.selectPaymentMethod,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const PaymentMethodSelector(),

                const SizedBox(height: 24),

                // Payment-specific panel
                if (paymentState.selectedMethod == PaymentMethod.cash)
                  CashPaymentPanel(
                    totalAmount: cartState.totalAmount,
                  ),
              ],
            ),
          ),
        ),

        // Bottom action bar
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: CustomButton(
              onPressed: _canProcessPayment(paymentState, cartState)
                  ? () => _processPayment()
                  : null,
              text: AppStrings.confirmPayment,
              isFullWidth: true,
              isLoading: paymentState.isProcessing,
            ),
          ),
        ),
      ],
    );
  }

  bool _canProcessPayment(PaymentState paymentState, CartState cartState) {
    if (paymentState.isProcessing) return false;
    if (cartState.isEmpty) return false;
    
    // For cash payment, require sufficient amount
    if (paymentState.selectedMethod == PaymentMethod.cash) {
      return paymentState.amountPaid >= cartState.totalAmount;
    }
    
    // For other methods, just need method selected
    return true;
  }

  Future<void> _processPayment() async {
    final success = await ref.read(paymentProvider.notifier).processPayment();
    
    if (!mounted) return;
    
    if (!success) {
      // Error is already shown via listener
      return;
    }
  }

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.primary,
          size: 64,
        ),
        title: const Text(AppStrings.paymentSuccess),
        content: const Text(AppStrings.thankYou),
        actions: [
          TextButton(
            onPressed: () {
              // Clear cart and order
              ref.read(cartProvider.notifier).clear();
              ref.read(orderProvider.notifier).startNewOrder();
              ref.read(paymentProvider.notifier).reset();
              
              // Navigate to dashboard
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('New Order'),
          ),
          TextButton(
            onPressed: () {
              // Navigate to receipt screen
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/receipt');
            },
            child: const Text(AppStrings.printReceipt),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.valueColor,
  });

  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ?? theme.textTheme.bodyLarge,
        ),
        Text(
          value,
          style: valueStyle ??
              theme.textTheme.bodyLarge?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

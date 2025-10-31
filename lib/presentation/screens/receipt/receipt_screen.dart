import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:altura_pos/core/constants/app_strings.dart';
import 'package:altura_pos/core/services/pdf_service.dart';
import 'package:altura_pos/presentation/providers/order_provider.dart';
import 'package:altura_pos/presentation/providers/payment_provider.dart';
import 'package:altura_pos/presentation/providers/auth_provider.dart';
import 'package:altura_pos/presentation/providers/cart_provider.dart';
import 'package:altura_pos/presentation/widgets/receipt/receipt_template.dart';
import 'package:altura_pos/presentation/widgets/common/custom_button.dart';
import 'package:altura_pos/presentation/widgets/common/error_display.dart';
import 'package:altura_pos/presentation/widgets/common/loading_indicator.dart';

class ReceiptScreen extends ConsumerStatefulWidget {
  const ReceiptScreen({super.key});

  @override
  ConsumerState<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends ConsumerState<ReceiptScreen> {
  final _pdfService = PdfService();
  bool _isGeneratingPdf = false;

  @override
  Widget build(BuildContext context) {
    final order = ref.watch(currentOrderProvider);
    final paymentState = ref.watch(paymentProvider);
    final currentUser = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    if (order == null || paymentState.completedTransaction == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.receipt),
        ),
        body: const ErrorDisplay(
          message: 'No receipt data available',
        ),
      );
    }

    final transaction = paymentState.completedTransaction!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.receipt),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _handleClose(),
          ),
        ],
      ),
      body: _isGeneratingPdf
          ? const LoadingIndicator(message: 'Generating PDF...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    // Receipt preview
                    ReceiptTemplate(
                      order: order,
                      transaction: transaction,
                      cashier: currentUser,
                      branchName: 'Main Branch',
                    ),
                    const SizedBox(height: 32),

                    // Action buttons
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Print button
                          CustomButton(
                            onPressed: _handlePrint,
                            text: AppStrings.printReceipt,
                            isFullWidth: true,
                          ),
                          const SizedBox(height: 12),

                          // Share button
                          CustomOutlinedButton(
                            onPressed: _handleShare,
                            text: AppStrings.shareReceipt,
                            isFullWidth: true,
                          ),
                          const SizedBox(height: 12),

                          // New order button
                          CustomOutlinedButton(
                            onPressed: _handleNewOrder,
                            text: 'New Order',
                            isFullWidth: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _handlePrint() async {
    // In a real implementation, this would connect to a thermal printer
    // For now, we'll generate a PDF and show a success message
    await _generatePdf();
    
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receipt ready for printing'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleShare() async {
    try {
      setState(() => _isGeneratingPdf = true);

      final order = ref.read(currentOrderProvider)!;
      final transaction = ref.read(paymentProvider).completedTransaction!;
      final currentUser = ref.read(currentUserProvider);

      final pdfFile = await _pdfService.generateReceipt(
        order: order,
        transaction: transaction,
        cashier: currentUser,
        branchName: 'Main Branch',
      );

      setState(() => _isGeneratingPdf = false);

      if (!mounted) return;

      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        subject: 'Receipt ${transaction.transactionNumber}',
      );
    } catch (e) {
      setState(() => _isGeneratingPdf = false);
      
      if (!mounted) return;
      
      ErrorSnackBar.show(
        context,
        'Failed to share receipt: $e',
      );
    }
  }

  Future<void> _generatePdf() async {
    try {
      setState(() => _isGeneratingPdf = true);

      final order = ref.read(currentOrderProvider)!;
      final transaction = ref.read(paymentProvider).completedTransaction!;
      final currentUser = ref.read(currentUserProvider);

      await _pdfService.generateReceipt(
        order: order,
        transaction: transaction,
        cashier: currentUser,
        branchName: 'Main Branch',
      );

      setState(() => _isGeneratingPdf = false);
    } catch (e) {
      setState(() => _isGeneratingPdf = false);
      
      if (!mounted) return;
      
      ErrorSnackBar.show(
        context,
        'Failed to generate PDF: $e',
      );
    }
  }

  void _handleNewOrder() {
    // Clear all state and navigate to new order
    ref.read(cartProvider.notifier).clear();
    ref.read(orderProvider.notifier).startNewOrder();
    ref.read(paymentProvider.notifier).reset();

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _handleClose() {
    _handleNewOrder();
  }
}

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:altura_pos/core/constants/app_strings.dart';
import 'package:altura_pos/core/utils/formatters.dart';
import 'package:altura_pos/core/utils/logger.dart';
import 'package:altura_pos/domain/entities/order.dart';
import 'package:altura_pos/domain/entities/transaction.dart';
import 'package:altura_pos/domain/entities/user.dart';

/// Service for generating PDF receipts
class PdfService {
  /// Generate PDF receipt from order and transaction
  Future<File> generateReceipt({
    required Order order,
    required Transaction transaction,
    User? cashier,
    String? branchName,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.roll80,
          build: (context) => _buildReceiptContent(
            order: order,
            transaction: transaction,
            cashier: cashier,
            branchName: branchName,
          ),
        ),
      );

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/receipt_${transaction.transactionNumber}.pdf');
      await file.writeAsBytes(await pdf.save());

      Logger.logInfo('Receipt PDF generated: ${file.path}');
      return file;
    } catch (e) {
      Logger.logError('Failed to generate receipt PDF', error: e);
      rethrow;
    }
  }

  pw.Widget _buildReceiptContent({
    required Order order,
    required Transaction transaction,
    User? cashier,
    String? branchName,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Header
        pw.Center(
          child: pw.Column(
            children: [
              pw.Text(
                branchName ?? AppStrings.appName,
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text('Point of Sale System', style: const pw.TextStyle(fontSize: 10)),
            ],
          ),
        ),
        pw.Divider(),

        // Order info
        _buildInfoRow('Order No:', order.orderNumber),
        _buildInfoRow('Transaction:', transaction.transactionNumber),
        _buildInfoRow('Date:', Formatters.dateTime(order.createdAt)),
        _buildInfoRow(
          'Type:',
          order.orderType == OrderType.dineIn ? AppStrings.dineIn : AppStrings.takeAway,
        ),
        if (order.tableNumber != null)
          _buildInfoRow('Table:', order.tableNumber!),
        if (cashier != null) _buildInfoRow('Cashier:', cashier.fullName),
        pw.Divider(),

        // Items
        ...order.items.map((item) => _buildReceiptItem(item)),
        pw.Divider(),

        // Summary
        _buildSummaryRow('Subtotal:', Formatters.currency(order.subtotal)),
        _buildSummaryRow('Tax:', Formatters.currency(order.taxAmount)),
        if (order.discountAmount > 0)
          _buildSummaryRow('Discount:', '- ${Formatters.currency(order.discountAmount)}'),
        pw.SizedBox(height: 8),
        _buildSummaryRow(
          'TOTAL:',
          Formatters.currency(order.totalAmount),
          isBold: true,
        ),
        pw.Divider(),

        // Payment info
        _buildSummaryRow('Payment:', _getPaymentMethodName(transaction.paymentMethod)),
        if (transaction.paymentMethod == PaymentMethod.cash) ...[
          _buildSummaryRow('Paid:', Formatters.currency(transaction.amountPaid)),
          _buildSummaryRow('Change:', Formatters.currency(transaction.changeAmount)),
        ],
        pw.Divider(),

        // Footer
        pw.Center(
          child: pw.Column(
            children: [
              pw.Text(
                AppStrings.thankYou,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Powered by ${AppStrings.appName}',
                style: const pw.TextStyle(fontSize: 8),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
          pw.Text(value, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  pw.Widget _buildReceiptItem(OrderItem item) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      item.menuItemName,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    if (item.selectedVariant != null)
                      pw.Text('  ${item.selectedVariant!.name}', style: const pw.TextStyle(fontSize: 9)),
                    ...item.selectedModifiers.map(
                      (m) => pw.Text('  + ${m.name}', style: const pw.TextStyle(fontSize: 9)),
                    ),
                    if (item.notes != null && item.notes!.isNotEmpty)
                      pw.Text('  Note: ${item.notes}', style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
              ),
              pw.Text(
                Formatters.currency(item.itemTotal),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.Text(
            '${Formatters.currency(item.unitPrice)} x ${item.quantity}',
            style: const pw.TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return AppStrings.cash;
      case PaymentMethod.qris:
        return AppStrings.qris;
      case PaymentMethod.card:
        return AppStrings.card;
      case PaymentMethod.other:
        return AppStrings.other;
    }
  }
}

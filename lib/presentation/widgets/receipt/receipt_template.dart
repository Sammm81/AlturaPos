import 'package:flutter/material.dart';
import 'package:altura_pos/core/constants/app_strings.dart';
import 'package:altura_pos/core/utils/formatters.dart';
import 'package:altura_pos/domain/entities/order.dart';
import 'package:altura_pos/domain/entities/transaction.dart';
import 'package:altura_pos/domain/entities/user.dart';

class ReceiptTemplate extends StatelessWidget {
  const ReceiptTemplate({
    required this.order,
    required this.transaction,
    this.cashier,
    this.branchName,
    super.key,
  });

  final Order order;
  final Transaction transaction;
  final User? cashier;
  final String? branchName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header
          Text(
            branchName ?? AppStrings.appName,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Point of Sale System',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const Divider(height: 24),

          // Order info
          _InfoRow(
            label: 'Order No:',
            value: order.orderNumber,
          ),
          _InfoRow(
            label: 'Transaction:',
            value: transaction.transactionNumber,
          ),
          _InfoRow(
            label: 'Date:',
            value: Formatters.dateTime(order.createdAt),
          ),
          _InfoRow(
            label: 'Type:',
            value: order.orderType == OrderType.dineIn
                ? AppStrings.dineIn
                : AppStrings.takeAway,
          ),
          if (order.tableNumber != null)
            _InfoRow(
              label: 'Table:',
              value: order.tableNumber!,
            ),
          if (cashier != null)
            _InfoRow(
              label: 'Cashier:',
              value: cashier!.fullName,
            ),
          const Divider(height: 24),

          // Items
          ...order.items.map((item) => _ReceiptItem(item: item)),
          const Divider(height: 24),

          // Summary
          _SummaryRow(
            label: 'Subtotal:',
            value: Formatters.currency(order.subtotal),
          ),
          _SummaryRow(
            label: 'Tax:',
            value: Formatters.currency(order.taxAmount),
          ),
          if (order.discountAmount > 0)
            _SummaryRow(
              label: 'Discount:',
              value: '- ${Formatters.currency(order.discountAmount)}',
            ),
          const SizedBox(height: 8),
          _SummaryRow(
            label: 'TOTAL:',
            value: Formatters.currency(order.totalAmount),
            isBold: true,
          ),
          const Divider(height: 24),

          // Payment info
          _SummaryRow(
            label: 'Payment:',
            value: _getPaymentMethodName(transaction.paymentMethod),
          ),
          if (transaction.paymentMethod == PaymentMethod.cash) ...[
            _SummaryRow(
              label: 'Paid:',
              value: Formatters.currency(transaction.amountPaid),
            ),
            _SummaryRow(
              label: 'Change:',
              value: Formatters.currency(transaction.changeAmount),
            ),
          ],
          const Divider(height: 24),

          // Footer
          Text(
            AppStrings.thankYou,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Powered by ${AppStrings.appName}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
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

class _ReceiptItem extends StatelessWidget {
  const _ReceiptItem({required this.item});

  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item name and total
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.menuItemName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Variant
                    if (item.selectedVariant != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '  ${item.selectedVariant!.name}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                    // Modifiers
                    if (item.selectedModifiers.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      ...item.selectedModifiers.map((modifier) => Text(
                            '  + ${modifier.name}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          )),
                    ],
                    // Notes
                    if (item.notes != null && item.notes!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        '  Note: ${item.notes}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                Formatters.currency(item.itemTotal),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          // Unit price x quantity
          Text(
            '${Formatters.currency(item.unitPrice)} x ${item.quantity}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
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
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: (isBold
                    ? theme.textTheme.bodyLarge
                    : theme.textTheme.bodyMedium)
                ?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: (isBold
                    ? theme.textTheme.bodyLarge
                    : theme.textTheme.bodyMedium)
                ?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

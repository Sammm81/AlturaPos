import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/constants/app_strings.dart';
import 'package:altura_pos/domain/entities/transaction.dart';
import 'package:altura_pos/presentation/providers/payment_provider.dart';

class PaymentMethodSelector extends ConsumerWidget {
  const PaymentMethodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMethod = ref.watch(selectedPaymentMethodProvider);
    final theme = Theme.of(context);

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _PaymentMethodCard(
          icon: Icons.payments,
          label: AppStrings.cash,
          method: PaymentMethod.cash,
          isSelected: selectedMethod == PaymentMethod.cash,
          onTap: () {
            ref.read(paymentProvider.notifier).setPaymentMethod(PaymentMethod.cash);
          },
        ),
        _PaymentMethodCard(
          icon: Icons.qr_code_2,
          label: AppStrings.qris,
          method: PaymentMethod.qris,
          isSelected: selectedMethod == PaymentMethod.qris,
          onTap: () {
            ref.read(paymentProvider.notifier).setPaymentMethod(PaymentMethod.qris);
          },
        ),
        _PaymentMethodCard(
          icon: Icons.credit_card,
          label: AppStrings.card,
          method: PaymentMethod.card,
          isSelected: selectedMethod == PaymentMethod.card,
          onTap: () {
            ref.read(paymentProvider.notifier).setPaymentMethod(PaymentMethod.card);
          },
        ),
        _PaymentMethodCard(
          icon: Icons.more_horiz,
          label: AppStrings.other,
          method: PaymentMethod.other,
          isSelected: selectedMethod == PaymentMethod.other,
          onTap: () {
            ref.read(paymentProvider.notifier).setPaymentMethod(PaymentMethod.other);
          },
        ),
      ],
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.icon,
    required this.label,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? theme.colorScheme.primaryContainer.withOpacity(0.3)
              : theme.colorScheme.surface,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

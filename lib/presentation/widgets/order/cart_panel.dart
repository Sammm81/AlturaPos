import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/constants/app_strings.dart';
import 'package:altura_pos/core/utils/formatters.dart';
import 'package:altura_pos/presentation/providers/cart_provider.dart';
import 'package:altura_pos/presentation/widgets/common/custom_button.dart';

class CartPanel extends ConsumerWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final theme = Theme.of(context);

    if (cartState.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.emptyCart,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.emptyCartMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Cart items list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cartState.items.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final item = cartState.items[index];
              return _CartItemTile(item: item);
            },
          ),
        ),

        // Summary section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
          ),
          child: Column(
            children: [
              // Subtotal
              _SummaryRow(
                label: AppStrings.subtotal,
                value: Formatters.currency(cartState.subtotal),
              ),
              const SizedBox(height: 8),

              // Tax
              _SummaryRow(
                label: '${AppStrings.tax} (${(cartState.taxRate * 100).toInt()}%)',
                value: Formatters.currency(cartState.taxAmount),
              ),
              const SizedBox(height: 8),

              // Discount (if any)
              if (cartState.discountAmount > 0) ...[
                _SummaryRow(
                  label: AppStrings.discount,
                  value: '- ${Formatters.currency(cartState.discountAmount)}',
                  valueColor: theme.colorScheme.error,
                ),
                const SizedBox(height: 8),
              ],

              const Divider(),
              const SizedBox(height: 8),

              // Total
              _SummaryRow(
                label: AppStrings.total,
                value: Formatters.currency(cartState.totalAmount),
                labelStyle: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                valueStyle: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

              // Proceed to payment button
              CustomButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/payment');
                },
                text: AppStrings.proceedToPayment,
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  const _CartItemTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Item details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item name
              Text(
                item.menuItem.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              // Variant (if selected)
              if (item.selectedVariant != null) ...[
                Text(
                  item.selectedVariant!.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 2),
              ],

              // Modifiers (if any)
              if (item.selectedModifiers.isNotEmpty) ...[
                Text(
                  item.selectedModifiers.map((m) => m.name).join(', '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 2),
              ],

              // Notes (if any)
              if (item.notes != null && item.notes!.isNotEmpty) ...[
                Text(
                  'Note: ${item.notes}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
              ],

              const SizedBox(height: 8),

              // Unit price and total
              Row(
                children: [
                  Text(
                    Formatters.currency(item.unitPrice),
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    ' × ${item.quantity}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    Formatters.currency(item.itemTotal),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Quantity controls
        Column(
          children: [
            // Increase
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                ref
                    .read(cartProvider.notifier)
                    .updateItemQuantity(item.id, item.quantity + 1);
              },
              iconSize: 20,
            ),

            // Quantity
            Text(
              '${item.quantity}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            // Decrease
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                ref
                    .read(cartProvider.notifier)
                    .updateItemQuantity(item.id, item.quantity - 1);
              },
              iconSize: 20,
            ),

            const SizedBox(height: 8),

            // Remove
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                ref.read(cartProvider.notifier).removeItem(item.id);
              },
              iconSize: 20,
              color: theme.colorScheme.error,
            ),
          ],
        ),
      ],
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
              ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/constants/app_strings.dart';
import 'package:altura_pos/core/utils/validators.dart';
import 'package:altura_pos/domain/entities/order.dart';
import 'package:altura_pos/presentation/providers/order_provider.dart';
import 'package:altura_pos/presentation/widgets/common/custom_text_field.dart';

class OrderTypeSelector extends ConsumerWidget {
  const OrderTypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderType = ref.watch(orderTypeProvider);
    final theme = Theme.of(context);

    return PopupMenuButton<OrderType>(
      initialValue: orderType,
      onSelected: (type) {
        ref.read(orderProvider.notifier).setOrderType(type);
        
        // Show table number dialog for dine-in
        if (type == OrderType.dineIn) {
          _showTableNumberDialog(context, ref);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: OrderType.dineIn,
          child: Row(
            children: [
              Icon(
                Icons.restaurant,
                color: orderType == OrderType.dineIn
                    ? theme.colorScheme.primary
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                AppStrings.dineIn,
                style: TextStyle(
                  color: orderType == OrderType.dineIn
                      ? theme.colorScheme.primary
                      : null,
                  fontWeight: orderType == OrderType.dineIn
                      ? FontWeight.bold
                      : null,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: OrderType.takeAway,
          child: Row(
            children: [
              Icon(
                Icons.takeout_dining,
                color: orderType == OrderType.takeAway
                    ? theme.colorScheme.primary
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                AppStrings.takeAway,
                style: TextStyle(
                  color: orderType == OrderType.takeAway
                      ? theme.colorScheme.primary
                      : null,
                  fontWeight: orderType == OrderType.takeAway
                      ? FontWeight.bold
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
      child: Chip(
        avatar: Icon(
          orderType == OrderType.dineIn
              ? Icons.restaurant
              : Icons.takeout_dining,
          size: 18,
        ),
        label: Text(
          orderType == OrderType.dineIn
              ? AppStrings.dineIn
              : AppStrings.takeAway,
        ),
      ),
    );
  }

  void _showTableNumberDialog(BuildContext context, WidgetRef ref) {
    final orderState = ref.read(orderProvider);
    final controller = TextEditingController(text: orderState.tableNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.tableNumber),
        content: CustomTextField(
          controller: controller,
          labelText: AppStrings.tableNumber,
          hintText: AppStrings.enterTableNumber,
          keyboardType: TextInputType.text,
          validator: Validators.required,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(orderProvider.notifier)
                    .setTableNumber(controller.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text(AppStrings.ok),
          ),
        ],
      ),
    );
  }
}

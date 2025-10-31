import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/constants/app_strings.dart';
import 'package:altura_pos/core/utils/formatters.dart';
import 'package:altura_pos/domain/entities/menu_item.dart';
import 'package:altura_pos/presentation/providers/cart_provider.dart';
import 'package:altura_pos/presentation/widgets/common/custom_button.dart';

class ModifierSelectionDialog extends ConsumerStatefulWidget {
  const ModifierSelectionDialog({
    required this.menuItem,
    super.key,
  });

  final MenuItem menuItem;

  @override
  ConsumerState<ModifierSelectionDialog> createState() =>
      _ModifierSelectionDialogState();
}

class _ModifierSelectionDialogState
    extends ConsumerState<ModifierSelectionDialog> {
  Variant? _selectedVariant;
  final Set<Modifier> _selectedModifiers = {};
  int _quantity = 1;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-select first variant if available
    if (widget.menuItem.hasVariants && widget.menuItem.variants.isNotEmpty) {
      _selectedVariant = widget.menuItem.variants.first;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _calculatedPrice {
    double price = widget.menuItem.basePrice;
    
    if (_selectedVariant != null) {
      price = _selectedVariant!.price;
    }
    
    for (final modifier in _selectedModifiers) {
      price += modifier.price;
    }
    
    return price;
  }

  double get _totalPrice => _calculatedPrice * _quantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.menuItem.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.menuItem.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.menuItem.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer
                                  .withOpacity(0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Variants section
                    if (widget.menuItem.hasVariants &&
                        widget.menuItem.variants.isNotEmpty) ...[
                      Text(
                        'Select Size',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...widget.menuItem.variants.map((variant) {
                        final isSelected = _selectedVariant?.id == variant.id;
                        return RadioListTile<Variant>(
                          value: variant,
                          groupValue: _selectedVariant,
                          onChanged: (value) {
                            setState(() {
                              _selectedVariant = value;
                            });
                          },
                          title: Text(variant.name),
                          subtitle: Text(Formatters.currency(variant.price)),
                          selected: isSelected,
                        );
                      }),
                      const SizedBox(height: 20),
                    ],

                    // Modifiers section
                    if (widget.menuItem.modifiers.isNotEmpty) ...[
                      Text(
                        'Add-ons',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...widget.menuItem.modifiers.map((modifier) {
                        final isSelected = _selectedModifiers.contains(modifier);
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                _selectedModifiers.add(modifier);
                              } else {
                                _selectedModifiers.remove(modifier);
                              }
                            });
                          },
                          title: Text(modifier.name),
                          subtitle: Text(
                            '+ ${Formatters.currency(modifier.price)}',
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                    ],

                    // Notes section
                    Text(
                      'Special Instructions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        hintText: 'Add notes (optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),

                    // Quantity selector
                    Text(
                      'Quantity',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _quantity > 1
                              ? () {
                                  setState(() {
                                    _quantity--;
                                  });
                                }
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$_quantity',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            setState(() {
                              _quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Footer with price and add button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Price',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          Formatters.currency(_totalPrice),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      onPressed: _addToCart,
                      text: AppStrings.addToCart,
                      isFullWidth: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart() {
    ref.read(cartProvider.notifier).addItem(
          menuItem: widget.menuItem,
          selectedVariant: _selectedVariant,
          selectedModifiers: _selectedModifiers.toList(),
          quantity: _quantity,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.menuItem.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

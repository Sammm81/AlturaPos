import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/constants/app_strings.dart';
import 'package:altura_pos/core/utils/formatters.dart';
import 'package:altura_pos/presentation/providers/payment_provider.dart';

class CashPaymentPanel extends ConsumerStatefulWidget {
  const CashPaymentPanel({
    required this.totalAmount,
    super.key,
  });

  final double totalAmount;

  @override
  ConsumerState<CashPaymentPanel> createState() => _CashPaymentPanelState();
}

class _CashPaymentPanelState extends ConsumerState<CashPaymentPanel> {
  String _inputAmount = '';

  double get _parsedAmount {
    if (_inputAmount.isEmpty) return 0.0;
    return double.tryParse(_inputAmount) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);
    final theme = Theme.of(context);
    final changeAmount = paymentState.changeAmount;
    final isInsufficientAmount = _parsedAmount > 0 && _parsedAmount < widget.totalAmount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.amountPaid,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Amount input display
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isInsufficientAmount
                      ? theme.colorScheme.error
                      : theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Text(
                _inputAmount.isEmpty
                    ? 'Rp 0'
                    : Formatters.currency(_parsedAmount),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isInsufficientAmount
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
                textAlign: TextAlign.right,
              ),
            ),

            if (isInsufficientAmount) ...[
              const SizedBox(height: 8),
              Text(
                AppStrings.insufficientAmount,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Quick amount buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _QuickAmountButton(
                  amount: widget.totalAmount,
                  label: 'Exact',
                  onTap: () => _setAmount(widget.totalAmount),
                ),
                _QuickAmountButton(
                  amount: _roundUpAmount(widget.totalAmount, 50000),
                  label: '50K',
                  onTap: () => _setAmount(_roundUpAmount(widget.totalAmount, 50000)),
                ),
                _QuickAmountButton(
                  amount: _roundUpAmount(widget.totalAmount, 100000),
                  label: '100K',
                  onTap: () => _setAmount(_roundUpAmount(widget.totalAmount, 100000)),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Numpad
            _Numpad(
              onNumberTap: _appendNumber,
              onClear: _clearInput,
              onBackspace: _backspace,
            ),

            const SizedBox(height: 20),

            // Change amount display
            if (changeAmount > 0) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.change,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      Formatters.currency(changeAmount),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _appendNumber(String number) {
    setState(() {
      _inputAmount += number;
      ref.read(paymentProvider.notifier).setAmountPaid(_parsedAmount);
    });
  }

  void _clearInput() {
    setState(() {
      _inputAmount = '';
      ref.read(paymentProvider.notifier).setAmountPaid(0.0);
    });
  }

  void _backspace() {
    if (_inputAmount.isEmpty) return;
    setState(() {
      _inputAmount = _inputAmount.substring(0, _inputAmount.length - 1);
      ref.read(paymentProvider.notifier).setAmountPaid(_parsedAmount);
    });
  }

  void _setAmount(double amount) {
    setState(() {
      _inputAmount = amount.toInt().toString();
      ref.read(paymentProvider.notifier).setAmountPaid(amount);
    });
  }

  double _roundUpAmount(double amount, double roundTo) {
    return ((amount / roundTo).ceil() * roundTo).toDouble();
  }
}

class _QuickAmountButton extends StatelessWidget {
  const _QuickAmountButton({
    required this.amount,
    required this.label,
    required this.onTap,
  });

  final double amount;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: onTap,
      child: Text(
        '$label\n${Formatters.currencyCompact(amount)}',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}

class _Numpad extends StatelessWidget {
  const _Numpad({
    required this.onNumberTap,
    required this.onClear,
    required this.onBackspace,
  });

  final Function(String) onNumberTap;
  final VoidCallback onClear;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _NumpadButton(label: '1', onTap: () => onNumberTap('1')),
            _NumpadButton(label: '2', onTap: () => onNumberTap('2')),
            _NumpadButton(label: '3', onTap: () => onNumberTap('3')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _NumpadButton(label: '4', onTap: () => onNumberTap('4')),
            _NumpadButton(label: '5', onTap: () => onNumberTap('5')),
            _NumpadButton(label: '6', onTap: () => onNumberTap('6')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _NumpadButton(label: '7', onTap: () => onNumberTap('7')),
            _NumpadButton(label: '8', onTap: () => onNumberTap('8')),
            _NumpadButton(label: '9', onTap: () => onNumberTap('9')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _NumpadButton(label: 'C', onTap: onClear, isAction: true),
            _NumpadButton(label: '0', onTap: () => onNumberTap('0')),
            _NumpadButton(
              label: '⌫',
              onTap: onBackspace,
              isAction: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _NumpadButton extends StatelessWidget {
  const _NumpadButton({
    required this.label,
    required this.onTap,
    this.isAction = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AspectRatio(
          aspectRatio: 1.5,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: isAction
                  ? theme.colorScheme.secondaryContainer
                  : theme.colorScheme.surface,
              foregroundColor: isAction
                  ? theme.colorScheme.onSecondaryContainer
                  : theme.colorScheme.onSurface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Text(
              label,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

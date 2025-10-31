import 'package:flutter/material.dart';

/// Custom elevated button widget
class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isFullWidth = false,
    super.key,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(text),
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}

/// Custom outlined button widget
class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    required this.onPressed,
    required this.text,
    this.isFullWidth = false,
    super.key,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: onPressed,
      child: Text(text),
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}

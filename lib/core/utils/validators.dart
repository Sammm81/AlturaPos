import 'package:altura_pos/core/constants/app_strings.dart';

/// Input validation utilities
class Validators {
  Validators._();

  /// Validate required field
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName ${AppStrings.fieldRequired.toLowerCase()}'
          : AppStrings.fieldRequired;
    }
    return null;
  }

  /// Validate username (alphanumeric and underscore, 3-20 characters)
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.length < 3 || value.length > 20) {
      return 'Username must be 3-20 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscore';
    }
    return null;
  }

  /// Validate password (minimum 6 characters)
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  /// Validate email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  /// Validate phone number (Indonesian format)
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    final phoneRegex = RegExp(r'^(\+62|62|0)[0-9]{9,12}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s-]'), ''))) {
      return AppStrings.invalidPhone;
    }
    return null;
  }

  /// Validate number (positive)
  static String? positiveNumber(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Invalid number';
    }
    if (number <= 0) {
      return '${fieldName ?? 'Value'} must be greater than 0';
    }
    return null;
  }

  /// Validate integer
  static String? integer(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    final number = int.tryParse(value);
    if (number == null) {
      return 'Invalid number';
    }
    return null;
  }

  /// Validate table number (alphanumeric)
  static String? tableNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value.trim())) {
      return 'Table number can only contain letters and numbers';
    }
    return null;
  }

  /// Validate amount paid vs total
  static String? amountPaid(String? value, double totalAmount) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Invalid amount';
    }
    if (amount < totalAmount) {
      return AppStrings.insufficientAmount;
    }
    return null;
  }

  /// Validate minimum length
  static String? minLength(String? value, int length, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.length < length) {
      return '${fieldName ?? 'Field'} must be at least $length characters';
    }
    return null;
  }

  /// Validate maximum length
  static String? maxLength(String? value, int length, {String? fieldName}) {
    if (value == null) return null;
    if (value.length > length) {
      return '${fieldName ?? 'Field'} must not exceed $length characters';
    }
    return null;
  }

  /// Validate range
  static String? range(
    String? value,
    double min,
    double max, {
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Invalid number';
    }
    if (number < min || number > max) {
      return '${fieldName ?? 'Value'} must be between $min and $max';
    }
    return null;
  }

  /// Combine multiple validators
  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}

import 'package:flutter/material.dart';

/// App color constants following Material 3 design system
class AppColors {
  AppColors._();

  // Light Theme Colors
  static const Color primaryLight = Color(0xFFFF6F00); // Orange
  static const Color secondaryLight = Color(0xFF455A64); // Blue Grey
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color errorLight = Color(0xFFD32F2F);
  static const Color successLight = Color(0xFF388E3C);
  static const Color warningLight = Color(0xFFF57C00);
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFFFFB74D); // Light Orange
  static const Color secondaryDark = Color(0xFF90A4AE); // Light Blue Grey
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color errorDark = Color(0xFFEF5350);
  static const Color successDark = Color(0xFF66BB6A);
  static const Color warningDark = Color(0xFFFFB74D);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);

  // Semantic Colors
  static const Color online = Color(0xFF4CAF50);
  static const Color offline = Color(0xFF9E9E9E);
  static const Color syncing = Color(0xFF2196F3);
  static const Color syncPending = Color(0xFFFF9800);
  static const Color syncFailed = Color(0xFFF44336);

  // Order Status Colors
  static const Color orderDraft = Color(0xFF9E9E9E);
  static const Color orderConfirmed = Color(0xFF2196F3);
  static const Color orderCompleted = Color(0xFF4CAF50);
  static const Color orderCancelled = Color(0xFFF44336);

  // Payment Method Colors
  static const Color cashPayment = Color(0xFF4CAF50);
  static const Color qrisPayment = Color(0xFF9C27B0);
  static const Color cardPayment = Color(0xFF2196F3);
  static const Color otherPayment = Color(0xFF607D8B);
}

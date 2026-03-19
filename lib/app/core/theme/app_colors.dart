import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF3F51B5);
  static const Color primaryLight = Color(0xFF757DE8);
  static const Color primaryDark = Color(0xFF002984);

  // Secondary Colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryLight = Color(0xFF66FFF9);
  static const Color secondaryDark = Color(0xFF00A896);

  // Background Colors
  static const Color scaffoldBackground = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color surfaceBackground = Color(0xFFFAFAFA);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Colors.white;

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color warning = Color(0xFFFFC107);
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);

  // Transaction Type Colors
  static const Color expense = Color(0xFFE53935);
  static const Color expenseLight = Color(0xFFFFEBEE);
  static const Color income = Color(0xFF43A047);
  static const Color incomeLight = Color(0xFFE8F5E9);
  static const Color transfer = Color(0xFF1E88E5);
  static const Color transferLight = Color(0xFFE3F2FD);

  // Account Type Colors
  static const Color bank = Color(0xFF5C6BC0);
  static const Color bankLight = Color(0xFFE8EAF6);
  static const Color cash = Color(0xFF66BB6A);
  static const Color cashLight = Color(0xFFE8F5E9);
  static const Color upi = Color(0xFF7E57C2);
  static const Color upiLight = Color(0xFFEDE7F6);
  static const Color creditCard = Color(0xFFEF5350);
  static const Color creditCardLight = Color(0xFFFFEBEE);

  // Border & Divider
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Input Field Colors
  static const Color inputFill = Color(0xFFFAFAFA);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputFocusBorder = primary;

  // Gradient Colors
  static const List<Color> primaryGradient = [primary, primaryLight];
  static const List<Color> incomeGradient = [income, Color(0xFF81C784)];
  static const List<Color> expenseGradient = [expense, Color(0xFFEF5350)];

  // Helper Methods
  static Color getTransactionColor(String type) {
    switch (type) {
      case 'expense':
        return expense;
      case 'income':
        return income;
      case 'transfer':
        return transfer;
      default:
        return textSecondary;
    }
  }

  static Color getTransactionLightColor(String type) {
    switch (type) {
      case 'expense':
        return expenseLight;
      case 'income':
        return incomeLight;
      case 'transfer':
        return transferLight;
      default:
        return surfaceBackground;
    }
  }

  static Color getAccountColor(String type) {
    switch (type) {
      case 'bank':
        return bank;
      case 'cash':
        return cash;
      case 'upi':
        return upi;
      case 'credit_card':
        return creditCard;
      default:
        return primary;
    }
  }

  static Color getAccountLightColor(String type) {
    switch (type) {
      case 'bank':
        return bankLight;
      case 'cash':
        return cashLight;
      case 'upi':
        return upiLight;
      case 'credit_card':
        return creditCardLight;
      default:
        return primaryLight.withValues(alpha: 0.1);
    }
  }
}
